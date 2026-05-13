<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import {
    Package,
    AlertTriangle,
    CheckCircle2,
    Search,
    Plus,
    MapPin,
    Calendar,
    ArrowUpDown
} from 'lucide-vue-next';

const breadcrumbs = [
    { title: 'Painel', href: '/dashboard' },
    { title: 'Materiais', href: '/materiais' },
];

const props = defineProps<{
    materials: any[];
}>();

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

const getStatusColor = (status: string) => {
    switch (status) {
        case 'Crítico': return 'bg-red-500 text-white';
        case 'Baixo': return 'bg-orange-500 text-white';
        case 'Adequado': return 'bg-green-500 text-white';
        default: return 'bg-gray-500 text-white';
    }
};

const getStatusClass = (material: any) => {
    const qty = material.quantidade_atual || 0;
    const min = material.quantidade_minima || 0;
    if (qty < min * 0.3) return { status: 'Crítico', class: 'bg-red-500 text-white' };
    if (qty < min) return { status: 'Baixo', class: 'bg-orange-500 text-white' };
    return { status: 'Adequado', class: 'bg-green-500 text-white' };
};
</script>

<template>
    <Head title="Materiais" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="p-6 space-y-6">
            <div class="flex justify-between items-center">
                <div>
                    <h2 class="text-xl font-bold text-gray-800 dark:text-white">Gestão de Materiais</h2>
                    <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">Acompanhe o estoque e controle de materiais</p>
                </div>
                <Link href="/materiais/criar" class="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-6 rounded-xl flex items-center gap-2 transition-all shadow-sm hover:shadow-md active:scale-95">
                    <Plus class="w-5 h-5" />
                    Novo material
                </Link>
            </div>

            <!-- Stats Grid -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div class="bg-white dark:bg-zinc-900 p-4 rounded-xl shadow-sm border border-gray-100 dark:border-zinc-800 flex items-center justify-between">
                    <div>
                        <p class="text-[10px] text-gray-500 dark:text-gray-400 font-medium uppercase tracking-wider">Total</p>
                        <p class="text-2xl font-black text-gray-900 dark:text-white">{{ materials?.length || 0 }}</p>
                    </div>
                    <Package class="w-6 h-6 text-gray-400" />
                </div>
                <div class="bg-red-50 dark:bg-red-900/20 p-4 rounded-xl shadow-sm border border-red-100 dark:border-red-900/30 flex items-center justify-between">
                    <div>
                        <p class="text-[10px] text-red-600 dark:text-red-400 font-medium uppercase tracking-wider">Crítico</p>
                        <p class="text-2xl font-black text-red-700 dark:text-red-300">{{ materials?.filter(m => (m.quantidade_atual || 0) < (m.quantidade_minima || 0) * 0.3).length || 0 }}</p>
                    </div>
                    <AlertTriangle class="w-6 h-6 text-red-500" />
                </div>
                <div class="bg-orange-50 dark:bg-orange-900/20 p-4 rounded-xl shadow-sm border border-orange-100 dark:border-orange-900/30 flex items-center justify-between">
                    <div>
                        <p class="text-[10px] text-orange-600 dark:text-orange-400 font-medium uppercase tracking-wider">Baixo</p>
                        <p class="text-2xl font-black text-orange-700 dark:text-orange-300">{{ materials?.filter(m => (m.quantidade_atual || 0) < (m.quantidade_minima || 0) && (m.quantidade_atual || 0) >= (m.quantidade_minima || 0) * 0.3).length || 0 }}</p>
                    </div>
                    <CheckCircle2 class="w-6 h-6 text-orange-500" />
                </div>
                <div class="bg-emerald-50 dark:bg-emerald-900/20 p-4 rounded-xl shadow-sm border border-emerald-100 dark:border-emerald-900/30 flex items-center justify-between">
                    <div>
                        <p class="text-[10px] text-emerald-600 dark:text-emerald-400 font-medium uppercase tracking-wider">Adequado</p>
                        <p class="text-2xl font-black text-emerald-700 dark:text-emerald-300">{{ materials?.filter(m => (m.quantidade_atual || 0) >= (m.quantidade_minima || 0)).length || 0 }}</p>
                    </div>
                    <CheckCircle2 class="w-6 h-6 text-emerald-500" />
                </div>
            </div>

            <!-- Search and Filter -->
            <div class="bg-white dark:bg-zinc-900 p-3 rounded-xl shadow-sm border border-gray-100 dark:border-zinc-800 flex gap-2">
                <div class="relative flex-1">
                    <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                    <input
                        type="text"
                        v-model="searchQuery"
                        placeholder="Pesquisar material..."
                        class="w-full pl-10 pr-4 py-2 bg-transparent border-none focus:ring-0 text-sm text-gray-700 dark:text-gray-300 placeholder-gray-400"
                    />
                </div>
                <select
                    v-model="selectedCategory"
                    class="px-4 py-2 bg-gray-50 dark:bg-zinc-800 border-gray-200 dark:border-zinc-700 rounded-lg text-sm text-gray-700 dark:text-gray-300 focus:outline-none focus:ring-2 focus:ring-red-500"
                >
                    <option value="">Todas categorias</option>
                    <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
                </select>
            </div>

            <!-- Materials Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                <div
                    v-for="mat in filteredMaterials"
                    :key="mat.id"
                    class="bg-white dark:bg-zinc-900 rounded-xl shadow-sm border border-gray-100 dark:border-zinc-800 overflow-hidden group hover:shadow-md transition-shadow"
                >
                    <div class="p-4 space-y-4">
                        <div class="flex justify-between items-start">
                            <div class="bg-gray-100 dark:bg-zinc-800 p-2 rounded-lg group-hover:bg-red-50 transition-colors">
                                <Package class="w-5 h-5 text-gray-500 group-hover:text-red-500" />
                            </div>
                            <span :class="['text-[10px] font-bold px-2 py-0.5 rounded uppercase', getStatusClass(mat).class]">
                                {{ getStatusClass(mat).status }}
                            </span>
                        </div>

                        <div>
                            <h4 class="font-black text-gray-900 dark:text-white text-sm leading-snug">{{ mat.nome }}</h4>
                            <p class="text-[10px] text-gray-400 dark:text-gray-500 font-medium mt-1">{{ mat.categoria }}</p>
                        </div>

                        <div class="space-y-2">
                            <div class="flex justify-between text-[10px] font-bold text-gray-600 dark:text-gray-400">
                                <span>{{ mat.quantidade_atual }} <span class="font-normal">/ {{ mat.quantidade_minima }} mín.</span></span>
                                <span class="text-gray-400 font-normal">{{ mat.unidade || 'un' }}</span>
                            </div>
                            <div class="w-full bg-gray-100 dark:bg-zinc-800 h-2 rounded-full overflow-hidden">
                                <div
                                    :class="[getStatusClass(mat).class.replace(' text-white', ''), 'h-full transition-all duration-500']"
                                    :style="{ width: Math.min(((mat.quantidade_atual || 0) / (mat.quantidade_minima || 1)) * 100, 100) + '%' }"
                                ></div>
                            </div>
                        </div>

                        <div class="space-y-1.5 pt-2 border-t border-gray-50 dark:border-zinc-800">
                            <div class="flex items-center gap-1.5 text-gray-500 dark:text-gray-400 text-[10px]">
                                <MapPin class="w-3 h-3" />
                                {{ mat.localizacao }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
