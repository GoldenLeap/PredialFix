<script setup lang="ts">
import { Head, Link, usePage } from '@inertiajs/vue3';
import { Droplet, Lightbulb, Wrench, Bell, LogOut, X } from 'lucide-vue-next';
import { computed, ref, onMounted, onUnmounted } from 'vue';
import logoSenai from '../../images/logo senai.png';
import logoPredial from '../../images/logo.png';

const props = defineProps<{
    recentChamados: any[];
}>();

const page = usePage();
const user = computed(() => page.props.auth.user);

// Estado do Modal (Dropdown)
const showNotificationsModal = ref(false);

const toggleNotifications = () => {
    showNotificationsModal.value = !showNotificationsModal.value;
};

// Fechar ao clicar fora (opcional, básico)
const closeDropdown = (e: MouseEvent) => {
    const target = e.target as HTMLElement;
    if (!target.closest('.notification-container')) {
        showNotificationsModal.value = false;
    }
};

onMounted(() => document.addEventListener('click', closeDropdown));
onUnmounted(() => document.removeEventListener('click', closeDropdown));

// Gerar notificações a partir do histórico recente dos chamados
const notifications = computed(() => {
    let notifs: any[] = [];
    props.recentChamados.forEach(c => {
        if (c.historicos && c.historicos.length > 0) {
            // Pega o último histórico de cada chamado
            const lastHist = c.historicos[c.historicos.length - 1];
            notifs.push({
                id: lastHist.id,
                chamado_id: c.id,
                tipo: c.tipo,
                status_novo: lastHist.status_novo,
                mensagem: `O status da sua solicitação #${c.id} foi alterado para `,
                data: new Date(lastHist.data_alteracao)
            });
        }
    });
    // Ordena da mais recente para a mais antiga e mostra as últimas 5
    return notifs.sort((a, b) => b.data.getTime() - a.data.getTime()).slice(0, 5);
});

const getStatusClass = (status: string) => {
    const s = status ? status.toLowerCase() : '';
    if (s.includes('execução') || s.includes('progresso')) return 'bg-[#0081C9] text-white';
    if (s.includes('análise')) return 'bg-[#F2994A] text-white';
    if (s.includes('aberto')) return 'bg-[#BDBDBD] text-white';
    if (s.includes('concluído')) return 'bg-[#27AE60] text-white';
    return 'bg-gray-200 text-gray-700';
};

const getIcon = (tipo: string) => {
    const t = tipo ? tipo.toLowerCase() : '';
    if (t.includes('vazamento') || t.includes('água') || t.includes('banheiro')) return Droplet;
    if (t.includes('luz') || t.includes('lâmpada') || t.includes('elétrica')) return Lightbulb;
    return Wrench;
};

const formatTime = (date: string) => {
    if (!date) return '---';
    const created = new Date(date);
    const now = new Date();
    const diffInHours = Math.floor((now.getTime() - created.getTime()) / (1000 * 60 * 60));
    
    if (diffInHours < 1) return 'Menos de 1 hora atrás';
    if (diffInHours === 1) return '1 hora atrás';
    if (diffInHours < 24) return `${diffInHours} horas atrás`;
    return created.toLocaleDateString();
};
</script>

