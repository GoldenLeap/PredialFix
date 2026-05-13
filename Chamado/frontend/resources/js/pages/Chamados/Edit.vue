<script setup lang="ts">
import { Head, useForm, Link, router } from '@inertiajs/vue3';
import { ChevronLeft } from 'lucide-vue-next';
import { ref, computed } from 'vue';

const props = defineProps<{
    chamado: any;
}>();

const form = useForm({
    tipo: props.chamado.tipo,
    local: props.chamado.local,
    descricao: props.chamado.descricao,
    prioridade: props.chamado.prioridade,
    status: props.chamado.status,
    assunto: props.chamado.assunto,
    tipo_servico: props.chamado.tipo_servico,
    observacao: props.chamado.observacao || '',
});

const submit = () => {
    form.put(`/chamados/${props.chamado.id}`, {
        preserveScroll: true,
        onSuccess: () => {
            router.visit(`/chamados/${props.chamado.id}`);
        },
    });
};

const statusOptions = ['Aberto', 'Em Análise', 'Em Execução', 'Concluído'];

const statusColor = computed(() => {
    const s = form.status?.toLowerCase();
    if (s?.includes('aberto')) return 'bg-gray-500';
    if (s?.includes('análise') || s?.includes('analise')) return 'bg-amber-500';
    if (s?.includes('execução') || s?.includes('execucao') || s?.includes('progresso')) return 'bg-blue-500';
    if (s?.includes('concluído') || s?.includes('concluido')) return 'bg-emerald-500';
    return 'bg-gray-400';
});
</script>

<template>
    <Head :title="`Editar Chamado #${chamado.id}`" />

    <div class="min-h-screen bg-white text-black font-sans">

        <!-- Navegação Superior -->
        <nav class="bg-white border-b border-gray-100 px-8 py-4 sticky top-0 z-10 flex items-center">
            <Link href="/chamados" class="flex items-center gap-2 text-gray-400 hover:text-[#ED1C24] transition-all font-bold text-sm">
                <ChevronLeft class="w-5 h-5" />
                Voltar ao Histórico
            </Link>
        </nav>

        <div class="p-8 max-w-2xl mx-auto w-full animate-in fade-in slide-in-from-bottom-4 duration-700">
            <div class="mb-10 text-center">
                <h1 class="text-4xl font-black text-black mb-2 tracking-tight">Editar <span class="text-[#ED1C24]">Chamado</span></h1>
                <p class="text-gray-400 font-bold uppercase text-[10px] tracking-widest">Protocolo #{{ chamado.id }}</p>
            </div>

            <form @submit.prevent="submit" class="bg-white border border-gray-100 rounded-[2.5rem] p-10 shadow-xl shadow-gray-100/50 space-y-8">

                <!-- Status Atual -->
                <div>
                    <label class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-3 ml-1">Status Atual</label>
                    <select
                        v-model="form.status"
                        class="w-full bg-gray-50 border border-gray-100 rounded-2xl px-6 py-4 text-sm text-gray-600 focus:outline-none focus:border-gray-300 transition-all appearance-none outline-none"
                    >
                        <option v-for="s in statusOptions" :key="s" :value="s">{{ s }}</option>
                    </select>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <div>
                        <label class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-3 ml-1">Tipo</label>
                        <select
                            v-model="form.tipo"
                            class="w-full bg-gray-50 border border-gray-100 rounded-2xl px-6 py-4 text-sm text-gray-600 focus:outline-none focus:border-gray-300 transition-all appearance-none outline-none"
                        >
                            <option value="Elétrica">Elétrica</option>
                            <option value="Hidráulica">Hidráulica</option>
                            <option value="Infraestrutura">Infraestrutura</option>
                            <option value="Outros">Outros</option>
                        </select>
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-3 ml-1">Assunto</label>
                    <input
                        type="text"
                        v-model="form.assunto"
                        class="w-full bg-gray-50 border border-gray-100 rounded-2xl px-6 py-4 text-sm text-gray-600 focus:outline-none focus:border-gray-300 transition-all outline-none"
                    />
                </div>

                <div>
                    <label class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-3 ml-1">Local/Ambiente</label>
                    <input
                        type="text"
                        v-model="form.local"
                        class="w-full bg-gray-50 border border-gray-100 rounded-2xl px-6 py-4 text-sm text-gray-600 focus:outline-none focus:border-gray-300 transition-all outline-none"
                    />
                </div>

                <div>
                    <label class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-3 ml-1">Descrição</label>
                    <textarea
                        v-model="form.descricao"
                        rows="4"
                        class="w-full bg-gray-50 border border-gray-100 rounded-2xl px-6 py-4 text-sm text-gray-600 focus:outline-none focus:border-gray-300 transition-all outline-none resize-none"
                    ></textarea>
                </div>

                <div>
                    <label class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-3 ml-1">Tipo de Serviço</label>
                    <div class="flex gap-4">
                        <label v-for="t in ['Interno', 'Externo']" :key="t" class="flex-1">
                            <input
                                type="radio"
                                v-model="form.tipo_servico"
                                :value="t"
                                class="sr-only peer"
                            />
                            <div class="px-4 py-4 text-center rounded-2xl border-2 border-gray-50 bg-gray-50 cursor-pointer peer-checked:border-[#ED1C24] peer-checked:bg-white transition-all shadow-sm active:scale-95">
                                <span class="text-xs font-black uppercase tracking-tight text-gray-400 peer-checked:text-[#ED1C24]">{{ t }}</span>
                            </div>
                        </label>
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-black text-gray-400 uppercase tracking-widest mb-3 ml-1">Observação (opcional)</label>
                    <textarea
                        v-model="form.observacao"
                        rows="2"
                        class="w-full bg-gray-50 border border-gray-100 rounded-2xl px-6 py-4 text-sm text-gray-600 focus:outline-none focus:border-gray-300 transition-all outline-none resize-none"
                        placeholder="Adicione uma observação sobre este chamado..."
                    ></textarea>
                </div>

                <div class="pt-6 flex items-center justify-between">
                    <Link
                        :href="`/chamados/${chamado.id}`"
                        class="text-xs font-black text-gray-300 hover:text-gray-400 uppercase tracking-widest transition-colors"
                    >
                        Cancelar
                    </Link>
                    <button
                        type="submit"
                        :disabled="form.processing"
                        class="px-10 py-4 bg-[#ED1C24] hover:bg-red-700 disabled:opacity-50 text-white font-black rounded-2xl shadow-xl shadow-red-500/20 transition-all transform active:scale-95 uppercase text-xs tracking-widest"
                    >
                        {{ form.processing ? 'Salvando...' : 'Atualizar Chamado' }}
                    </button>
                </div>
            </form>
        </div>
    </div>
</template>

<style scoped>
.bg-white { background-color: #ffffff !important; }
.bg-gray-50 { background-color: #f9fafb !important; }
</style>
