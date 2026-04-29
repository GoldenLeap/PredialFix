<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Head, Link, router } from '@inertiajs/vue3';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    chamados: any[];
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
];

const deleteChamado = (id: number) => {
    if (confirm('Tem certeza que deseja excluir este chamado?')) {
        router.delete(`/chamados/${id}`);
    }
};
</script>

<template>
    <Head title="Chamados" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="flex h-full flex-1 flex-col gap-4 overflow-x-auto rounded-xl p-4">
            <div class="flex justify-between items-center mb-4">
                <h1 class="text-2xl font-bold text-zinc-900 dark:text-white">Gerenciamento de Chamados</h1>
                <Link 
                    href="/chamados/create" 
                    class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-lg shadow-sm transition-colors text-sm"
                >
                    Nova Solicitação
                </Link>
            </div>

            <div class="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl shadow-sm overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm border-collapse">
                        <thead class="bg-zinc-50 dark:bg-zinc-800 text-zinc-500 dark:text-zinc-400 uppercase text-[11px] tracking-wider">
                            <tr>
                                <th class="px-6 py-3 font-semibold">ID</th>
                                <th class="px-6 py-3 font-semibold">Tipo</th>
                                <th class="px-6 py-3 font-semibold">Local</th>
                                <th class="px-6 py-3 font-semibold">Status</th>
                                <th class="px-6 py-3 font-semibold">Prioridade</th>
                                <th class="px-6 py-3 font-semibold">Solicitante</th>
                                <th class="px-6 py-3 font-semibold text-right">Ações</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-zinc-200 dark:divide-zinc-800">
                            <tr v-for="chamado in chamados" :key="chamado.id" class="hover:bg-zinc-50 dark:hover:bg-zinc-800/30 transition-colors">
                                <td class="px-6 py-4 font-mono text-zinc-500">#{{ chamado.id }}</td>
                                <td class="px-6 py-4 font-semibold text-zinc-900 dark:text-white">{{ chamado.tipo }}</td>
                                <td class="px-6 py-4 text-zinc-600 dark:text-zinc-400">{{ chamado.local }}</td>
                                <td class="px-6 py-4 text-xs">
                                    <span :class="{
                                        'px-2 py-1 rounded-full font-bold uppercase tracking-tighter ring-1 ring-inset': true,
                                        'bg-blue-50 text-blue-700 ring-blue-700/10 dark:bg-blue-900/40 dark:text-blue-400': chamado.status === 'Aberto',
                                        'bg-amber-50 text-amber-700 ring-amber-700/10 dark:bg-amber-900/40 dark:text-amber-400': chamado.status === 'Em Análise',
                                        'bg-indigo-50 text-indigo-700 ring-indigo-700/10 dark:bg-indigo-900/40 dark:text-indigo-400': chamado.status === 'Em Execução',
                                        'bg-emerald-50 text-emerald-700 ring-emerald-700/10 dark:bg-emerald-900/40 dark:text-emerald-400': chamado.status === 'Concluído'
                                    }">{{ chamado.status }}</span>
                                </td>
                                <td class="px-6 py-4">
                                     <span :class="{
                                        'font-medium': true,
                                        'text-rose-600': chamado.prioridade === 'Alta',
                                        'text-amber-600': chamado.prioridade === 'Média',
                                        'text-zinc-600': chamado.prioridade === 'Baixa'
                                    }">{{ chamado.prioridade }}</span>
                                </td>
                                <td class="px-6 py-4 text-zinc-500">{{ chamado.user.name }}</td>
                                <td class="px-6 py-4 text-right space-x-2">
                                    <Link :href="`/chamados/${chamado.id}`" class="text-zinc-400 hover:text-indigo-600 transition-colors">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 inline" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                        </svg>
                                    </Link>
                                    <Link :href="`/chamados/${chamado.id}/edit`" class="text-zinc-400 hover:text-amber-600 transition-colors">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 inline" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                        </svg>
                                    </Link>
                                    <button @click="deleteChamado(chamado.id)" class="text-zinc-400 hover:text-rose-600 transition-colors border-none p-0 bg-transparent cursor-pointer">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 inline" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                        </svg>
                                    </button>
                                </td>
                            </tr>
                            <tr v-if="chamados.length === 0">
                                <td colspan="7" class="px-6 py-10 text-center text-zinc-500 italic">
                                    Nenhum chamado registrado.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
