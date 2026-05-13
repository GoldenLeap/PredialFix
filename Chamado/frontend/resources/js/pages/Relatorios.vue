<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
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

const props = defineProps<{
    reports: any;
    stats: any;
    chamadosByTipo: any[];
    chamadosByMonth: any[];
}>();

const searchQuery = ref('');
const selectedStatus = ref('');
const selectedTipo = ref('');

const statusOptions = ['Aberto', 'Em Análise', 'Em Execução', 'Concluído'];
const tipos = ['Elétrica', 'Hidráulica', 'Infraestrutura', 'Outros'];

const filteredReports = computed(() => {
    let result = props.reports.data || props.reports;
    if (searchQuery.value) {
        const q = searchQuery.value.toLowerCase();
        result = result.filter((r: any) =>
            r.id.toString().includes(q) ||
            (r.assunto && r.assunto.toLowerCase().includes(q))
        );
    }
    if (selectedStatus.value) {
        result = result.filter((r: any) => r.status === selectedStatus.value);
    }
    if (selectedTipo.value) {
        result = result.filter((r: any) => r.tipo === selectedTipo.value);
    }
    return result;
});

const handlePrint = () => {
    if (typeof window !== 'undefined') {
        window.print();
    }
};

const getStatusBadgeClass = (status: string) => {
    const s = status.toLowerCase();
    if (s.includes('aberto')) return 'bg-blue-100 text-blue-700';
    if (s.includes('análise') || s.includes('analise')) return 'bg-amber-100 text-amber-700';
    if (s.includes('execução') || s.includes('execucao') || s.includes('progresso')) return 'bg-indigo-100 text-indigo-700';
    if (s.includes('concluído') || s.includes('concluido')) return 'bg-emerald-100 text-emerald-700';
    return 'bg-gray-100 text-gray-700';
};

const getPriorityBadgeClass = (priority: string) => {
    if (priority === 'Alta') return 'bg-red-100 text-red-700';
    if (priority === 'Média') return 'bg-amber-100 text-amber-700';
    return 'bg-gray-100 text-gray-700';
};
</script>

