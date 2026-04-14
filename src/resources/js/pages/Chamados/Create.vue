<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Head, useForm, Link } from '@inertiajs/vue3';
import type { BreadcrumbItem } from '@/types';

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
        title: 'Novo Chamado',
        href: '/chamados/create',
    },
];

const form = useForm({
    tipo: '',
    local: '',
    descricao: '',
    prioridade: 'Média',
});

const submit = () => {
    form.post('/chamados', {
        onSuccess: () => form.reset(),
    });
};
</script>

<template>
    <Head title="Novo Chamado" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="flex h-full flex-1 flex-col items-center p-4">
            <div class="w-full max-w-2xl bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl shadow-sm p-8">
                <div class="mb-8">
                    <h1 class="text-2xl font-bold text-zinc-900 dark:text-white">Registrar Novo Chamado</h1>
                    <p class="text-zinc-500 text-sm mt-1">Forneça os detalhes da manutenção necessária.</p>
                </div>

                <form @submit.prevent="submit" class="space-y-6">
                    <div>
                        <label class="block text-sm font-semibold text-zinc-700 dark:text-zinc-300 mb-2">Tipo de Manutenção</label>
                        <select 
                            v-model="form.tipo" 
                            class="w-full rounded-lg border-zinc-300 dark:border-zinc-700 dark:bg-zinc-800 dark:text-white shadow-sm focus:border-indigo-500 focus:ring-indigo-500 transition-colors"
                            required
                        >
                            <option value="" disabled>Selecione um tipo...</option>
                            <option value="Elétrica">Elétrica</option>
                            <option value="Hidráulica">Hidráulica</option>
                            <option value="Infraestrutura">Infraestrutura</option>
                            <option value="Outros">Outros</option>
                        </select>
                        <div v-if="form.errors.tipo" class="text-rose-600 text-xs mt-1">{{ form.errors.tipo }}</div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-zinc-700 dark:text-zinc-300 mb-2">Local/Ambiente</label>
                        <input 
                            type="text" 
                            v-model="form.local" 
                            class="w-full rounded-lg border-zinc-300 dark:border-zinc-700 dark:bg-zinc-800 dark:text-white shadow-sm focus:border-indigo-500 focus:ring-indigo-500 transition-colors"
                            placeholder="Ex: Sala 204, Bloco C, Corredor Principal"
                            required
                        />
                        <div v-if="form.errors.local" class="text-rose-600 text-xs mt-1">{{ form.errors.local }}</div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-zinc-700 dark:text-zinc-300 mb-2">Descrição do Problema</label>
                        <textarea 
                            v-model="form.descricao" 
                            rows="4"
                            class="w-full rounded-lg border-zinc-300 dark:border-zinc-700 dark:bg-zinc-800 dark:text-white shadow-sm focus:border-indigo-500 focus:ring-indigo-500 transition-colors"
                            placeholder="Descreva detalhadamente o problema encontrado..."
                            required
                        ></textarea>
                        <div v-if="form.errors.descricao" class="text-rose-600 text-xs mt-1">{{ form.errors.descricao }}</div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-zinc-700 dark:text-zinc-300 mb-2">Prioridade</label>
                        <div class="flex gap-4">
                            <label v-for="p in ['Baixa', 'Média', 'Alta']" :key="p" class="flex-1">
                                <input 
                                    type="radio" 
                                    v-model="form.prioridade" 
                                    :value="p" 
                                    class="sr-only peer"
                                />
                                <div class="px-4 py-3 text-center rounded-xl border-2 border-zinc-100 dark:border-zinc-800 cursor-pointer peer-checked:border-indigo-600 peer-checked:bg-indigo-50 dark:peer-checked:bg-indigo-900/20 transition-all">
                                    <span class="text-sm font-bold" :class="{
                                        'text-rose-600': p === 'Alta',
                                        'text-amber-600': p === 'Média',
                                        'text-zinc-600 dark:text-zinc-400': p === 'Baixa'
                                    }">{{ p }}</span>
                                </div>
                            </label>
                        </div>
                        <div v-if="form.errors.prioridade" class="text-rose-600 text-xs mt-1">{{ form.errors.prioridade }}</div>
                    </div>

                    <div class="pt-4 flex items-center justify-end gap-4">
                        <Link 
                            href="/chamados" 
                            class="text-sm font-medium text-zinc-500 hover:text-zinc-700 dark:hover:text-zinc-300 transition-colors"
                        >
                            Cancelar
                        </Link>
                        <button 
                            type="submit" 
                            :disabled="form.processing"
                            class="px-6 py-2.5 bg-indigo-600 hover:bg-indigo-700 disabled:opacity-50 text-white font-bold rounded-xl shadow-lg shadow-indigo-600/30 transition-all transform active:scale-95"
                        >
                            {{ form.processing ? 'Enviando...' : 'Criar Solicitação' }}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </AppLayout>
</template>