<template>
    <Head title="Início" />

    <div class="min-h-screen bg-white font-sans text-black overflow-x-hidden">
        
        <!-- Top Nav com Perfil e Notificações -->
        <nav class="bg-white px-6 py-4 flex justify-between items-center sticky top-0 z-20 text-gray-800 border-b border-gray-100 shadow-sm relative">
            <!-- Logo SENAI -->
            <div class="font-black italic tracking-widest text-xl text-[#ED1C24]">
                <img :src="logoSenai" class="h-10" alt="" srcset="">
            </div>
            
            <div class="flex items-center gap-6">
                <!-- Notificações  -->
                <div class="relative notification-container">
                    <button @click="toggleNotifications" class="relative cursor-pointer focus:outline-none hover:opacity-80 transition-opacity p-1">
                        <Bell class="w-6 h-6 text-gray-400 hover:text-[#ED1C24] transition-colors" />
                        <span v-if="notifications.length > 0" class="absolute -top-1.5 -right-1.5 w-4 h-4 bg-[#ED1C24] border-[1.5px] border-white rounded-full flex items-center justify-center text-[9px] font-black text-white shadow-sm">
                            {{ notifications.length }}
                        </span>
                    </button>

                    <!-- Dropdown Modal de Notificações -->
                    <div 
                        v-if="showNotificationsModal" 
                        class="absolute right-0 top-12 w-80 bg-white border border-gray-200 shadow-2xl rounded-2xl overflow-hidden z-50 transform origin-top-right transition-all"
                    >
                        <!-- Cabeçalho do Dropdown -->
                        <div class="bg-gray-50 border-b border-gray-100 px-5 py-4 flex items-center justify-between">
                            <span class="font-black text-gray-800 text-sm tracking-tight">Notificações</span>
                            <span v-if="notifications.length > 0" class="text-[10px] text-white bg-amber-500 px-2 py-0.5 rounded-md font-bold uppercase tracking-widest">{{ notifications.length }} novas</span>
                        </div>
                        
                        <!-- Lista -->
                        <div class="max-h-80 overflow-y-auto">
                            <!-- Vazio -->
                            <div v-if="notifications.length === 0" class="p-8 text-center flex flex-col items-center">
                                <Bell class="w-8 h-8 text-gray-200 mb-2" />
                                <p class="text-gray-400 text-sm font-bold">Notificações vazias</p>
                                <p class="text-[10px] text-gray-300 mt-1 uppercase tracking-widest">Nenhuma novidade por enquanto</p>
                            </div>
                            
                            <!-- Com notificações -->
                            <div v-else class="flex flex-col">
                                <Link 
                                    v-for="notif in notifications" 
                                    :key="notif.id"
                                    :href="`/chamados/${notif.chamado_id}`"
                                    class="p-5 border-b border-gray-50 hover:bg-amber-50/50 transition-colors block group"
                                >
                                    <div class="flex items-start gap-3">
                                        <div class="w-2 h-2 rounded-full bg-[#ED1C24] mt-1.5 flex-shrink-0"></div>
                                        <div>
                                            <p class="text-xs text-gray-700 font-medium leading-snug mb-1.5 group-hover:text-black transition-colors">
                                                {{ notif.mensagem }} <span class="font-black text-[#ED1C24] uppercase">{{ notif.status_novo }}</span>
                                            </p>
                                            <span class="text-[9px] text-gray-400 font-bold uppercase tracking-widest flex items-center gap-1">
                                                {{ formatTime(notif.data.toString()) }}
                                            </span>
                                        </div>
                                    </div>
                                </Link>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Divisor -->
                <div class="w-px h-6 bg-gray-200"></div>

                <!-- Perfil e Logout -->
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-full bg-[#ED1C24] text-white flex items-center justify-center font-black text-sm uppercase shadow-md">
                        {{ user.name.charAt(0) }}
                    </div>
                    <div class="hidden md:flex flex-col">
                        <span class="text-sm font-bold leading-none mb-1">{{ user.name }}</span>
                        <Link href="/logout" method="post" as="button" class="text-[11px] text-gray-400 hover:text-[#ED1C24] uppercase tracking-widest text-left transition-colors flex items-center gap-1 font-bold">
                            Sair <LogOut class="w-3 h-3" />
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Header Vermelho -->
        <div class="bg-[#ED1C24] pt-12 pb-24 flex flex-col items-center px-4">
            <img :src="logoPredial" alt="" srcset="">
            <p class="text-white/90 text-2xl font-black mb-8 text-center tracking-tight">
                Sistema de Manutenção Predial
            </p>

            <Link 
                href="/chamados/create"
                class="bg-white text-[#ED1C24] hover:bg-gray-100 px-14 py-4 rounded-full font-black shadow-2xl transition-all active:scale-95 text-xl uppercase tracking-tight flex items-center gap-2"
            >
                Abrir chamado
            </Link>
        </div>

        <!-- Conteúdo Principal -->
        <div class="max-w-2xl mx-auto px-4 -mt-10">
            <div class="bg-white rounded-t-[45px] pt-10 pb-20 shadow-[0_-10px_40px_rgba(0,0,0,0.05)] border-t border-gray-50">
                
                <!-- Solicitações Ativas -->
                <div class="flex flex-col items-center mb-10">
                    <h2 class="font-black text-3xl text-gray-900 tracking-tight">Suas solicitações ativas</h2>
                    <div class="h-1 w-12 bg-[#ED1C24] mt-2 rounded-full"></div>
                </div>

                <div class="space-y-6 px-4">
                    <Link 
                        v-for="chamado in recentChamados" 
                        :key="chamado.id"
                        class="border border-gray-100 rounded-[35px] p-6 flex items-center gap-6 shadow-sm hover:shadow-lg transition-all bg-white group block cursor-pointer"
                        :href="`/chamados/${chamado.id}`"
                    >
                        <div class="bg-gray-50 p-5 rounded-full flex-shrink-0 group-hover:scale-110 transition-transform">
                            <component :is="getIcon(chamado.tipo)" class="h-10 w-10 text-gray-800" />
                        </div>
                        
                        <div class="flex-1 min-w-0">
                            <h3 class="font-black text-2xl text-gray-900 leading-tight mb-1 truncate">{{ chamado.tipo }}</h3>
                            <p class="text-sm text-gray-400 font-bold mb-4 uppercase tracking-wide">{{ chamado.local }}</p>
                            
                            <div class="flex items-center gap-4">
                                <span 
                                    class="px-5 py-1.5 rounded-full text-[10px] font-black whitespace-nowrap uppercase tracking-[0.1em] shadow-sm"
                                    :class="getStatusClass(chamado.status)"
                                >
                                    {{ chamado.status }}
                                </span>
                                <span class="text-[10px] text-gray-300 font-black uppercase tracking-widest">
                                    {{ formatTime(chamado.created_at) }}
                                </span>
                            </div>
                        </div>
                    </Link>

                    <div v-if="recentChamados.length === 0" class="py-20 text-center animate-in fade-in zoom-in duration-700">
                        <div class="bg-gray-50 rounded-[40px] p-12 border-2 border-dashed border-gray-100">
                             <p class="text-gray-300 font-black text-lg uppercase tracking-tight mb-4">Você não possui solicitações ativas</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.bg-white { background-color: #ffffff !important; }
</style>