<template>
    <Head title="Relatórios" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="p-6 space-y-6">
            <div>
                <h2 class="text-xl font-bold text-gray-800 dark:text-white">Relatórios e Histórico de Serviços</h2>
                <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">Visualize e exporte registros de serviços de manutenção</p>
            </div>

            <!-- Stats Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
                <div class="bg-white dark:bg-zinc-900 p-6 rounded-xl shadow-sm border border-gray-100 dark:border-zinc-800">
                    <p class="text-[10px] text-gray-500 dark:text-gray-400 font-medium mb-1 uppercase tracking-wider">Total de Chamados</p>
                    <p class="text-2xl font-black text-gray-900 dark:text-white">{{ stats.total }}</p>
                </div>
                <div class="bg-blue-50 dark:bg-blue-900/20 p-6 rounded-xl shadow-sm border border-blue-100 dark:border-blue-900/30">
                    <p class="text-[10px] text-blue-600 dark:text-blue-400 font-medium mb-1 uppercase tracking-wider">Abertos</p>
                    <p class="text-2xl font-black text-blue-700 dark:text-blue-300">{{ stats.abertos }}</p>
                </div>
                <div class="bg-amber-50 dark:bg-amber-900/20 p-6 rounded-xl shadow-sm border border-amber-100 dark:border-amber-900/30">
                    <p class="text-[10px] text-amber-600 dark:text-amber-400 font-medium mb-1 uppercase tracking-wider">Em Análise</p>
                    <p class="text-2xl font-black text-amber-700 dark:text-amber-300">{{ stats.em_analise }}</p>
                </div>
                <div class="bg-indigo-50 dark:bg-indigo-900/20 p-6 rounded-xl shadow-sm border border-indigo-100 dark:border-indigo-900/30">
                    <p class="text-[10px] text-indigo-600 dark:text-indigo-400 font-medium mb-1 uppercase tracking-wider">Em Execução</p>
                    <p class="text-2xl font-black text-indigo-700 dark:text-indigo-300">{{ stats.em_execucao }}</p>
                </div>
                <div class="bg-emerald-50 dark:bg-emerald-900/20 p-6 rounded-xl shadow-sm border border-emerald-100 dark:border-emerald-900/30">
                    <p class="text-[10px] text-emerald-600 dark:text-emerald-400 font-medium mb-1 uppercase tracking-wider">Concluídos</p>
                    <p class="text-2xl font-black text-emerald-700 dark:text-emerald-300">{{ stats.concluidos }}</p>
                </div>
            </div>

            <!-- Filters -->
            <div class="bg-white dark:bg-zinc-900 p-4 rounded-xl shadow-sm border border-gray-100 dark:border-zinc-800 space-y-4">
                <h3 class="text-sm font-bold text-gray-800 dark:text-white">Filtros e pesquisa</h3>
                <div class="flex flex-wrap gap-3 items-center">
                    <div class="relative flex-1 min-w-[200px]">
                        <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                        <input
                            type="text"
                            v-model="searchQuery"
                            placeholder="Procurar por ID ou assunto..."
                            class="w-full pl-10 pr-4 py-2 bg-gray-50 dark:bg-zinc-800 border-gray-200 dark:border-zinc-700 rounded-lg text-sm text-gray-700 dark:text-gray-300 focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-transparent"
                        />
                    </div>
                    <select
                        v-model="selectedStatus"
                        class="px-4 py-2 bg-gray-50 dark:bg-zinc-800 border-gray-200 dark:border-zinc-700 rounded-lg text-sm text-gray-700 dark:text-gray-300 focus:outline-none focus:ring-2 focus:ring-red-500"
                    >
                        <option value="">Todos os status</option>
                        <option v-for="s in statusOptions" :key="s" :value="s">{{ s }}</option>
                    </select>
                    <select
                        v-model="selectedTipo"
                        class="px-4 py-2 bg-gray-50 dark:bg-zinc-800 border-gray-200 dark:border-zinc-700 rounded-lg text-sm text-gray-700 dark:text-gray-300 focus:outline-none focus:ring-2 focus:ring-red-500"
                    >
                        <option value="">Todos os tipos</option>
                        <option v-for="t in tipos" :key="t" :value="t">{{ t }}</option>
                    </select>
                    <button @click="handlePrint" class="flex items-center gap-2 px-4 py-2 text-gray-600 hover:bg-gray-100 dark:hover:bg-zinc-800 rounded-lg text-sm border border-gray-200 dark:border-zinc-700 transition-colors">
                        <FileDown class="w-4 h-4" />
                        Exportar PDF
                    </button>
                </div>
            </div>

            <!-- Table -->
            <div class="bg-white dark:bg-zinc-900 rounded-xl shadow-sm border border-gray-100 dark:border-zinc-800 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm">
                        <thead class="bg-red-600 text-white font-bold uppercase tracking-wider">
                            <tr>
                                <th class="py-3 px-4">ID</th>
                                <th class="py-3 px-4">Data</th>
                                <th class="py-3 px-4">Tipo</th>
                                <th class="py-3 px-4">Assunto</th>
                                <th class="py-3 px-4">Status</th>
                                <th class="py-3 px-4">Prioridade</th>
                                <th class="py-3 px-4">Solicitante</th>
                                <th class="py-3 px-4">Ações</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100 dark:divide-zinc-800">
                            <tr
                                v-for="report in filteredReports"
                                :key="report.id"
                                class="hover:bg-gray-50 dark:hover:bg-zinc-800/50 transition-colors"
                            >
                                <td class="py-3 px-4 font-bold text-gray-900 dark:text-white">#{{ report.id }}</td>
                                <td class="py-3 px-4 text-gray-600 dark:text-gray-400">{{ new Date(report.created_at).toLocaleDateString() }}</td>
                                <td class="py-3 px-4 text-gray-800 dark:text-gray-300 font-medium">{{ report.tipo }}</td>
                                <td class="py-3 px-4 text-gray-600 dark:text-gray-400 truncate max-w-[150px]">{{ report.assunto || report.descricao?.substring(0, 50) }}</td>
                                <td class="py-3 px-4">
                                    <span :class="['px-2.5 py-1 rounded-full text-[10px] font-bold uppercase', getStatusBadgeClass(report.status)]">
                                        {{ report.status }}
                                    </span>
                                </td>
                                <td class="py-3 px-4">
                                    <span :class="['px-2.5 py-1 rounded-full text-[10px] font-bold uppercase', getPriorityBadgeClass(report.prioridade)]">
                                        {{ report.prioridade }}
                                    </span>
                                </td>
                                <td class="py-3 px-4 text-gray-600 dark:text-gray-400 text-xs">{{ report.user?.name || 'N/A' }}</td>
                                <td class="py-3 px-4">
                                    <Link :href="`/chamados/${report.id}`" class="text-blue-600 hover:text-blue-800 dark:text-blue-400 dark:hover:text-blue-300 text-sm font-medium">
                                        Ver detalhes →
                                    </Link>
                                </td>
                            </tr>
                            <tr v-if="filteredReports.length === 0">
                                <td colspan="8" class="py-10 text-center text-gray-400 italic">
                                    Nenhum chamado encontrado.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div v-if="props.reports.links" class="bg-gray-50 dark:bg-zinc-800/50 px-6 py-4 flex items-center justify-between border-t border-gray-100 dark:border-zinc-800">
                    <p class="text-xs text-gray-500 dark:text-gray-400">
                        Mostrando {{ props.reports.from || 0 }}–{{ props.reports.to || 0 }} de {{ props.reports.total }} resultados
                    </p>
                    <div class="flex gap-1">
                        <Link
                            v-for="(link, idx) in props.reports.links"
                            :key="idx"
                            :href="link.url"
                            class="px-3 py-1 rounded-lg text-xs font-bold transition-colors"
                            :class="{
                                'bg-red-600 text-white': link.active,
                                'bg-white dark:bg-zinc-800 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-zinc-700 border border-gray-200 dark:border-zinc-700': !link.active,
                                'opacity-50 cursor-default': !link.url
                            }"
                            v-html="link.label"
                        />
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
@media print {
    .no-print { display: none !important; }
}
</style>
