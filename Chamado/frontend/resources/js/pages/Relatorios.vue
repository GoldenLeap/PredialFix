<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Head } from '@inertiajs/vue3';
import { ref } from 'vue';
import { 
    Search, 
    Filter, 
    FileDown, 
    Download,
    ChevronLeft,
    ChevronRight
} from 'lucide-vue-next';

const breadcrumbs = [
    { title: 'Painel', href: '/dashboard' },
    { title: 'Relatórios', href: '/relatorios' },
];

const stats = [
    { label: 'Serviços totais', value: '10' },
    { label: 'Custos totais', value: 'R$ 0' },
    { label: 'Mão de obra', value: 'R$ 0' },
    { label: 'Custos de materiais', value: 'R$ 0' },
];

const reports = ref(Array(10).fill({
    id: 'ID do chamado',
    date: 'Data',
    service: 'Serviço',
    priority: 'Prioridade',
    status: 'Status',
    technician: 'Nome',
    labor: 'R$ 0',
    materials: 'R$ 0',
    total: 'R$ 0'
}));
</script>

<template>
    <Head title="Relatórios" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="p-6 space-y-6 bg-[#f8f9fa] min-h-screen">
            <div>
                <h2 class="text-xl font-bold text-gray-800">Relatórios e histórico de serviço</h2>
                <p class="text-xs text-gray-500 mt-1">Ver e exportar registros de serviço de manutenção</p>
            </div>

            <!-- Stats Grid -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <div v-for="stat in stats" :key="stat.label" class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                    <p class="text-[10px] text-gray-500 font-medium mb-1">{{ stat.label }}</p>
                    <p class="text-xl font-bold">{{ stat.value }}</p>
                </div>
            </div>

            <!-- Filters -->
            <div class="bg-white p-4 rounded-xl shadow-sm border border-gray-100 space-y-4">
                <h3 class="text-sm font-bold text-gray-800">Filtros e pesquisa</h3>
                <div class="flex flex-wrap gap-4 items-center">
                    <div class="relative flex-1 min-w-[200px]">
                        <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                        <input type="text" placeholder="Procurar por ID de chamado" class="w-full pl-10 pr-4 py-2 bg-gray-50 border-gray-200 rounded-lg text-sm focus:ring-red-500 focus:border-red-500" />
                    </div>
                    <button class="flex items-center gap-2 px-4 py-2 text-gray-500 hover:bg-gray-50 rounded-lg text-xs border border-gray-100">
                        <Filter class="w-4 h-4 text-gray-400" />
                        Todas as prioridades
                    </button>
                    <button class="flex items-center gap-2 px-4 py-2 text-gray-500 hover:bg-gray-50 rounded-lg text-xs border border-gray-100">
                        <Filter class="w-4 h-4 text-gray-400" />
                        Todos os status
                    </button>
                    <button class="flex items-center gap-2 px-4 py-2 text-gray-500 hover:bg-gray-50 rounded-lg text-xs border border-gray-100">
                        <FileDown class="w-4 h-4 text-gray-400" />
                        Exportar PDF
                    </button>
                    <button class="flex items-center gap-2 px-4 py-2 text-gray-500 hover:bg-gray-50 rounded-lg text-xs border border-gray-100">
                        <Download class="w-4 h-4 text-gray-400" />
                        Exportar CSV
                    </button>
                </div>
            </div>

            <!-- Table -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-xs">
                        <thead class="bg-[#ff3d3d] text-white font-bold uppercase tracking-wider">
                            <tr>
                                <th class="py-3 px-4">ID do chamado</th>
                                <th class="py-3 px-4">Data</th>
                                <th class="py-3 px-4">Serviço</th>
                                <th class="py-3 px-4">Prioridade</th>
                                <th class="py-3 px-4">Status</th>
                                <th class="py-3 px-4">Técnico</th>
                                <th class="py-3 px-4">Mão de obra</th>
                                <th class="py-3 px-4">Materiais</th>
                                <th class="py-3 px-4">Gastos totais</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100">
                            <tr v-for="(report, idx) in reports" :key="idx" class="hover:bg-gray-50 transition-colors">
                                <td class="py-4 px-4 text-gray-500">{{ report.id }}</td>
                                <td class="py-4 px-4 text-gray-500">{{ report.date }}</td>
                                <td class="py-4 px-4 text-gray-800 font-medium">{{ report.service }}</td>
                                <td class="py-4 px-4 text-gray-500">{{ report.priority }}</td>
                                <td class="py-4 px-4 text-gray-500">{{ report.status }}</td>
                                <td class="py-4 px-4 text-gray-500">{{ report.technician }}</td>
                                <td class="py-4 px-4 text-gray-500">{{ report.labor }}</td>
                                <td class="py-4 px-4 text-gray-500">{{ report.materials }}</td>
                                <td class="py-4 px-4 font-bold text-gray-800">{{ report.total }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Footer / Pagination -->
                <div class="bg-[#ff3d3d] px-6 py-4 flex items-center justify-between text-white rounded-b-xl">
                    <p class="text-xs font-bold uppercase">Exibindo 10 resultados</p>
                    <div class="flex items-center gap-2">
                        <button class="bg-white text-[#ff3d3d] px-4 py-1.5 rounded-lg text-xs font-bold hover:bg-gray-100 transition-colors">Anterior</button>
                        <button class="bg-white text-[#ff3d3d] w-8 h-8 flex items-center justify-center rounded-lg text-xs font-bold">1</button>
                        <button class="text-white w-8 h-8 flex items-center justify-center rounded-lg text-xs font-bold hover:bg-red-400">2</button>
                        <button class="text-white w-8 h-8 flex items-center justify-center rounded-lg text-xs font-bold hover:bg-red-400">3</button>
                        <button class="bg-white text-[#ff3d3d] px-4 py-1.5 rounded-lg text-xs font-bold hover:bg-gray-100 transition-colors">Próximo</button>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
