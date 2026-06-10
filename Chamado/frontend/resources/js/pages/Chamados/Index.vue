<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { Download, Search } from 'lucide-vue-next';
import { ref, computed } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';

const breadcrumbs = [
    { title: 'Painel', href: '/dashboard' },
    { title: 'Chamados', href: '/chamados' },
];

const props = defineProps<{
    chamados: any[];
}>();

const formatDateTime = (dateString: string) => {
    if (!dateString) {
return '-';
}

    const date = new Date(dateString);

    return date.toLocaleString('pt-BR', { 
        day: '2-digit', 
        month: '2-digit', 
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
};

const startDate = ref('');
const endDate = ref('');
const category = ref('');
const searchQuery = ref('');

const categories = computed(() => [...new Set(props.chamados.map(c => c.tipo))]);

// Métricas para o Dashboard
const stats = computed(() => {
    const total = filteredChamados.value.length;
    const atual = props.chamados.filter(c => {
        const d = new Date(c.created_at);
        const now = new Date();

        return d.getMonth() === now.getMonth() && d.getFullYear() === now.getFullYear();
    }).length;
    const alta = filteredChamados.value.filter(c => c.prioridade === 'Alta').length;
    const concluidos = filteredChamados.value.filter(c => c.status === 'Concluído').length;

    return { total, atual, alta, concluidos };
});

const currentPage = ref(1);
const itemsPerPage = 10;

const filteredChamados = computed(() => {
    let result = props.chamados;

    if (startDate.value) {
        result = result.filter(c => new Date(c.created_at) >= new Date(startDate.value));
    }

    if (endDate.value) {
        const end = new Date(endDate.value);
        end.setDate(end.getDate() + 1);
        result = result.filter(c => new Date(c.created_at) < end);
    }

    if (category.value) {
        result = result.filter(c => c.tipo === category.value);
    }

    if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        result = result.filter(c => 
            c.id.toString().includes(query) || 
            (c.nif && c.nif.toLowerCase().includes(query)) ||
            (c.patrimonio && c.patrimonio.toLowerCase().includes(query)) ||
            (c.descricao && c.descricao.toLowerCase().includes(query)) ||
            (c.local && c.local.toLowerCase().includes(query)) ||
            (c.assunto && c.assunto.toLowerCase().includes(query)) ||
            (c.bloco && c.bloco.toLowerCase().includes(query))
        );
    }

    return result;
});

const paginatedChamados = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage;

    return filteredChamados.value.slice(start, start + itemsPerPage);
});

const totalPages = computed(() => Math.ceil(filteredChamados.value.length / itemsPerPage));

const changePage = (page: number) => {
    if (page >= 1 && page <= totalPages.value) {
        currentPage.value = page;
    }
};

const exportCSV = () => {
    if (filteredChamados.value.length === 0) {
        return;
    }

    const headers = ['ID', 'NIF', 'Solicitante', 'Email', 'Bloco', 'Patrimonio', 'Data/Hora', 'Categoria', 'Assunto', 'Status', 'Prioridade'];
    const rows = filteredChamados.value.map(c => [
        c.id, 
        c.nif || '-',
        c.user?.name || '-',
        c.user?.email || '-',
        c.bloco || '-',
        c.patrimonio || '-',
        formatDateTime(c.created_at),
        `"${c.tipo}"`, 
        `"${c.assunto || c.descricao || c.local}"`, 
        `"${c.status}"`,
        `"${c.prioridade}"`
    ]);
    const csvContent = "data:text/csv;charset=utf-8," + headers.join(',') + "\n" + rows.map(e => e.join(",")).join("\n");
    const link = document.createElement("a");
    link.setAttribute("href", encodeURI(csvContent));
    link.setAttribute("download", "historico_chamados.csv");
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
};

const goToDetails = (id: number) => {
    router.visit(`/chamados/${id}`);
};

const clearFilters = () => {
    startDate.value = '';
    endDate.value = '';
    category.value = '';
    searchQuery.value = '';
    currentPage.value = 1;
};

const handlePrint = () => {
    if (typeof window !== 'undefined') {
        window.print();
    }
};
</script>

