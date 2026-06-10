<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import { ClipboardList, AlertCircle, Wrench, CheckCircle2, TrendingUp, Package, Users, ArrowRight, Clock } from 'lucide-vue-next';
import { computed } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    stats: { total: number; abertos: number; em_analise: number; em_execucao: number; concluidos: number; };
    recentChamados: any[];
    recentMaterials: any[];
    topUsers: any[];
}>();

const formatDateTime = (d: string) => d ? new Date(d).toLocaleString('pt-BR', { day:'2-digit', month:'2-digit', year:'numeric', hour:'2-digit', minute:'2-digit' }) : '-';

const breadcrumbs: BreadcrumbItem[] = [{ title: 'Dashboard', href: '/dashboard' }];

const criticalMaterials = computed(() => props.recentMaterials?.filter((m: any) => (m.quantidade_atual||0) < (m.quantidade_minima||0)) || []);
const resolutionRate = computed(() => props.stats.total ? Math.round((props.stats.concluidos / props.stats.total) * 100) : 0);

const statusConfig: Record<string, {color:string;bg:string;dot:string}> = {
    'Aberto':              {color:'text-sky-600',    bg:'bg-sky-50 dark:bg-sky-900/20',      dot:'bg-sky-500'},
    'Em Análise':          {color:'text-amber-600',  bg:'bg-amber-50 dark:bg-amber-900/20',  dot:'bg-amber-500'},
    'Aguardando Material': {color:'text-orange-600', bg:'bg-orange-50 dark:bg-orange-900/20',dot:'bg-orange-500'},
    'Em Execução':         {color:'text-primary',    bg:'bg-primary/10',                     dot:'bg-primary'},
    'Concluído':           {color:'text-emerald-600',bg:'bg-emerald-50 dark:bg-emerald-900/20',dot:'bg-emerald-500'},
};
const getS = (s: string) => statusConfig[s] || {color:'text-muted-foreground', bg:'bg-muted', dot:'bg-muted-foreground'};
const prioColor: Record<string,string> = { Alta:'text-rose-500', Média:'text-amber-500', Baixa:'text-emerald-500' };
</script>

