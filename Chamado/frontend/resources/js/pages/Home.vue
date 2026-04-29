<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';

const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Início',
        href: '/',
    },
];
</script>

<template>
    <Head title="Bem-vindo ao PredialFix" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="flex h-full flex-1 flex-col items-center justify-center p-4 bg-zinc-50 dark:bg-zinc-950">
            <div class="max-w-4xl w-full text-center py-12 px-6 bg-white dark:bg-zinc-900 rounded-3xl shadow-xl border border-zinc-200 dark:border-zinc-800">
                <div class="mb-8 flex justify-center">
                    <div class="h-30 w-100 rounded-2xl flex items-center justify-center shadow-inner">
                       <img src="/logo (2).png" alt="Logo" class="h-20 w-auto rounded-2xl">
                    </div>
                </div>
                
                <h1 class="text-4xl md:text-5xl font-extrabold tracking-tight text-zinc-900 dark:text-white mb-6">
                    Bem-vindo ao <span class="text-indigo-600 dark:text-indigo-400">PredialFix</span>
                </h1>
                
                <p class="text-lg md:text-xl text-zinc-600 dark:text-zinc-400 mb-10 max-w-2xl mx-auto leading-relaxed">
                    Sua plataforma centralizada para gerenciamento de manutenção predial no Senai. 
                    Transparência, agilidade e eficiência em cada solicitação.
                </p>

                <div class="flex flex-col sm:flex-row gap-4 justify-center">
                    <Link 
                        href="/dashboard" 
                        class="px-8 py-4 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-2xl shadow-lg shadow-indigo-600/30 transition-all transform hover:-translate-y-1 active:scale-95"
                    >
                        Ir para o Dashboard
                    </Link>
                    <Link 
                        href="/chamados/create" 
                        class="px-8 py-4 bg-white dark:bg-zinc-800 text-zinc-900 dark:text-white font-bold rounded-2xl shadow-lg border border-zinc-200 dark:border-zinc-700 hover:bg-zinc-50 dark:hover:bg-zinc-700 transition-all transform hover:-translate-y-1 active:scale-95"
                    >
                        Abrir Novo Chamado
                    </Link>
                </div>

                <div class="mt-16 grid grid-cols-1 md:grid-cols-3 gap-8 text-left">
                    <div class="p-6 rounded-2xl bg-zinc-50 dark:bg-zinc-800/50 border border-zinc-100 dark:border-zinc-800">
                        <div class="text-indigo-600 dark:text-indigo-400 font-bold mb-2">Gestão Unificada</div>
                        <p class="text-sm text-zinc-500">Todos os chamados de manutenção em um único lugar para fácil acompanhamento.</p>
                    </div>
                    <div class="p-6 rounded-2xl bg-zinc-50 dark:bg-zinc-800/50 border border-zinc-100 dark:border-zinc-800">
                        <div class="text-indigo-600 dark:text-indigo-400 font-bold mb-2">Histórico Completo</div>
                        <p class="text-sm text-zinc-500">Acompanhe cada mudança de status e auditoria de quem realizou a manutenção.</p>
                    </div>
                    <div class="p-6 rounded-2xl bg-zinc-50 dark:bg-zinc-800/50 border border-zinc-100 dark:border-zinc-800">
                        <div class="text-indigo-600 dark:text-indigo-400 font-bold mb-2">Aprovação Rápida</div>
                        <p class="text-sm text-zinc-500">Sistema de orçamentos integrado para aprovações imediatas e redução de atrasos.</p>
                    </div>
                </div>
            </div>
            
            <footer class="mt-8 text-zinc-400 text-sm">
                &copy; 2026 PredialFix - Senai Maintenance System
            </footer>
        </div>
    </AppLayout>
</template>
