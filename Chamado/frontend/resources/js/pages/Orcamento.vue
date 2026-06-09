<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import { DollarSign, Save, RefreshCcw } from 'lucide-vue-next';

const breadcrumbs = [
    { title: 'Painel', href: '/dashboard' },
    { title: 'Orçamento', href: '/orcamento' },
];

const props = defineProps<{
    config: {
        month: number;
        year: number;
        total_budget: number;
        alert_enabled: boolean;
        allocations: Record<string, number>;
        spent_by_category?: Record<string, number>;
    };
    history: any[];
    months: Record<string, string>;
    years: number[];
}>();

const selectedMonth = ref(props.config?.month?.toString().padStart(2, '0') || '');
const selectedYear = ref(props.config?.year?.toString() || '');
const monthlyBudget = ref(props.config?.total_budget || 0);

const isSaving = ref(false);

const updatePeriod = () => {
    router.visit(`/orcamento?month=${parseInt(selectedMonth.value)}&year=${selectedYear.value}`);
};

const saveBudget = () => {
    isSaving.value = true;
    router.post('/orcamento', {
        month: parseInt(selectedMonth.value),
        year: parseInt(selectedYear.value),
        total_budget: monthlyBudget.value,
    }, {
        onFinish: () => { isSaving.value = false; },
    });
};

const CATEGORIES = ['Elétrica', 'Hidráulica', 'Infraestrutura', 'Outros'];

const categories = computed(() => {
    const spentByCategory = props.config?.spent_by_category || {};
    const allocations = props.config?.allocations || {};
    const total = monthlyBudget.value;

    return CATEGORIES.map(name => {
        const percentage = allocations[name] ?? (1 / CATEGORIES.length);
        const limit = total * percentage;
        const spent = spentByCategory[name] || 0;
        return { name, percentage: percentage * 100, limit, spent };
    });
});

const getCategoryColor = (name: string) => {
    const colors: Record<string, string> = {
        'Elétrica': 'bg-yellow-500',
        'Hidráulica': 'bg-blue-500',
        'Infraestrutura': 'bg-green-500',
        'Outros': 'bg-gray-500',
    };
    return colors[name] || 'bg-gray-400';
};

const formattedHistory = computed(() => {
    if (!props.history) return [];
    return props.history.map(item => {
        const spent = item.spent || 0;
        const variance = item.total_budget - spent;
        const monthName = props.months[item.month.toString().padStart(2, '0')] || item.month;
        return {
            label: `${monthName}/${item.year}`,
            budget: item.total_budget,
            spent,
            variance,
            statusClass: variance >= 0 ? 'bg-emerald-100 text-emerald-700' : 'bg-red-100 text-red-700',
            status: variance >= 0 ? 'No limite' : 'Excedeu',
        };
    });
});

const totalSpent = computed(() => categories.value.reduce((acc, cat) => acc + cat.spent, 0));
const totalRemaining = computed(() => monthlyBudget.value - totalSpent.value);
</script>

