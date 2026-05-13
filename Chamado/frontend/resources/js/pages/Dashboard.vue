<script setup lang="ts">
import { computed } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    stats: {
        total: number;
        abertos: number;
        em_analise: number;
        em_execucao: number;
        concluidos: number;
    };
    recentChamados: any[];
    recentMaterials: any[];
    topUsers: any[];
}>();

const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Dashboard',
        href: '/dashboard',
    },
];

const materialStats = computed(() => {
    const total = props.recentMaterials?.length || 0;
    const critico = props.recentMaterials?.filter((m: any) => (m.quantidade_atual || 0) < (m.quantidade_minima || 0) * 0.3).length || 0;
    const baixo = props.recentMaterials?.filter((m: any) => (m.quantidade_atual || 0) < (m.quantidade_minima || 0) && (m.quantidade_atual || 0) >= (m.quantidade_minima || 0) * 0.3).length || 0;
    return { total, critico, baixo, adequado: total - critico - baixo };
});
</script>

<template>
    <Head title="Dashboard" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="flex h-full flex-1 flex-col gap-4 overflow-x-auto rounded-xl p-4">
            <!-- Stats Principais -->
            <div class="grid auto-rows-min gap-4 md:grid-cols-5">
                <div class="p-6 bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl shadow-sm hover:shadow-md transition-shadow">
                    <div class="text-sm font-medium text-zinc-500">Total de Chamados</div>
                    <div class="mt-2 text-3xl font-bold">{{ stats.total }}</div>
                </div>
                <div class="p-6 bg-blue-50 dark:bg-blue-900/20 border border-blue-100 dark:border-blue-900/30 rounded-xl shadow-sm hover:shadow-md transition-shadow">
                    <div class="text-sm font-medium text-blue-600 dark:text-blue-400">Em Aberto</div>
                    <div class="mt-2 text-3xl font-bold text-blue-700 dark:text-blue-300">{{ stats.abertos }}</div>
                </div>
                <div class="p-6 bg-amber-50 dark:bg-amber-900/20 border border-amber-100 dark:border-amber-900/30 rounded-xl shadow-sm hover:shadow-md transition-shadow">
                    <div class="text-sm font-medium text-amber-600 dark:text-amber-400">Em Análise</div>
                    <div class="mt-2 text-3xl font-bold text-amber-700 dark:text-amber-300">{{ stats.em_analise }}</div>
                </div>
                <div class="p-6 bg-indigo-50 dark:bg-indigo-900/20 border border-indigo-100 dark:border-indigo-900/30 rounded-xl shadow-sm hover:shadow-md transition-shadow">
                    <div class="text-sm font-medium text-indigo-600 dark:text-indigo-400">Em Execução</div>
                    <div class="mt-2 text-3xl font-bold text-indigo-700 dark:text-indigo-300">{{ stats.em_execucao }}</div>
                </div>
                <div class="p-6 bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-100 dark:border-emerald-900/30 rounded-xl shadow-sm hover:shadow-md transition-shadow">
                    <div class="text-sm font-medium text-emerald-600 dark:text-emerald-400">Concluídos</div>
                    <div class="mt-2 text-3xl font-bold text-emerald-700 dark:text-emerald-300">{{ stats.concluidos }}</div>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
                <!-- Solicitações Recentes -->
                <div class="lg:col-span-2 bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl shadow-sm overflow-hidden">
                    <div class="p-4 border-b border-zinc-200 dark:border-zinc-800 flex justify-between items-center bg-zinc-50/50 dark:bg-zinc-800/50">
                        <h2 class="text-lg font-semibold tracking-tight">Solicitações Recentes</h2>
                        <Link href="/chamados" class="text-sm font-medium text-indigo-600 hover:text-indigo-500 dark:text-indigo-400 dark:hover:text-indigo-300">Ver todas →</Link>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left text-sm">
                            <thead class="bg-zinc-50 dark:bg-zinc-800/50 text-zinc-500 dark:text-zinc-400 uppercase text-[11px] tracking-wider">
                                <tr>
                                    <th class="px-6 py-3 font-semibold">Chamado</th>
                                    <th class="px-6 py-3 font-semibold">Solicitante</th>
                                    <th class="px-6 py-3 font-semibold">Status</th>
                                    <th class="px-6 py-3 font-semibold">Prioridade</th>
                                    <th class="px-6 py-3 font-semibold">Data</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-zinc-200 dark:divide-zinc-800">
                                <tr v-for="chamado in recentChamados" :key="chamado.id" class="hover:bg-zinc-50 dark:hover:bg-zinc-800/30 transition-colors">
                                    <td class="px-6 py-4">
                                        <div class="flex flex-col">
                                            <Link :href="`/chamados/${chamado.id}`" class="font-semibold text-zinc-900 dark:text-white hover:text-indigo-600 dark:hover:text-indigo-400 transition-colors">
                                                #{{ chamado.id }} - {{ chamado.tipo }}
                                            </Link>
                                            <span class="text-zinc-500 dark:text-zinc-400 text-xs mt-0.5">{{ chamado.local }}</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="flex items-center gap-2">
                                            <div class="h-6 w-6 rounded-full bg-zinc-200 dark:bg-zinc-700 flex items-center justify-center text-[10px] font-bold">
                                                {{ chamado.user?.name ? chamado.user.name.charAt(0) : '?' }}
                                            </div>
                                            <span class="text-zinc-700 dark:text-zinc-300 font-medium">{{ chamado.user?.name || 'Usuário Deletado' }}</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <span :class="{
                                            'px-2.5 py-1 rounded-full text-[11px] font-bold inline-flex items-center ring-1 ring-inset': true,
                                            'bg-blue-50 text-blue-700 ring-blue-700/10 dark:bg-blue-900/40 dark:text-blue-400': chamado.status === 'Aberto',
                                            'bg-amber-50 text-amber-700 ring-amber-700/10 dark:bg-amber-900/40 dark:text-amber-400': chamado.status === 'Em Análise',
                                            'bg-indigo-50 text-indigo-700 ring-indigo-700/10 dark:bg-indigo-900/40 dark:text-indigo-400': chamado.status === 'Em Execução',
                                            'bg-emerald-50 text-emerald-700 ring-emerald-700/10 dark:bg-emerald-900/40 dark:text-emerald-400': chamado.status === 'Concluído'
                                        }">
                                            <span class="h-1.5 w-1.5 rounded-full mr-1.5" :class="{
                                                'bg-blue-600': chamado.status === 'Aberto',
                                                'bg-amber-600': chamado.status === 'Em Análise',
                                                'bg-indigo-600': chamado.status === 'Em Execução',
                                                'bg-emerald-600': chamado.status === 'Concluído',
                                            }"></span>
                                            {{ chamado.status }}
                                        </span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <span :class="{
                                            'font-medium': true,
                                            'text-rose-600': chamado.prioridade === 'Alta',
                                            'text-amber-600': chamado.prioridade === 'Média',
                                            'text-zinc-600': chamado.prioridade === 'Baixa'
                                        }">{{ chamado.prioridade }}</span>
                                    </td>
                                    <td class="px-6 py-4 text-zinc-500 dark:text-zinc-400 whitespace-nowrap">{{ new Date(chamado.created_at).toLocaleDateString() }}</td>
                                </tr>
                                <tr v-if="recentChamados.length === 0">
                                    <td colspan="5" class="px-6 py-10 text-center text-zinc-500 italic">
                                        Nenhuma solicitação encontrada.
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Top Usuários -->
                <div class="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl shadow-sm overflow-hidden">
                    <div class="p-4 border-b border-zinc-200 dark:border-zinc-800">
                        <h2 class="text-lg font-semibold tracking-tight">Usuários Mais Ativos</h2>
                    </div>
                    <div class="p-4 space-y-4">
                        <div v-for="(user, idx) in topUsers" :key="user.id" class="flex items-center gap-3">
                            <div class="w-8 h-8 rounded-full bg-indigo-500 dark:bg-indigo-600 flex items-center justify-center text-white text-xs font-bold">
                                {{ user.name.charAt(0) }}
                            </div>
                            <div class="flex-1 min-w-0">
                                <p class="text-sm font-medium text-zinc-900 dark:text-white truncate">{{ user.name }}</p>
                                <p class="text-xs text-zinc-500 dark:text-zinc-400">{{ user.cargo }}</p>
                            </div>
                            <span class="text-sm font-bold text-indigo-600 dark:text-indigo-400">{{ user.chamados_count }}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>