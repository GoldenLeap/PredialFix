<script setup lang="ts">
import { Head, Link, useForm } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';
import { Package, Save, ArrowLeft } from 'lucide-vue-next';

const breadcrumbs = [
    { title: 'Painel', href: '/dashboard' },
    { title: 'Materiais', href: '/materiais' },
    { title: 'Criar', href: '/materiais/create' },
];

const form = useForm({
    nome: '',
    categoria: '',
    quantidade_atual: 0,
    quantidade_minima: 0,
    unidade: 'Unidade',
    valor_unitario: 0.0,
    localizacao: '',
});

const submit = () => {
    form.post('/materiais');
};
</script>

<template>
    <Head title="Novo Material" />
    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="max-w-3xl mx-auto flex flex-col gap-6 animate-in fade-in slide-in-from-bottom-3 duration-500">
            <div class="flex items-center gap-4">
                <Link href="/materiais" class="p-2 bg-card hover:bg-muted rounded-xl transition-colors border border-border shadow-sm">
                    <ArrowLeft class="w-5 h-5 text-muted-foreground" />
                </Link>
                <div>
                    <h1 class="text-2xl font-black tracking-tight flex items-center gap-2">
                        <Package class="w-6 h-6 text-primary" />
                        Cadastrar Novo Material
                    </h1>
                    <p class="text-sm text-muted-foreground mt-1">Adicione um novo insumo ao controle de estoque.</p>
                </div>
            </div>

            <div class="bg-card border border-border rounded-2xl p-6 sm:p-8 shadow-sm">
                <form @submit.prevent="submit" class="space-y-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="space-y-2 md:col-span-2">
                            <label class="text-sm font-semibold text-foreground">Nome do Material</label>
                            <input type="text" v-model="form.nome" required class="w-full bg-muted border border-border rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all" placeholder="Ex: Lâmpada LED 15W">
                        </div>

                        <div class="space-y-2">
                            <label class="text-sm font-semibold text-foreground">Categoria</label>
                            <select v-model="form.categoria" required class="w-full bg-muted border border-border rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all appearance-none">
                                <option value="" disabled>Selecione a categoria...</option>
                                <option value="Elétrica">Elétrica</option>
                                <option value="Hidráulica">Hidráulica</option>
                                <option value="Infraestrutura">Infraestrutura</option>
                                <option value="Outros">Outros</option>
                            </select>
                        </div>

                        <div class="space-y-2">
                            <label class="text-sm font-semibold text-foreground">Unidade de Medida</label>
                            <select v-model="form.unidade" required class="w-full bg-muted border border-border rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all">
                                <option value="Unidade">Unidade (un)</option>
                                <option value="Metros">Metros (m)</option>
                                <option value="Caixa">Caixa (cx)</option>
                                <option value="Litros">Litros (L)</option>
                                <option value="Kg">Quilogramas (Kg)</option>
                            </select>
                        </div>

                        <div class="space-y-2">
                            <label class="text-sm font-semibold text-foreground">Quantidade Atual</label>
                            <input type="number" v-model="form.quantidade_atual" min="0" required class="w-full bg-muted border border-border rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all">
                        </div>

                        <div class="space-y-2">
                            <label class="text-sm font-semibold text-foreground">Quantidade Mínima</label>
                            <input type="number" v-model="form.quantidade_minima" min="0" required class="w-full bg-muted border border-border rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all">
                        </div>

                        <div class="space-y-2">
                            <label class="text-sm font-semibold text-foreground">Valor Unitário (R$)</label>
                            <input type="number" step="0.01" v-model="form.valor_unitario" min="0" required class="w-full bg-muted border border-border rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all">
                        </div>

                        <div class="space-y-2">
                            <label class="text-sm font-semibold text-foreground">Localização no Estoque</label>
                            <input type="text" v-model="form.localizacao" class="w-full bg-muted border border-border rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all" placeholder="Ex: Prateleira A2">
                        </div>
                    </div>

                    <div class="pt-4 border-t border-border flex justify-end gap-3">
                        <Link href="/materiais" class="px-6 py-3 font-semibold text-muted-foreground hover:bg-muted rounded-xl transition-all">Cancelar</Link>
                        <button type="submit" :disabled="form.processing" class="flex items-center gap-2 px-6 py-3 bg-primary text-primary-foreground font-semibold rounded-xl hover:bg-primary/90 transition-all shadow-md active:scale-95 disabled:opacity-50">
                            <Save class="w-4 h-4" />
                            Salvar Material
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </AppLayout>
</template>