<template>
    <Head title="Orçamento" />
    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="p-6 space-y-6">
            <h1 class="text-3xl font-black text-gray-900 tracking-tight">Orçamento Mensal</h1>
            <p class="text-gray-500 text-sm">Gerencie o orçamento e acompanhe os gastos por categoria</p>

            <!-- Configuração -->
            <div class="bg-white rounded-2xl shadow-sm overflow-hidden border border-gray-200">
                <div class="bg-[#ff8a8a] px-6 py-3 flex items-center gap-2 text-white font-medium">
                    <DollarSign class="w-5 h-5" />
                    Configuração do orçamento
                </div>
                <div class="p-6 grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Mês</label>
                        <select v-model="selectedMonth" class="w-full rounded-lg border border-gray-300 px-3 py-2 focus:ring-red-500 focus:border-red-500">
                            <option v-for="(name, key) in months" :key="key" :value="key">{{ name }}</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Ano</label>
                        <select v-model="selectedYear" class="w-full rounded-lg border border-gray-300 px-3 py-2 focus:ring-red-500 focus:border-red-500">
                            <option v-for="y in years" :key="y" :value="y.toString()">{{ y }}</option>
                        </select>
                    </div>
                    <div class="flex items-end">
                        <button @click="updatePeriod" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center gap-2 transition-colors">
                            <RefreshCcw class="w-4 h-4" /> Atualizar período
                        </button>
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Orçamento Mensal (R$)</label>
                        <input type="number" step="0.01" v-model.number="monthlyBudget"
                            class="w-full bg-[#e0ffff] rounded-lg border border-gray-200 py-3 px-4 font-medium text-lg focus:ring-2 focus:ring-cyan-500 outline-none" />
                    </div>
                    <div class="flex items-end">
                        <button @click="saveBudget" :disabled="isSaving"
                            class="w-full bg-[#00c853] hover:bg-[#00a844] disabled:opacity-60 text-white font-medium py-3 px-4 rounded-lg flex items-center justify-center gap-2 transition-colors">
                            <Save class="w-5 h-5" /> {{ isSaving ? 'Salvando...' : 'Salvar orçamento' }}
                        </button>
                    </div>
                </div>
            </div>

            <!-- Alocação por Categoria -->
            <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
                <h3 class="text-lg font-bold mb-6">Gastos por categoria (mês atual)</h3>
                <div class="space-y-6">
                    <div v-for="cat in categories" :key="cat.name">
                        <div class="flex justify-between items-center mb-1">
                            <h4 class="font-bold text-gray-800">{{ cat.name }}</h4>
                            <span class="text-xs text-gray-400">
                                R$ {{ cat.spent.toLocaleString('pt-BR', { minimumFractionDigits: 2 }) }}
                                / R$ {{ monthlyBudget.toLocaleString('pt-BR', { minimumFractionDigits: 2 }) }}
                            </span>
                        </div>
                        <div class="w-full bg-gray-100 rounded-full h-3 overflow-hidden">
                            <div :class="[getCategoryColor(cat.name), 'h-3 rounded-full transition-all duration-500']"
                                :style="{ width: Math.min((cat.spent / (monthlyBudget || 1)) * 100, 100) + '%' }">
                            </div>
                        </div>
                        <p class="text-[10px] text-gray-400 mt-0.5">
                            {{ ((cat.spent / (monthlyBudget || 1)) * 100).toFixed(1) }}% do orçamento total
                        </p>
                    </div>
                </div>

                <div class="grid grid-cols-3 gap-4 mt-8 pt-6 border-t border-gray-100">
                    <div class="bg-gray-50 p-3 rounded-lg">
                        <p class="text-[10px] text-gray-500 font-medium">Orçamento</p>
                        <p class="font-bold text-sm">R$ {{ monthlyBudget.toLocaleString('pt-BR', { minimumFractionDigits: 2 }) }}</p>
                    </div>
                    <div class="bg-gray-50 p-3 rounded-lg">
                        <p class="text-[10px] text-gray-500 font-medium">Total gasto</p>
                        <p class="font-bold text-sm">R$ {{ totalSpent.toLocaleString('pt-BR', { minimumFractionDigits: 2 }) }}</p>
                    </div>
                    <div class="bg-gray-50 p-3 rounded-lg">
                        <p class="text-[10px] text-gray-500 font-medium text-right">Sobrando</p>
                        <p :class="['font-bold text-sm text-right', totalRemaining >= 0 ? 'text-green-600' : 'text-red-600']">
                            R$ {{ totalRemaining.toLocaleString('pt-BR', { minimumFractionDigits: 2 }) }}
                        </p>
                    </div>
                </div>
            </div>

            <!-- Histórico -->
            <div v-if="formattedHistory.length > 0" class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
                <h3 class="text-lg font-bold mb-6">Histórico de orçamentos</h3>
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm">
                        <thead class="bg-gray-50 text-gray-600 font-medium border-b">
                            <tr>
                                <th class="py-3 px-4">Mês</th>
                                <th class="py-3 px-4">Orçamento</th>
                                <th class="py-3 px-4">Total gasto</th>
                                <th class="py-3 px-4 text-center">Variância</th>
                                <th class="py-3 px-4 text-right">Status</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100">
                            <tr v-for="item in formattedHistory" :key="item.label" class="hover:bg-gray-50">
                                <td class="py-3 px-4 font-medium">{{ item.label }}</td>
                                <td class="py-3 px-4 text-gray-500 font-mono text-xs">R$ {{ item.budget.toLocaleString('pt-BR', { minimumFractionDigits: 2 }) }}</td>
                                <td class="py-3 px-4 text-gray-500 font-mono text-xs">R$ {{ item.spent.toLocaleString('pt-BR', { minimumFractionDigits: 2 }) }}</td>
                                <td :class="['py-3 px-4 text-center font-bold text-xs', item.variance >= 0 ? 'text-green-600' : 'text-red-600']">
                                    {{ item.variance >= 0 ? '+' : '' }}R$ {{ Math.abs(item.variance).toLocaleString('pt-BR', { minimumFractionDigits: 2 }) }}
                                </td>
                                <td class="py-3 px-4 text-right">
                                    <span :class="['text-[10px] px-2 py-0.5 rounded-full font-bold uppercase', item.statusClass]">
                                        {{ item.status }}
                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