<template>
    <Head title="Histórico de Chamados" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="flex flex-col gap-6 animate-in fade-in slide-in-from-bottom-3 duration-500">

            <!-- Header -->
            <div class="flex flex-col md:flex-row justify-between items-start gap-4">
                <div>
                    <h1 class="text-2xl font-black tracking-tight">Histórico de Chamados</h1>
                    <p class="text-sm text-muted-foreground mt-1">Visualize e gerencie todos os chamados registrados no sistema.</p>
                </div>
                <div class="flex gap-3">
                    <button @click="handlePrint" class="inline-flex items-center gap-2 px-4 py-2.5 border border-border bg-card hover:bg-muted rounded-xl text-sm font-semibold transition-all">
                        <Download class="w-4 h-4" />PDF
                    </button>
                    <button @click="exportCSV" class="inline-flex items-center gap-2 px-4 py-2.5 border border-border bg-card hover:bg-muted rounded-xl text-sm font-semibold transition-all">
                        <Download class="w-4 h-4" />CSV
                    </button>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                <div class="bg-card border border-border rounded-2xl p-5 text-center shadow-sm">
                    <span class="text-xs font-bold uppercase tracking-widest text-muted-foreground mb-1 block">Este Mês</span>
                    <span class="text-5xl font-black">{{ stats.atual }}</span>
                    <p class="text-xs text-muted-foreground mt-2">Total geral: {{ stats.total }}</p>
                </div>
                <div class="bg-rose-50 dark:bg-rose-900/20 border border-rose-200 dark:border-rose-800 rounded-2xl p-5 text-center shadow-sm">
                    <span class="text-xs font-bold uppercase tracking-widest text-rose-500 mb-1 block">Alta Prioridade</span>
                    <span class="text-5xl font-black text-rose-600 dark:text-rose-400">{{ stats.alta }}</span>
                    <p class="text-xs text-muted-foreground mt-2">Requer atenção imediata</p>
                </div>
                <div class="bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800 rounded-2xl p-5 text-center shadow-sm">
                    <span class="text-xs font-bold uppercase tracking-widest text-emerald-500 mb-1 block">Concluídos</span>
                    <span class="text-5xl font-black text-emerald-600 dark:text-emerald-400">{{ stats.concluidos }}</span>
                    <p class="text-xs text-muted-foreground mt-2">Eficiência de atendimento</p>
                </div>
            </div>

            <!-- Filtros -->
            <div class="bg-card border border-border rounded-2xl p-5 shadow-sm mb-6">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-4">
                    <div class="flex flex-col gap-1.5">
                        <label class="text-xs font-semibold text-muted-foreground uppercase tracking-wider">Data Inicial</label>
                        <input type="date" v-model="startDate" class="border border-input bg-background rounded-xl px-3 py-2.5 text-sm outline-none focus:ring-2 focus:ring-primary">
                    </div>
                    <div class="flex flex-col gap-1.5">
                        <label class="text-xs font-semibold text-muted-foreground uppercase tracking-wider">Data Final</label>
                        <input type="date" v-model="endDate" class="border border-input bg-background rounded-xl px-3 py-2.5 text-sm outline-none focus:ring-2 focus:ring-primary">
                    </div>
                    <div class="flex flex-col gap-1.5">
                        <label class="text-xs font-semibold text-muted-foreground uppercase tracking-wider">Categoria</label>
                        <select v-model="category" class="border border-input bg-background rounded-xl px-3 py-2.5 text-sm outline-none focus:ring-2 focus:ring-primary">
                            <option value="">Todas as categorias</option>
                            <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
                        </select>
                    </div>
                    <div class="flex flex-col justify-end">
                        <button @click="clearFilters" class="bg-muted hover:bg-muted/80 font-semibold py-2.5 px-4 rounded-xl transition-all text-sm">
                            Limpar Filtros
                        </button>
                    </div>
                </div>
                <div class="relative">
                    <Search class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                    <input type="text" v-model="searchQuery" placeholder="Pesquisar por ID, NIF, Assunto..."
                        class="w-full pl-12 pr-5 py-3 bg-muted/50 border border-border rounded-xl text-sm outline-none focus:ring-2 focus:ring-primary transition-all">
                </div>
            </div>

            <!-- Tabela -->
            <div class="bg-card rounded-2xl border border-border overflow-hidden shadow-sm">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse min-w-[1100px]">
                        <thead>
                            <tr class="bg-primary text-primary-foreground">
                                <th class="px-4 py-3.5 font-semibold text-xs tracking-wide">ID</th>
                                <th class="px-4 py-3.5 font-semibold text-xs tracking-wide">Solicitante</th>
                                <th class="px-4 py-3.5 font-semibold text-xs tracking-wide">Bloco</th>
                                <th class="px-4 py-3.5 font-semibold text-xs tracking-wide">Data/Hora</th>
                                <th class="px-4 py-3.5 font-semibold text-xs tracking-wide">Categoria</th>
                                <th class="px-4 py-3.5 font-semibold text-xs tracking-wide">Assunto</th>
                                <th class="px-4 py-3.5 font-semibold text-xs tracking-wide">Status</th>
                                <th class="px-4 py-3.5 font-semibold text-xs tracking-wide">Prioridade</th>
                            </tr>
                        </thead>
                        <tbody class="text-sm divide-y divide-border">
                            <tr v-for="chamado in paginatedChamados" :key="chamado.id"
                                @click="goToDetails(chamado.id)"
                                class="hover:bg-muted/50 transition-colors cursor-pointer group">
                                <td class="px-4 py-3.5 font-bold text-primary group-hover:text-primary/80">#{{ chamado.id }}</td>
                                <td class="px-4 py-3.5">
                                    <div class="font-medium">{{ chamado.user?.name || '-' }}</div>
                                    <div class="text-xs text-muted-foreground">{{ chamado.user?.email || '-' }}</div>
                                </td>
                                <td class="px-4 py-3.5 text-muted-foreground">{{ chamado.bloco || '-' }}</td>
                                <td class="px-4 py-3.5 text-muted-foreground text-xs whitespace-nowrap">{{ formatDateTime(chamado.created_at) }}</td>
                                <td class="px-4 py-3.5 text-muted-foreground">{{ chamado.tipo }}</td>
                                <td class="px-4 py-3.5 truncate max-w-[180px]">{{ chamado.assunto || chamado.descricao || chamado.local }}</td>
                                <td class="px-4 py-3.5">
                                    <span class="px-2.5 py-1 rounded-full text-[10px] font-bold bg-muted text-muted-foreground uppercase tracking-wider">
                                        {{ chamado.status }}
                                    </span>
                                </td>
                                <td class="px-4 py-3.5">
                                    <span :class="{'font-bold text-xs': true, 'text-rose-500': chamado.prioridade==='Alta', 'text-amber-500': chamado.prioridade==='Média', 'text-emerald-500': chamado.prioridade==='Baixa'}">
                                        {{ chamado.prioridade }}
                                    </span>
                                </td>
                            </tr>
                            <tr v-if="!paginatedChamados.length">
                                <td colspan="8" class="px-10 py-20 text-center italic text-muted-foreground">Nenhum chamado encontrado.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination Footer -->
                <div class="bg-primary px-6 py-4 flex flex-col md:flex-row justify-between items-center text-primary-foreground gap-4">
                    <div class="text-sm font-semibold">Exibindo {{ filteredChamados.length }} resultados</div>
                    <div class="flex gap-2 items-center">
                        <button @click="changePage(currentPage - 1)" :disabled="currentPage === 1"
                            class="bg-white/20 hover:bg-white/30 px-4 py-1.5 rounded-lg text-xs font-bold disabled:opacity-30 transition-all">Anterior</button>
                        <div class="flex gap-1 mx-2">
                            <button v-for="p in totalPages" :key="p" @click="changePage(p)"
                                :class="['w-8 h-8 flex items-center justify-center rounded-lg text-xs font-bold transition-all cursor-pointer', currentPage===p ? 'bg-white text-primary shadow-sm' : 'hover:bg-white/20']">{{ p }}</button>
                        </div>
                        <button @click="changePage(currentPage + 1)" :disabled="currentPage === totalPages"
                            class="bg-white/20 hover:bg-white/30 px-4 py-1.5 rounded-lg text-xs font-bold disabled:opacity-30 transition-all">Próximo</button>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>@media print {
    .no-print { display: none !important; }
    .print-container { width: 100%; max-width: none; padding: 0; margin: 0; }
    .bg-\[\#ED1C24\] { background-color: #ED1C24 !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
    .text-white { color: #ffffff !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
    .text-gray-400 { color: #9ca3af !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
    .border-gray-200 { border-color: #e5e7eb !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
    .bg-gray-50 { background-color: #f9fafb !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
    .bg-black { background-color: #000000 !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }

    @page {
        size: A3 landscape;
        margin: 10mm;
    }

    body {
        font-size: 10px;
        color: #000000;
    }

    .pagination-controls { display: none !important; }

    table {
        font-size: 10px;
    }

    th, td {
        padding: 6px 8px !important;
        font-size: 10px;
    }

    .rounded-2xl { border-radius: 0 !important; }
    .rounded-[2.5rem] { border-radius: 0 !important; }
    .shadow-sm, .shadow-xl { box-shadow: none !important; }
}
</style>
