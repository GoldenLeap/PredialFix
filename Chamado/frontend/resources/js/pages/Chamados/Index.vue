<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { Download, Search, ChevronLeft } from 'lucide-vue-next';
import { ref, computed } from 'vue';

const props = defineProps<{
    chamados: any[];
}>();

// Filtros
const startDate = ref('');
const endDate = ref('');
const category = ref('');
const searchQuery = ref('');

const categories = computed(() => [...new Set(props.chamados.map(c => c.tipo))]);

// Paginação
const currentPage = ref(1);
const itemsPerPage = 10;

const filteredChamados = computed(() => {
    let result = props.chamados;
    if (startDate.value) result = result.filter(c => new Date(c.created_at) >= new Date(startDate.value));
    if (endDate.value) {
        const end = new Date(endDate.value);
        end.setDate(end.getDate() + 1);
        result = result.filter(c => new Date(c.created_at) < end);
    }
    if (category.value) result = result.filter(c => c.tipo === category.value);
    if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        result = result.filter(c => 
            c.id.toString().includes(query) || 
            (c.descricao && c.descricao.toLowerCase().includes(query)) ||
            (c.local && c.local.toLowerCase().includes(query)) ||
            (c.assunto && c.assunto.toLowerCase().includes(query))
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
    if (page >= 1 && page <= totalPages.value) currentPage.value = page;
};

// Exportações
const exportCSV = () => {
    if (filteredChamados.value.length === 0) return;
    const headers = ['ID do chamado', 'Data', 'Categoria', 'Assunto', 'Status'];
    const rows = filteredChamados.value.map(c => [c.id, new Date(c.created_at).toLocaleDateString(), `"${c.tipo}"`, `"${c.assunto || c.descricao || c.local}"`, `"${c.status}"`]);
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
</script>

<template>
    <Head title="Histórico de Chamados" />

    <div class="min-h-screen bg-white text-black font-sans">
        
        <!-- Navegação Superior Minimalista (Limpa) -->
        <nav class="bg-white border-b border-gray-100 px-8 py-4 no-print sticky top-0 z-10 flex items-center">
            <Link href="/dashboard" class="flex items-center gap-2 text-gray-400 hover:text-[#ED1C24] transition-all font-bold text-sm">
                <ChevronLeft class="w-5 h-5" />
                Voltar ao Início
            </Link>
        </nav>

        <div class="p-8 max-w-7xl mx-auto w-full print-container">
            
            <!-- Título e Botões de Exportação -->
            <div class="flex flex-col md:flex-row justify-between items-start mb-2 gap-4">
                <div>
                    <h1 class="text-4xl font-bold text-black mb-2 tracking-tight">Histórico de chamados</h1>
                    <p class="text-gray-500 text-base">Visualize e gerencie todos os chamados registrados no sistema</p>
                </div>
                <div class="flex gap-4 no-print">
                    <button @click="window.print()" class="flex items-center gap-2 px-5 py-2.5 border border-gray-200 rounded-xl text-gray-600 hover:bg-gray-50 text-sm font-bold transition-all cursor-pointer shadow-sm bg-white">
                        <Download class="w-4 h-4" />
                        Salvar como PDF
                    </button>
                    <button @click="exportCSV" class="flex items-center gap-2 px-5 py-2.5 border border-gray-200 rounded-xl text-gray-600 hover:bg-gray-50 text-sm font-bold transition-all cursor-pointer shadow-sm bg-white">
                        <Download class="w-4 h-4" />
                        Exportar CSV
                    </button>
                </div>
            </div>

            <!-- Painel de Filtros -->
            <div class="bg-white border border-gray-200 rounded-[2rem] p-10 my-10 shadow-sm no-print">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-10 mb-8">
                    <div class="flex flex-col">
                        <label class="text-sm font-bold text-black mb-3 ml-1">Data de inicio</label>
                        <input type="date" v-model="startDate" class="border border-gray-200 bg-gray-50/50 rounded-xl px-4 py-3.5 text-sm text-gray-400 focus:outline-none focus:border-gray-300 transition-colors">
                    </div>
                    <div class="flex flex-col">
                        <label class="text-sm font-bold text-black mb-3 ml-1">Data fim</label>
                        <input type="date" v-model="endDate" class="border border-gray-200 bg-gray-50/50 rounded-xl px-4 py-3.5 text-sm text-gray-400 focus:outline-none focus:border-gray-300 transition-colors">
                    </div>
                    <div class="flex flex-col">
                        <label class="text-sm font-bold text-black mb-3 ml-1">Categoria</label>
                        <div class="relative">
                            <select v-model="category" class="w-full border border-gray-200 bg-gray-50/50 rounded-xl px-4 py-3.5 text-sm text-gray-400 focus:outline-none focus:border-gray-300 transition-colors appearance-none">
                                <option value="">Todas as categorias</option>
                                <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
                            </select>
                            <div class="absolute right-4 top-1/2 -translate-y-1/2 pointer-events-none">
                                <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
                            </div>
                        </div>
                    </div>
                    <div class="flex flex-col justify-end">
                        <button class="bg-[#ED1C24] hover:bg-red-700 text-white font-bold py-3.5 px-6 rounded-xl transition-all shadow-md active:scale-95 cursor-pointer">
                            Filtrar
                        </button>
                    </div>
                </div>

                <!-- Barra de Pesquisa -->
                <div class="relative">
                    <Search class="absolute left-5 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-300" />
                    <input 
                        type="text" 
                        v-model="searchQuery" 
                        placeholder="Pesquisar por ID ou assunto" 
                        class="w-full pl-14 pr-6 py-4 bg-gray-50/50 border border-gray-200 rounded-xl text-sm text-gray-400 focus:outline-none focus:border-gray-300 transition-colors"
                    >
                </div>
            </div>

            <!-- Tabela -->
            <div class="bg-white rounded-[2.5rem] border border-gray-200 overflow-hidden flex flex-col shadow-sm">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse min-w-[800px]">
                        <thead>
                            <tr class="bg-[#ED1C24] text-white">
                                <th class="px-10 py-6 font-bold text-sm tracking-tight">ID do chamado</th>
                                <th class="px-10 py-6 font-bold text-sm tracking-tight">Data</th>
                                <th class="px-10 py-6 font-bold text-sm tracking-tight">Categoria</th>
                                <th class="px-10 py-6 font-bold text-sm tracking-tight">Assunto</th>
                                <th class="px-10 py-6 font-bold text-sm tracking-tight">Status</th>
                            </tr>
                        </thead>
                        <tbody class="text-gray-400 text-sm">
                            <tr 
                                v-for="chamado in paginatedChamados" 
                                :key="chamado.id" 
                                @click="goToDetails(chamado.id)"
                                class="border-b border-gray-50 last:border-0 hover:bg-gray-50/80 transition-colors cursor-pointer group"
                            >
                                <td class="px-10 py-6 font-bold group-hover:text-black transition-colors">#{{ chamado.id }}</td>
                                <td class="px-10 py-6 group-hover:text-black transition-colors">{{ new Date(chamado.created_at).toLocaleDateString() }}</td>
                                <td class="px-10 py-6 group-hover:text-black transition-colors">{{ chamado.tipo }}</td>
                                <td class="px-10 py-6 truncate max-w-[250px] group-hover:text-black transition-colors">{{ chamado.assunto || chamado.descricao || chamado.local }}</td>
                                <td class="px-10 py-6">
                                    <span class="px-3 py-1 rounded-full text-[10px] font-bold bg-gray-100 text-gray-500 uppercase tracking-widest group-hover:bg-[#ED1C24] group-hover:text-white transition-all">
                                        {{ chamado.status }}
                                    </span>
                                </td>
                            </tr>
                            <tr v-if="paginatedChamados.length === 0">
                                <td colspan="5" class="px-10 py-20 text-center italic text-gray-300">Nenhum chamado encontrado.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Rodapé Vermelho da Tabela -->
                <div class="bg-[#ED1C24] px-10 py-5 flex flex-col md:flex-row justify-between items-center text-white gap-4">
                    <div class="text-sm font-bold">
                        Exibindo {{ filteredChamados.length }} resultados
                    </div>
                    
                    <div class="flex gap-2 items-center no-print">
                        <button @click="changePage(currentPage - 1)" :disabled="currentPage === 1" class="bg-white text-black px-5 py-2 rounded-xl text-xs font-bold disabled:opacity-30 transition-all active:scale-95 cursor-pointer">Anterior</button>
                        
                        <div class="flex gap-1 mx-2">
                            <button 
                                v-for="p in totalPages" 
                                :key="p" 
                                @click="changePage(p)" 
                                :class="['w-8 h-8 flex items-center justify-center rounded-lg text-xs font-bold transition-all cursor-pointer', currentPage === p ? 'bg-white text-black shadow-sm' : 'text-white hover:bg-white/20']"
                            >
                                {{ p }}
                            </button>
                        </div>

                        <button @click="changePage(currentPage + 1)" :disabled="currentPage === totalPages" class="bg-white text-black px-5 py-2 rounded-xl text-xs font-bold disabled:opacity-50 transition-all active:scale-95 cursor-pointer">Proximo</button>
                    </div>
                </div>
            </div>

        </div>
    </div>
</template>

<style scoped>
.bg-white { background-color: #ffffff !important; }
.bg-gray-50 { background-color: #f9fafb !important; }
.text-black { color: #000000 !important; }

@media print {
    .no-print { display: none !important; }
    .print-container { width: 100%; max-width: none; padding: 0; margin: 0; }
    .bg-\[\#ED1C24\] { background-color: #ED1C24 !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
    .text-white { color: #ffffff !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
}
</style>
