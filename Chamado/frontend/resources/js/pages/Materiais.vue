<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import { Package, AlertTriangle, CheckCircle2, Search, Plus, MapPin } from 'lucide-vue-next';
import { ref, computed } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';

const breadcrumbs = [
    { title: 'Painel', href: '/dashboard' },
    { title: 'Materiais', href: '/materiais' },
];

const props = defineProps<{ materials: any[] }>();

const searchQuery = ref('');
const selectedCategory = ref('');
const categories = computed(() => [...new Set(props.materials?.map((m: any) => m.categoria) || [])]);

const filteredMaterials = computed(() => {
    let result = props.materials || [];
    if (searchQuery.value) {
        const q = searchQuery.value.toLowerCase();
        result = result.filter((m: any) =>
            m.nome.toLowerCase().includes(q) ||
            m.categoria.toLowerCase().includes(q) ||
            m.localizacao.toLowerCase().includes(q)
        );
    }
    if (selectedCategory.value) {
        result = result.filter((m: any) => m.categoria === selectedCategory.value);
    }
    return result;
});

const getStatusClass = (mat: any) => {
    const qty = mat.quantidade_atual || 0;
    const min = mat.quantidade_minima || 0;
    if (qty < min * 0.3) return { status: 'Crítico', color: 'text-rose-600', bg: 'bg-rose-50 dark:bg-rose-900/20', border: 'border-rose-200 dark:border-rose-800', bar: 'bg-rose-500', dot: 'bg-rose-500' };
    if (qty < min)      return { status: 'Baixo',   color: 'text-orange-600', bg: 'bg-orange-50 dark:bg-orange-900/20', border: 'border-orange-200 dark:border-orange-800', bar: 'bg-orange-500', dot: 'bg-orange-500' };
    return                    { status: 'Adequado', color: 'text-emerald-600', bg: 'bg-emerald-50/50 dark:bg-emerald-900/10', border: 'border-border', bar: 'bg-emerald-500', dot: 'bg-emerald-500' };
};

const stockPct = (mat: any) => Math.min(((mat.quantidade_atual||0) / (mat.quantidade_minima||1)) * 100, 150);

const formatCurrency = (v: number) => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v);

const totalStats = computed(() => {
    const total = props.materials?.length || 0;
    const critico = props.materials?.filter(m => (m.quantidade_atual||0) < (m.quantidade_minima||0) * 0.3).length || 0;
    const baixo   = props.materials?.filter(m => { const q=m.quantidade_atual||0, mn=m.quantidade_minima||0; return q < mn && q >= mn * 0.3; }).length || 0;
    return { total, critico, baixo, adequado: total - critico - baixo };
});
</script>

