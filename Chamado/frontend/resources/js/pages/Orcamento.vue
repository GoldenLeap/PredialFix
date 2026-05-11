<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Head } from '@inertiajs/vue3';
import { ref } from 'vue';
import { DollarSign, Save, RefreshCcw } from 'lucide-vue-next';

const breadcrumbs = [
    { title: 'Painel', href: '/dashboard' },
    { title: 'Orçamento', href: '/orcamento' },
];

const props = defineProps<{
    config: any;
    history: any[];
}>();

const selectedMonth = ref(props.config.month.toString());
const selectedYear = ref(props.config.year.toString());
const monthlyBudget = ref(props.config.total_budget);
const alertEnabled = ref(props.config.alert_enabled);

const categories = ref(Object.entries(props.config.allocations).map(([name, percentage]: [string, any]) => ({
    name,
    percentage: percentage * 100,
    limit: props.config.total_budget * percentage,
    spent: 0, // In a real app, this would be calculated from expenses
    color: name === 'Encanação' ? 'bg-orange-500' : 'bg-green-500'
})));

const formattedHistory = props.history.map(item => ({
    month: `${item.month}/${item.year}`,
    budget: item.total_budget,
    spent: 0,
    variance: item.total_budget,
    status: 'Economizou'
}));
</script>

