<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    chamado: any;
}>();

const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Dashboard',
        href: '/dashboard',
    },
    {
        title: 'Chamados',
        href: '/chamados',
    },
    {
        title: `Detalhes do Chamado #${props.chamado.id}`,
        href: `/chamados/${props.chamado.id}`,
    },
];

const getStatusClass = (status: string) => {
    switch (status) {
        case 'Aberto': return 'bg-blue-100 text-blue-700 dark:bg-blue-900/40 dark:text-blue-400';
        case 'Em Análise': return 'bg-amber-100 text-amber-700 dark:bg-amber-900/40 dark:text-amber-400';
        case 'Em Execução': return 'bg-indigo-100 text-indigo-700 dark:bg-indigo-900/40 dark:text-indigo-400';
        case 'Concluído': return 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/40 dark:text-emerald-400';
        default: return 'bg-zinc-100 text-zinc-700';
    }
};
</script>

<template>
    <Head :title="`Chamado #${chamado.id}`" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="flex h-full flex-1 flex-col gap-6 p-4 max-w-5xl mx-auto w-full">
            <div class="flex justify-between items-start">
                <div>
                    <h1 class="text-3xl font-extrabold text-zinc-900 dark:text-white">Chamado #{{ chamado.id }}</h1>
                    <p class="text-zinc-500 mt-1">Registrado em {{ new Date(chamado.created_at).toLocaleString() }}</p>
                </div>
                <div class="flex gap-2">
                    <Link 
                        :href="`/chamados/${chamado.id}/edit`" 
                        class="px-4 py-2 bg-white dark:bg-zinc-800 border border-zinc-200 dark:border-zinc-700 text-zinc-700 dark:text-white font-bold rounded-xl shadow-sm hover:bg-zinc-50 transition-colors"
                    >
                        Editar
                    </Link>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Informações Principais -->
                <div class="md:col-span-2 space-y-6">
                    <div class="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-2xl shadow-sm p-6">
                        <h2 class="text-lg font-bold mb-4 flex items-center gap-2">
                            <span class="p-1.5 bg-indigo-100 dark:bg-indigo-900/30 rounded text-indigo-600 dark:text-indigo-400">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                            </span>
                            Detalhes da Solicitação
                        </h2>
                        
                        <div class="grid grid-cols-2 gap-4 mb-6">
                            <div>
                                <label class="text-xs uppercase tracking-wider text-zinc-500 font-bold">Tipo</label>
                                <p class="text-zinc-900 dark:text-white font-semibold">{{ chamado.tipo }}</p>
                            </div>
                            <div>
                                <label class="text-xs uppercase tracking-wider text-zinc-500 font-bold">Local</label>
                                <p class="text-zinc-900 dark:text-white font-semibold">{{ chamado.local }}</p>
                            </div>
                        </div>

                        <div>
                            <label class="text-xs uppercase tracking-wider text-zinc-500 font-bold">Descrição</label>
                            <div class="mt-1 p-4 bg-zinc-50 dark:bg-zinc-800/50 rounded-xl text-zinc-700 dark:text-zinc-300 leading-relaxed">
                                {{ chamado.descricao }}
                            </div>
                        </div>
                    </div>

                    <!-- Histórico de Status -->
                    <div class="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-2xl shadow-sm p-6">
                        <h2 class="text-lg font-bold mb-4">Histórico de Movimentações</h2>
                        <div class="space-y-4">
                            <div v-for="hist in chamado.historicos" :key="hist.id" class="flex gap-4 relative">
                                <div class="flex flex-col items-center">
                                    <div class="h-10 w-10 rounded-full bg-zinc-100 dark:bg-zinc-800 flex items-center justify-center z-10">
                                        <div class="h-2 w-2 rounded-full bg-indigo-600"></div>
                                    </div>
                                    <div class="w-px h-full bg-zinc-200 dark:bg-zinc-800 absolute top-10"></div>
                                </div>
                                <div class="pb-6">
                                    <p class="font-bold text-zinc-900 dark:text-white">Status alterado para <span class="text-indigo-600">{{ hist.status_novo }}</span></p>
                                    <p class="text-xs text-zinc-500 mt-1">
                                        Alterado por <span class="font-bold">{{ hist.user.name }}</span> em {{ new Date(hist.data_alteracao).toLocaleString() }}
                                    </p>
                                    <p class="text-xs text-zinc-400 mt-0.5">Status anterior: {{ hist.status_anterior }}</p>
                                </div>
                            </div>
                            <div v-if="chamado.historicos.length === 0" class="text-zinc-500 text-sm italic py-4">
                                Nenhuma movimentação registrada além da abertura.
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Sidebar de Status/Responsável -->
                <div class="space-y-6">
                    <div class="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-2xl shadow-sm p-6">
                        <label class="text-xs uppercase tracking-wider text-zinc-500 font-bold block mb-3">Status Atual</label>
                        <span :class="['px-4 py-2 rounded-xl font-bold block text-center ring-1 ring-inset', getStatusClass(chamado.status)]">
                            {{ chamado.status }}
                        </span>
                        
                        <div class="mt-6">
                            <label class="text-xs uppercase tracking-wider text-zinc-500 font-bold block mb-1">Prioridade</label>
                            <p class="font-bold" :class="{
                                'text-rose-600': chamado.prioridade === 'Alta',
                                'text-amber-600': chamado.prioridade === 'Média',
                                'text-zinc-700 dark:text-zinc-300': chamado.prioridade === 'Baixa'
                            }">{{ chamado.prioridade }}</p>
                        </div>

                        <div class="mt-6 pt-6 border-t border-zinc-100 dark:border-zinc-800">
                            <label class="text-xs uppercase tracking-wider text-zinc-500 font-bold block mb-2">Solicitante</label>
                            <div class="flex items-center gap-3">
                                <div class="h-10 w-10 rounded-xl bg-indigo-50 dark:bg-indigo-900/20 flex items-center justify-center font-bold text-indigo-600">
                                    {{ chamado.user.name.charAt(0) }}
                                </div>
                                <div>
                                    <p class="font-bold text-sm">{{ chamado.user.name }}</p>
                                    <p class="text-[10px] text-zinc-500">{{ chamado.user.email }}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Orçamentos -->
                    <div class="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-2xl shadow-sm p-6">
                        <h3 class="font-bold flex items-center justify-between mb-4">
                            Orçamentos
                            <span class="bg-zinc-100 dark:bg-zinc-800 px-2 py-0.5 rounded text-[10px] font-bold">{{ chamado.orcamentos.length }}</span>
                        </h3>
                        <div class="space-y-3">
                            <div v-for="orc in chamado.orcamentos" :key="orc.id" class="p-3 border border-zinc-100 dark:border-zinc-800 rounded-xl bg-zinc-50/50 dark:bg-zinc-800/30">
                                <div class="flex justify-between items-start mb-1">
                                    <span class="font-bold text-sm">{{ orc.fornecedor }}</span>
                                    <span class="text-emerald-600 font-bold text-sm">R$ {{ orc.valor }}</span>
                                </div>
                                <p class="text-[10px] text-zinc-500 line-clamp-2 mb-2">{{ orc.descricao_pecas }}</p>
                                <span class="px-2 py-0.5 bg-amber-50 text-amber-600 text-[9px] font-bold rounded uppercase ring-1 ring-amber-500/20">
                                    {{ orc.status }}
                                </span>
                            </div>
                            <div v-if="chamado.orcamentos.length === 0" class="text-center py-4 text-zinc-400 text-xs italic">
                                Nenhum orçamento anexado.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