<template>
    <Head title="Dashboard" />
    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="flex flex-col gap-6 animate-in fade-in slide-in-from-bottom-3 duration-500">
            <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
                <div>
                    <h1 class="text-2xl font-black tracking-tight">Painel de Controle</h1>
                    <p class="text-sm text-muted-foreground mt-1">Visão geral do sistema de manutenção predial.</p>
                </div>
                <div class="flex items-center gap-2 text-xs text-muted-foreground bg-muted px-3 py-1.5 rounded-full border border-border">
                    <Clock class="w-3.5 h-3.5" /><span>Atualizado em tempo real</span>
                </div>
            </div>

            <!-- KPI Cards -->
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
                <div class="bg-card border border-border rounded-2xl p-5 shadow-sm hover:shadow-md transition-all group">
                    <div class="flex items-center justify-between mb-3">
                        <span class="text-xs font-semibold text-muted-foreground uppercase tracking-wider">Total</span>
                        <div class="p-2 bg-muted rounded-xl group-hover:bg-primary/10 transition-colors">
                            <ClipboardList class="w-4 h-4 text-muted-foreground group-hover:text-primary" />
                        </div>
                    </div>
                    <p class="text-4xl font-black tracking-tight">{{ stats.total }}</p>
                    <p class="text-xs text-muted-foreground mt-1">registrados</p>
                </div>
                <div class="bg-card border border-primary/20 rounded-2xl p-5 shadow-sm hover:shadow-md transition-all">
                    <div class="flex items-center justify-between mb-3">
                        <span class="text-xs font-semibold text-primary uppercase tracking-wider">Abertos</span>
                        <div class="p-2 bg-primary/10 rounded-xl"><AlertCircle class="w-4 h-4 text-primary" /></div>
                    </div>
                    <p class="text-4xl font-black text-primary tracking-tight">{{ stats.abertos }}</p>
                    <p class="text-xs text-muted-foreground mt-1">aguardando triagem</p>
                </div>
                <div class="bg-card border border-amber-200 dark:border-amber-800 rounded-2xl p-5 shadow-sm hover:shadow-md transition-all">
                    <div class="flex items-center justify-between mb-3">
                        <span class="text-xs font-semibold text-amber-500 uppercase tracking-wider">Em Análise</span>
                        <div class="p-2 bg-amber-50 dark:bg-amber-900/20 rounded-xl"><ClipboardList class="w-4 h-4 text-amber-500" /></div>
                    </div>
                    <p class="text-4xl font-black text-amber-600 dark:text-amber-400 tracking-tight">{{ stats.em_analise }}</p>
                    <p class="text-xs text-muted-foreground mt-1">sendo avaliados</p>
                </div>
                <div class="bg-card border border-primary/30 rounded-2xl p-5 shadow-sm hover:shadow-md transition-all">
                    <div class="flex items-center justify-between mb-3">
                        <span class="text-xs font-semibold text-primary uppercase tracking-wider">Execução</span>
                        <div class="p-2 bg-primary/10 rounded-xl"><Wrench class="w-4 h-4 text-primary" /></div>
                    </div>
                    <p class="text-4xl font-black text-primary tracking-tight">{{ stats.em_execucao }}</p>
                    <p class="text-xs text-muted-foreground mt-1">em andamento</p>
                </div>
                <div class="bg-card border border-emerald-200 dark:border-emerald-800 rounded-2xl p-5 shadow-sm hover:shadow-md transition-all">
                    <div class="flex items-center justify-between mb-3">
                        <span class="text-xs font-semibold text-emerald-500 uppercase tracking-wider">Concluídos</span>
                        <div class="p-2 bg-emerald-50 dark:bg-emerald-900/20 rounded-xl"><CheckCircle2 class="w-4 h-4 text-emerald-500" /></div>
                    </div>
                    <p class="text-4xl font-black text-emerald-600 dark:text-emerald-400 tracking-tight">{{ stats.concluidos }}</p>
                    <p class="text-xs text-muted-foreground mt-1">finalizados</p>
                </div>
            </div>

            <!-- Main Grid -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Chamados Recentes -->
                <div class="lg:col-span-2 bg-card border border-border rounded-2xl shadow-sm overflow-hidden flex flex-col">
                    <div class="px-6 py-4 border-b border-border flex justify-between items-center">
                        <h2 class="font-bold text-base">Solicitações Ativas</h2>
                        <Link href="/chamados" class="text-xs font-semibold text-primary hover:text-primary/80 flex items-center gap-1">
                            Ver todas <ArrowRight class="w-3 h-3" />
                        </Link>
                    </div>
                    <div class="overflow-x-auto flex-1">
                        <table class="w-full text-left text-sm">
                            <thead class="bg-muted/50 text-muted-foreground text-[11px] uppercase tracking-wider border-b border-border">
                                <tr>
                                    <th class="px-5 py-3 font-semibold">Chamado</th>
                                    <th class="px-5 py-3 font-semibold">Solicitante</th>
                                    <th class="px-5 py-3 font-semibold">Status</th>
                                    <th class="px-5 py-3 font-semibold">Prioridade</th>
                                    <th class="px-5 py-3 font-semibold">Data</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-border">
                                <tr v-for="chamado in recentChamados" :key="chamado.id" class="hover:bg-muted/30 transition-colors">
                                    <td class="px-5 py-3.5">
                                        <Link :href="`/chamados/${chamado.id}`" class="font-semibold hover:text-primary transition-colors">
                                            #{{ chamado.id }} <span class="font-normal text-muted-foreground text-xs">{{ chamado.tipo }}</span>
                                        </Link>
                                        <p class="text-xs text-muted-foreground mt-0.5 truncate max-w-[160px]">{{ chamado.local }}</p>
                                    </td>
                                    <td class="px-5 py-3.5">
                                        <div class="flex items-center gap-2">
                                            <div class="w-7 h-7 rounded-full bg-primary/10 text-primary flex items-center justify-center text-[11px] font-bold flex-shrink-0">
                                                {{ (chamado.user?.name || '?').charAt(0).toUpperCase() }}
                                            </div>
                                            <span class="text-sm font-medium truncate max-w-[110px]">{{ chamado.user?.name || 'N/A' }}</span>
                                        </div>
                                    </td>
                                    <td class="px-5 py-3.5">
                                        <span :class="['inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-bold', getS(chamado.status).bg, getS(chamado.status).color]">
                                            <span :class="['w-1.5 h-1.5 rounded-full', getS(chamado.status).dot]"></span>
                                            {{ chamado.status }}
                                        </span>
                                    </td>
                                    <td class="px-5 py-3.5">
                                        <span :class="['text-xs font-bold', prioColor[chamado.prioridade]||'text-muted-foreground']">{{ chamado.prioridade }}</span>
                                    </td>
                                    <td class="px-5 py-3.5 text-muted-foreground text-xs whitespace-nowrap">{{ formatDateTime(chamado.created_at) }}</td>
                                </tr>
                                <tr v-if="!recentChamados?.length">
                                    <td colspan="5" class="px-6 py-12 text-center text-muted-foreground italic text-sm">Nenhuma solicitação ativa.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Coluna Direita -->
                <div class="flex flex-col gap-5">
                    <!-- Taxa de Resolução -->
                    <div class="bg-card border border-border rounded-2xl p-5 shadow-sm">
                        <div class="flex items-center justify-between mb-4">
                            <h3 class="font-bold text-sm">Taxa de Resolução</h3>
                            <TrendingUp class="w-4 h-4 text-emerald-500" />
                        </div>
                        <p class="text-5xl font-black tracking-tight">{{ resolutionRate }}%</p>
                        <div class="mt-4 h-2 bg-muted rounded-full overflow-hidden">
                            <div class="h-full bg-emerald-500 rounded-full transition-all duration-700" :style="{ width: resolutionRate + '%' }"></div>
                        </div>
                        <p class="text-xs text-muted-foreground mt-2">{{ stats.concluidos }} de {{ stats.total }} resolvidos</p>
                    </div>

                    <!-- Estoque Crítico -->
                    <div class="bg-card border border-border rounded-2xl shadow-sm overflow-hidden">
                        <div class="px-5 py-4 border-b border-border flex items-center justify-between">
                            <h3 class="font-bold text-sm flex items-center gap-2"><Package class="w-4 h-4 text-rose-500" />Estoque Crítico</h3>
                            <Link href="/materiais" class="text-xs font-semibold text-primary hover:text-primary/80">Ver tudo</Link>
                        </div>
                        <div class="p-4 space-y-2">
                            <div v-for="mat in criticalMaterials.slice(0, 5)" :key="mat.id"
                                 class="flex items-center justify-between gap-3 p-2.5 rounded-xl bg-rose-50 dark:bg-rose-900/20 border border-rose-100 dark:border-rose-800">
                                <div class="min-w-0">
                                    <p class="text-sm font-semibold truncate">{{ mat.nome }}</p>
                                    <p class="text-xs text-muted-foreground">{{ mat.categoria }}</p>
                                </div>
                                <span class="text-xs font-black text-rose-600 bg-rose-100 dark:bg-rose-900/50 px-2 py-1 rounded-lg flex-shrink-0">
                                    {{ mat.quantidade_atual }}/{{ mat.quantidade_minima }}
                                </span>
                            </div>
                            <div v-if="!criticalMaterials.length" class="py-8 text-center text-sm text-emerald-600 font-semibold">
                                <CheckCircle2 class="w-8 h-8 mx-auto mb-2 text-emerald-500" />Estoque normalizado!
                            </div>
                        </div>
                    </div>

                    <!-- Usuários Mais Ativos -->
                    <div class="bg-card border border-border rounded-2xl shadow-sm overflow-hidden">
                        <div class="px-5 py-4 border-b border-border flex items-center gap-2">
                            <Users class="w-4 h-4 text-muted-foreground" />
                            <h3 class="font-bold text-sm">Mais Ativos</h3>
                        </div>
                        <div class="p-4 space-y-3">
                            <div v-for="(user, idx) in topUsers" :key="user.id" class="flex items-center gap-3">
                                <span class="text-xs font-black text-muted-foreground w-4">{{ idx + 1 }}</span>
                                <div class="w-8 h-8 rounded-full bg-gradient-to-br from-primary to-blue-400 flex items-center justify-center text-white text-xs font-black flex-shrink-0">
                                    {{ user.name.charAt(0).toUpperCase() }}
                                </div>
                                <div class="flex-1 min-w-0">
                                    <p class="text-sm font-semibold truncate">{{ user.name }}</p>
                                    <p class="text-[10px] text-muted-foreground capitalize">{{ user.cargo }}</p>
                                </div>
                                <span class="text-sm font-black text-primary">{{ user.chamados_count }}</span>
                            </div>
                            <div v-if="!topUsers?.length" class="py-6 text-center text-sm text-muted-foreground italic">Sem dados.</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>