<template>
    <Head title="Materiais" />
    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="flex flex-col gap-6 animate-in fade-in slide-in-from-bottom-3 duration-500">
            <!-- Header -->
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                <div>
                    <h1 class="text-2xl font-black tracking-tight">Gestão de Materiais</h1>
                    <p class="text-sm text-muted-foreground mt-1">Controle de estoque de insumos de manutenção.</p>
                </div>
                <Link href="/materiais/create" class="inline-flex items-center gap-2 bg-primary hover:bg-primary/90 text-primary-foreground font-semibold py-2.5 px-5 rounded-xl transition-all shadow-md hover:shadow-lg active:scale-95 text-sm">
                    <Plus class="w-4 h-4" />Novo Material
                </Link>
            </div>

            <!-- Stats -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div class="bg-card border border-border rounded-2xl p-5 shadow-sm flex items-center justify-between">
                    <div>
                        <p class="text-xs text-muted-foreground font-semibold uppercase tracking-wider">Total</p>
                        <p class="text-3xl font-black mt-1">{{ totalStats.total }}</p>
                    </div>
                    <Package class="w-6 h-6 text-muted-foreground/50" />
                </div>
                <div class="bg-rose-50 dark:bg-rose-900/20 border border-rose-200 dark:border-rose-800 rounded-2xl p-5 shadow-sm flex items-center justify-between">
                    <div>
                        <p class="text-xs text-rose-600 font-semibold uppercase tracking-wider">Crítico</p>
                        <p class="text-3xl font-black text-rose-700 dark:text-rose-400 mt-1">{{ totalStats.critico }}</p>
                    </div>
                    <AlertTriangle class="w-6 h-6 text-rose-400" />
                </div>
                <div class="bg-orange-50 dark:bg-orange-900/20 border border-orange-200 dark:border-orange-800 rounded-2xl p-5 shadow-sm flex items-center justify-between">
                    <div>
                        <p class="text-xs text-orange-600 font-semibold uppercase tracking-wider">Baixo</p>
                        <p class="text-3xl font-black text-orange-700 dark:text-orange-400 mt-1">{{ totalStats.baixo }}</p>
                    </div>
                    <AlertTriangle class="w-6 h-6 text-orange-400" />
                </div>
                <div class="bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800 rounded-2xl p-5 shadow-sm flex items-center justify-between">
                    <div>
                        <p class="text-xs text-emerald-600 font-semibold uppercase tracking-wider">Adequado</p>
                        <p class="text-3xl font-black text-emerald-700 dark:text-emerald-400 mt-1">{{ totalStats.adequado }}</p>
                    </div>
                    <CheckCircle2 class="w-6 h-6 text-emerald-400" />
                </div>
            </div>

            <!-- Search & Filter -->
            <div class="bg-card border border-border rounded-2xl p-3 flex gap-3 shadow-sm">
                <div class="relative flex-1">
                    <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                    <input type="text" v-model="searchQuery" placeholder="Pesquisar material..."
                        class="w-full pl-10 pr-4 py-2.5 bg-transparent text-sm outline-none placeholder:text-muted-foreground" />
                </div>
                <select v-model="selectedCategory"
                    class="px-4 py-2.5 bg-muted border border-border rounded-xl text-sm outline-none focus:ring-2 focus:ring-primary">
                    <option value="">Todas as categorias</option>
                    <option v-for="cat in categories" :key="cat as string" :value="cat">{{ cat }}</option>
                </select>
            </div>

            <!-- Materials Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
                <div v-for="mat in filteredMaterials" :key="mat.id"
                     :class="['bg-card border rounded-2xl shadow-sm hover:shadow-md transition-all duration-300 overflow-hidden group', getStatusClass(mat).border]">
                    <div class="p-5 space-y-4">
                        <div class="flex justify-between items-start">
                            <div :class="['p-2.5 rounded-xl transition-colors', getStatusClass(mat).bg]">
                                <Package :class="['w-5 h-5', getStatusClass(mat).color]" />
                            </div>
                            <div class="flex items-center gap-1.5">
                                <span :class="['w-2 h-2 rounded-full', getStatusClass(mat).dot]"></span>
                                <span :class="['text-[10px] font-bold uppercase tracking-widest', getStatusClass(mat).color]">{{ getStatusClass(mat).status }}</span>
                            </div>
                        </div>

                        <div>
                            <h4 class="font-bold text-foreground leading-snug">{{ mat.nome }}</h4>
                            <p class="text-xs text-muted-foreground mt-0.5">{{ mat.categoria }}</p>
                        </div>

                        <div class="space-y-2">
                            <div class="flex justify-between text-xs font-semibold text-muted-foreground">
                                <span>{{ mat.quantidade_atual }} {{ mat.unidade }}</span>
                                <span class="font-normal opacity-70">mín: {{ mat.quantidade_minima }}</span>
                            </div>
                            <div class="w-full bg-muted h-1.5 rounded-full overflow-hidden">
                                <div :class="['h-full rounded-full transition-all duration-700', getStatusClass(mat).bar]"
                                     :style="{ width: Math.min(stockPct(mat), 100) + '%' }"></div>
                            </div>
                        </div>

                        <div class="pt-3 border-t border-border space-y-1.5">
                            <div class="flex items-center gap-1.5 text-xs text-muted-foreground">
                                <MapPin class="w-3 h-3 flex-shrink-0" />
                                <span class="truncate">{{ mat.localizacao }}</span>
                            </div>
                            <div v-if="mat.valor_unitario" class="flex items-center justify-between text-xs">
                                <span class="text-muted-foreground">Valor unitário</span>
                                <span class="font-semibold text-primary">{{ formatCurrency(mat.valor_unitario) }}</span>
                            </div>
                        </div>
                    </div>
                    <Link :href="`/materiais/${mat.id}/edit`"
                          class="block border-t border-border px-5 py-3 text-center text-xs font-semibold text-muted-foreground hover:text-primary hover:bg-muted/50 transition-all">
                        Editar material →
                    </Link>
                </div>

                <div v-if="!filteredMaterials.length" class="col-span-full py-20 text-center">
                    <Package class="w-12 h-12 mx-auto text-muted-foreground/30 mb-3" />
                    <p class="text-muted-foreground italic">Nenhum material encontrado.</p>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