<template>
    <Head title="Orçamento" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="p-6 space-y-6 bg-[#f8f9fa] min-h-screen">
            <!-- Configuração do Orçamento -->
            <div class="bg-white rounded-xl shadow-sm overflow-hidden border border-gray-200">
                <div class="bg-[#ff8a8a] px-6 py-3 flex items-center gap-2 text-white font-medium">
                    <DollarSign class="w-5 h-5" />
                    Configuração do orçamento
                </div>
                <div class="p-6 grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Selecione o mês</label>
                        <select v-model="selectedMonth" class="w-full rounded-lg border-gray-300 focus:ring-red-500 focus:border-red-500">
                            <option>Janeiro</option>
                            <option>Fevereiro</option>
                            <option>Março</option>
                            <!-- Adicionar outros meses -->
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Ano atual</label>
                        <select v-model="selectedYear" class="w-full rounded-lg border-gray-300 focus:ring-red-500 focus:border-red-500">
                            <option>2024</option>
                            <option>2025</option>
                            <option>2026</option>
                        </select>
                    </div>
                    <div class="flex items-end">
                        <button class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center gap-2 transition-colors">
                            <RefreshCcw class="w-4 h-4" />
                            Atualizar período
                        </button>
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Orçamento Mensal (R$)</label>
                        <div class="relative">
                            <input type="number" v-model="monthlyBudget" class="w-full bg-[#e0ffff] rounded-lg border-none py-3 px-4 font-medium text-lg focus:ring-2 focus:ring-cyan-500" />
                        </div>
                    </div>
                    <div class="flex items-end">
                        <button class="w-full bg-[#00c853] hover:bg-[#00a844] text-white font-medium py-3 px-4 rounded-lg flex items-center justify-center gap-2 transition-colors">
                            <Save class="w-5 h-5" />
                            Salvar orçamento
                        </button>
                    </div>

                    <div class="md:col-span-3 bg-[#ffcccc] p-4 rounded-lg flex items-center justify-between">
                        <div>
                            <div class="font-bold text-[#d32f2f] text-sm flex items-center gap-1">
                                <span class="bg-[#d32f2f] text-white rounded-full w-4 h-4 flex items-center justify-center text-[10px]">!</span>
                                Alerta de orçamento
                            </div>
                            <p class="text-xs text-[#d32f2f]">Notificar quando o orçamento chegar a 80%.</p>
                        </div>
                        <label class="relative inline-flex items-center cursor-pointer">
                            <input type="checkbox" v-model="alertEnabled" class="sr-only peer">
                            <div class="w-11 h-6 bg-gray-400 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-gray-600"></div>
                        </label>
                    </div>
                </div>
            </div>

            <!-- Alocação por Categoria -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                <h3 class="text-lg font-bold mb-6">Alocação de orçamento por categoria</h3>
                <div class="space-y-8">
                    <div v-for="cat in categories" :key="cat.name">
                        <div class="flex justify-between items-start mb-2">
                            <div>
                                <h4 class="font-bold text-gray-800">{{ cat.name }}</h4>
                                <p class="text-xs text-gray-500">{{ cat.percentage }}% do orçamento total</p>
                            </div>
                            <div class="text-right">
                                <p class="text-xs text-gray-400">Limite de orçamento</p>
                                <p class="font-bold text-sm">R$ {{ cat.limit.toLocaleString() }}</p>
                            </div>
                        </div>
                        <div class="w-full bg-gray-100 rounded-full h-3 mb-2 overflow-hidden">
                            <div :class="[cat.color, 'h-3 rounded-full transition-all duration-500']" :style="{ width: (cat.spent / cat.limit * 100) + '%' }"></div>
                        </div>
                        <div class="flex justify-between text-[10px] font-medium">
                            <span class="bg-[#ffebcc] text-orange-800 px-2 py-0.5 rounded">Gastou: R$ {{ cat.spent.toLocaleString() }} de R$ {{ cat.limit.toLocaleString() }}</span>
                            <span class="text-orange-500">{{ (cat.spent / cat.limit * 100).toFixed(1) }}%</span>
                        </div>
                        <p v-if="cat.spent / cat.limit > 0.8" class="text-[10px] text-orange-500 mt-1 flex items-center gap-1">
                             ⚠ Alerta se aproximando do limite de orçamento
                        </p>
                    </div>
                </div>

                <div class="grid grid-cols-3 gap-4 mt-10 pt-6 border-t border-gray-100">
                    <div class="bg-gray-50 p-3 rounded-lg">
                        <p class="text-[10px] text-gray-500 font-medium">Total alocado</p>
                        <p class="font-bold">R$ 50.000</p>
                    </div>
                    <div class="bg-gray-50 p-3 rounded-lg">
                        <p class="text-[10px] text-gray-500 font-medium">Total gasto</p>
                        <p class="font-bold">R$ 32.750</p>
                    </div>
                    <div class="bg-gray-50 p-3 rounded-lg">
                        <p class="text-[10px] text-gray-500 font-medium text-right">Sobrando</p>
                        <p class="font-bold text-green-600 text-right">R$ 17.250</p>
                    </div>
                </div>
            </div>

            <!-- Histórico -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 overflow-hidden">
                <h3 class="text-lg font-bold mb-6">Histórico de orçamentos recentes (últimos 6 meses)</h3>
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm">
                        <thead class="bg-gray-50 text-gray-600 font-medium border-b">
                            <tr>
                                <th class="py-3 px-4">Mês</th>
                                <th class="py-3 px-4">Orçamento inicial</th>
                                <th class="py-3 px-4">Total gasto</th>
                                <th class="py-3 px-4 text-center">Variancia</th>
                                <th class="py-3 px-4 text-right">Status</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100">
                            <tr v-for="item in formattedHistory" :key="item.month" class="hover:bg-gray-50 transition-colors">
                                <td class="py-3 px-4 font-medium">{{ item.month }}</td>
                                <td class="py-3 px-4 text-gray-500 font-mono text-xs">R$ {{ item.budget.toLocaleString() }}</td>
                                <td class="py-3 px-4 text-gray-500 font-mono text-xs">R$ {{ item.spent.toLocaleString() }}</td>
                                <td :class="['py-3 px-4 text-center font-bold text-xs', item.variance > 0 ? 'text-green-600' : 'text-red-600']">
                                    {{ item.variance > 0 ? '+' : '' }}R$ {{ item.variance.toLocaleString() }}
                                </td>
                                <td class="py-3 px-4 text-right">
                                    <span :class="['text-[10px] px-2 py-0.5 rounded-full font-bold uppercase', item.status === 'Economizou' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700']">
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
