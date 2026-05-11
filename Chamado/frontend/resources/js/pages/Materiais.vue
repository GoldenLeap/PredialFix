<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Head } from '@inertiajs/vue3';
import { ref } from 'vue';
import { 
    Package, 
    AlertTriangle, 
    AlertCircle, 
    CheckCircle2, 
    Search, 
    Filter, 
    Plus,
    Edit2,
    Trash2,
    MapPin,
    Calendar
} from 'lucide-vue-next';

const breadcrumbs = [
    { title: 'Painel', href: '/dashboard' },
    { title: 'Materiais', href: '/materiais' },
];

const stats = [
    { label: 'Total', value: 10, icon: Package, color: 'text-gray-500', bg: 'bg-gray-100' },
    { label: 'Crítico', value: 1, icon: AlertTriangle, color: 'text-red-500', bg: 'bg-red-100' },
    { label: 'Baixo', value: 8, icon: AlertCircle, color: 'text-orange-500', bg: 'bg-orange-100' },
    { label: 'Adequado', value: 1, icon: CheckCircle2, color: 'text-green-500', bg: 'bg-green-100' },
];

const materials = ref([
    { id: 1, name: 'Lâmpada LED 12W', category: 'Elétrica', current: 30, min: 50, location: 'Almoxarifado A1', updated: 'Atualizado em 15/03/2024', status: 'Baixo' },
    { id: 2, name: 'Lâmpada LED 12W', category: 'Elétrica', current: 30, min: 50, location: 'Almoxarifado A1', updated: 'Atualizado em 15/03/2024', status: 'Baixo' },
    { id: 3, name: 'Lâmpada LED 12W', category: 'Elétrica', current: 30, min: 50, location: 'Almoxarifado A1', updated: 'Atualizado em 15/03/2024', status: 'Baixo' },
    { id: 4, name: 'Lâmpada LED 12W', category: 'Elétrica', current: 30, min: 50, location: 'Almoxarifado A1', updated: 'Atualizado em 15/03/2024', status: 'Baixo' },
    { id: 5, name: 'Registro 3/4"', category: 'Hidráulica', current: 8, min: 20, location: 'Oficina Predial', updated: 'Atualizado em 15/03/2024', status: 'Crítico' },
    { id: 6, name: 'Martelo', category: 'Ferramentas', current: 60, min: 50, location: 'Oficina Predial', updated: 'Atualizado em 15/03/2024', status: 'Adequado' },
    { id: 7, name: 'Capacete', category: 'EPIs', current: 45, min: 70, location: 'Almoxarifado A1', updated: 'Atualizado em 15/03/2024', status: 'Baixo' },
    { id: 8, name: 'Lâmpada LED 12W', category: 'Elétrica', current: 30, min: 50, location: 'Almoxarifado A1', updated: 'Atualizado em 15/03/2024', status: 'Baixo' },
]);

const getStatusColor = (status: string) => {
    switch (status) {
        case 'Crítico': return 'bg-red-500 text-white';
        case 'Baixo': return 'bg-orange-500 text-white';
        case 'Adequado': return 'bg-green-500 text-white';
        default: return 'bg-gray-500 text-white';
    }
};

const getProgressColor = (status: string) => {
    switch (status) {
        case 'Crítico': return 'bg-red-500';
        case 'Baixo': return 'bg-orange-400';
        case 'Adequado': return 'bg-green-500';
        default: return 'bg-gray-400';
    }
};
</script>

<template>
    <Head title="Materiais" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="p-6 space-y-6 bg-[#f8f9fa] min-h-screen">
            <div class="flex justify-between items-center">
                <h2 class="text-xl font-bold text-gray-800">Gestão de materiais</h2>
                <button class="bg-[#ff3d3d] hover:bg-[#e63535] text-white font-bold py-2 px-6 rounded-lg flex items-center gap-2 transition-colors shadow-sm">
                    <Plus class="w-5 h-5" />
                    Novo material
                </button>
            </div>

            <!-- Stats Grid -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div v-for="stat in stats" :key="stat.label" class="bg-white p-4 rounded-xl shadow-sm border border-gray-100 flex items-center justify-between">
                    <div>
                        <p class="text-[10px] text-gray-500 font-medium uppercase tracking-wider">{{ stat.label }}</p>
                        <p class="text-2xl font-bold mt-1">{{ stat.value }}</p>
                    </div>
                    <div :class="[stat.bg, 'p-3 rounded-lg']">
                        <component :is="stat.icon" :class="['w-6 h-6', stat.color]" />
                    </div>
                </div>
            </div>

            <!-- Search and Filter -->
            <div class="bg-white p-2 rounded-lg shadow-sm border border-gray-100 flex gap-2">
                <div class="relative flex-1">
                    <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                    <input type="text" placeholder="Pesquisar por ID ou assunto" class="w-full pl-10 pr-4 py-2 border-none rounded-lg focus:ring-0 text-sm" />
                </div>
                <button class="flex items-center gap-2 px-4 py-2 text-gray-500 hover:bg-gray-50 rounded-lg text-sm border-l border-gray-100">
                    <Filter class="w-4 h-4" />
                    Todas
                </button>
            </div>

            <!-- Materials Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                <div v-for="mat in materials" :key="mat.id" class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden group hover:shadow-md transition-shadow">
                    <div class="p-4 space-y-4">
                        <div class="flex justify-between items-start">
                            <div class="bg-gray-100 p-2 rounded-lg group-hover:bg-red-50 transition-colors">
                                <Package class="w-5 h-5 text-gray-500 group-hover:text-red-500" />
                            </div>
                            <span :class="['text-[10px] font-bold px-2 py-0.5 rounded uppercase', getStatusColor(mat.status)]">
                                {{ mat.status }}
                            </span>
                        </div>

                        <div>
                            <h4 class="font-bold text-gray-800 text-sm line-clamp-1">{{ mat.name }}</h4>
                            <p class="text-[10px] text-gray-400 font-medium">{{ mat.category }}</p>
                        </div>

                        <div class="space-y-1">
                            <div class="flex justify-between text-[10px] font-bold">
                                <span>{{ mat.current }} <span class="text-gray-400 font-normal">/ {{ mat.min }} un</span></span>
                            </div>
                            <div class="w-full bg-gray-100 h-2 rounded-full overflow-hidden">
                                <div :class="[getProgressColor(mat.status), 'h-full transition-all duration-500']" :style="{ width: Math.min((mat.current / mat.min) * 100, 100) + '%' }"></div>
                            </div>
                        </div>

                        <div class="space-y-1.5 pt-2 border-t border-gray-50">
                            <div class="flex items-center gap-1.5 text-gray-500 text-[10px]">
                                <MapPin class="w-3 h-3" />
                                {{ mat.location }}
                            </div>
                            <div class="flex items-center gap-1.5 text-gray-400 text-[10px]">
                                <Calendar class="w-3 h-3" />
                                {{ mat.updated }}
                            </div>
                        </div>

                        <div class="grid grid-cols-2 gap-2 pt-2">
                            <button class="bg-[#ffdcdc] hover:bg-[#ffc8c8] text-white py-1.5 rounded-lg flex items-center justify-center transition-colors">
                                <Edit2 class="w-3.5 h-3.5" />
                            </button>
                            <button class="bg-[#ffdcdc] hover:bg-[#ffc8c8] text-white py-1.5 rounded-lg flex items-center justify-center transition-colors">
                                <Trash2 class="w-3.5 h-3.5" />
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
