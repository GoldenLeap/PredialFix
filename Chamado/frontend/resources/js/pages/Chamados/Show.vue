<script setup lang="ts">
import { Head, Link, useForm, router } from '@inertiajs/vue3';
import { ArrowLeft, CheckCircle2, Clock, CheckCircle, MapPin, RefreshCcw, Send } from 'lucide-vue-next';
import { ref, computed } from 'vue';

const props = defineProps<{
    chamado: any;
    historico: any[];
}>();

// Função para voltar à página anterior
const goBack = () => {
    window.history.back();
};

// Define o pipeline de status esperado e os ícones
const pipelineSteps = [
    { key: 'criado', label: 'Criado', desc: 'Solicitação criada pelo solicitante' },
    { key: 'em_analise', label: 'Em análise', desc: 'Solicitação aguardando avaliação' },
    { key: 'em_execucao', label: 'Em progresso', desc: 'Técnicos trabalhando para resolver o problema' },
    { key: 'concluido', label: 'Concluído', desc: 'Problema resolvido' },
];

// Status order para comparação
const statusOrder: Record<string, number> = {
    'criado': 0,
    'em_analise': 1,
    'em_execucao': 2,
    'concluido': 3,
};

const getStatusKey = (status: string): string => {
    const s = status.toLowerCase();
    if (s.includes('análise') || s.includes('analise')) return 'em_analise';
    if (s.includes('execução') || s.includes('execucao') || s.includes('progresso')) return 'em_execucao';
    if (s.includes('concluído') || s.includes('concluido')) return 'concluido';
    if (s.includes('aberto') || s.includes('criado')) return 'criado';
    return 'criado';
};

// Lógica para determinar o estado de cada passo (completo, atual, futuro)
const getStepStatus = (stepIndex: number) => {
    const currentKey = getStatusKey(props.chamado.status);
    const currentIndex = statusOrder[currentKey] ?? 0;

    if (stepIndex < currentIndex) return 'completed';
    if (stepIndex === currentIndex) return 'current';
    return 'pending';
};

// Pega a data de conclusão/alteração do passo
const getStepDate = (stepIndex: number) => {
    const stepKeys = ['criado', 'em_analise', 'em_execucao', 'concluido'];
    const stepKey = stepKeys[stepIndex];

    if (stepIndex === 0) {
        return new Date(props.chamado.created_at).toLocaleString([], { dateStyle: 'medium', timeStyle: 'short' });
    }

    // Primeiro, tenta encontrar nos históricos recebidos
    const historicos = props.historico || props.chamado.historicos || [];
    const statusMap: Record<string, string> = {
        'em_analise': 'Em Análise',
        'em_execucao': 'Em Execução',
        'em_progresso': 'Em Execução',
        'concluido': 'Concluído',
    };

    let hist = null;
    for (const [key, label] of Object.entries(statusMap)) {
        if (stepKey === key) {
            hist = historicos.find((h: any) => {
                const sn = (h.status_novo || '').toLowerCase();
                return sn.includes(key);
            });
        }
    }

    if (hist) return new Date(hist.data_alteracao).toLocaleString([], { dateStyle: 'medium', timeStyle: 'short' });

    return 'Aguardando...';
};

// Formulário para atualizar status
const statusForm = useForm({
    status: props.chamado.status,
    observacao: '',
});

const statusOptions = [
    { value: 'Em Análise', label: 'Em Análise' },
    { value: 'Em Execução', label: 'Em Execução' },
    { value: 'Concluído', label: 'Concluído' },
];

const canUpdateStatus = computed(() => {
    return statusForm.status !== props.chamado.status;
});

const submitStatusUpdate = () => {
    if (!canUpdateStatus.value) return;
    const oldStatus = props.chamado.status;
    router.post(`/chamados/${props.chamado.id}`, {
        _method: 'PUT',
        status: statusForm.status,
        observacao: statusForm.observacao,
    }, {
        preserveScroll: true,
        onSuccess: () => {
            statusForm.observacao = '';
        },
    });
};
</script>

<template>
    <Head :title="`Solicitação #${chamado.id}`" />

    <div class="min-h-screen bg-gray-50 text-black font-sans pb-20">

        <!-- Header Vermelho Sólido -->
        <div class="bg-[#FF0000] py-6 px-8 flex items-center relative shadow-sm">
            <!-- Botão de Voltar Dinâmico -->
            <button @click="goBack" class="absolute left-8 hover:opacity-80 transition-opacity cursor-pointer outline-none">
                <ArrowLeft class="w-8 h-8 text-white" stroke-width="2.5" />
            </button>
            <h1 class="w-full text-center text-2xl font-bold text-white tracking-tight">Solicitação #{{ chamado.id }}</h1>
        </div>

        <div class="p-8 max-w-5xl mx-auto space-y-12 mt-4">

            <!-- Card de Detalhes Principais -->
            <div class="bg-white border border-gray-200 rounded-3xl p-8 md:p-10 shadow-sm relative">
                <div class="flex flex-col md:flex-row justify-between items-start gap-4 mb-8">
                    <h2 class="text-2xl font-black text-gray-900 tracking-tight leading-none">
                        {{ chamado.assunto || chamado.tipo }}
                    </h2>
                    <span class="bg-[#007BFF] text-white px-5 py-2 rounded-full text-sm font-bold whitespace-nowrap shadow-sm">
                        {{ chamado.status }}
                    </span>
                </div>

                <div class="space-y-6">
                    <div>
                        <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-1 block">Localização</span>
                        <p class="text-gray-900 font-medium text-base flex items-center gap-2">
                            <span class="text-gray-400"><MapPin /></span> {{ chamado.local }}
                        </p>
                    </div>
                    <div>
                        <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-2 block">Descrição do problema</span>
                        <div class="bg-gray-50 p-6 rounded-2xl border border-gray-100/80">
                            <p class="text-gray-600 leading-relaxed text-sm whitespace-pre-wrap">
                                {{ chamado.descricao }}
                            </p>
                        </div>
                    </div>
                    <div v-if="chamado.observacao" class="">
                        <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-2 block">Observação do Admin</span>
                        <div class="bg-amber-50 p-4 rounded-2xl border border-amber-100">
                            <p class="text-amber-800 text-sm leading-relaxed">
                                {{ chamado.observacao }}
                            </p>
                        </div>
                    </div>
                    <div v-if="chamado.imagem_url" class="flex flex-col items-center">
                        <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-2 block w-full text-left">
                            Evidência do Problema
                        </span>
                        <div class="w-full max-w-sm bg-gray-50 rounded-2xl p-2 border border-gray-100 shadow-sm">
                            <img
                                :src="chamado.imagem_url"
                                alt="Imagem do problema"
                                class="w-full h-64 object-cover rounded-xl border border-gray-200/50 shadow-inner"
                            />
                        </div>
                    </div>

                    <!-- Painel de Atualização de Status (Admin) -->
                    <div class="mt-6 bg-blue-50/50 border border-blue-100 rounded-2xl p-6">
                        <h4 class="text-sm font-bold text-blue-900 mb-3 flex items-center gap-2">
                            <RefreshCcw class="w-4 h-4" />
                            Atualizar Status
                        </h4>
                        <form @submit.prevent="submitStatusUpdate" class="space-y-4">
                            <div>
                                <label class="block text-xs font-bold text-blue-700 mb-1">Novo Status</label>
                                <select
                                    v-model="statusForm.status"
                                    class="w-full border border-blue-200 bg-white rounded-xl px-4 py-3 text-sm text-gray-700 focus:outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-200 transition-all appearance-none"
                                >
                                    <option v-for="opt in statusOptions" :key="opt.value" :value="opt.value">
                                        {{ opt.label }}
                                    </option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-blue-700 mb-1">Observação (opcional)</label>
                                <textarea
                                    v-model="statusForm.observacao"
                                    rows="2"
                                    placeholder="Adicione uma observação sobre esta atualização..."
                                    class="w-full border border-blue-200 bg-white rounded-xl px-4 py-3 text-sm text-gray-700 focus:outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-200 transition-all resize-none"
                                ></textarea>
                            </div>
                            <button
                                type="submit"
                                :disabled="!canUpdateStatus || statusForm.processing"
                                class="w-full px-6 py-3 bg-[#007BFF] hover:bg-blue-700 disabled:opacity-40 disabled:cursor-not-allowed text-white font-bold rounded-xl text-sm shadow-md transition-all active:scale-[0.98]"
                            >
                                {{ statusForm.processing ? 'Salvando...' : 'Atualizar Status' }}
                                <Send class="inline w-4 h-4 ml-2" />
                            </button>
                        </form>
                    </div>

                </div>
            </div>

            <!-- Linha do Tempo -->
            <div class="space-y-8">
                <h3 class="text-center font-bold text-black text-lg">Linha do Tempo</h3>
                <div class="relative pt-6">
                    <div class="hidden lg:block absolute top-[152px] left-[12.5%] right-[12.5%] h-0.5 bg-gray-200 -z-0"></div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 pt-6">
                        <div
                            v-for="(step, index) in pipelineSteps"
                            :key="step.key"
                            class="relative pt-6"
                        >
                            <div class="absolute top-0 left-1/2 -translate-x-1/2 -translate-y-1/2 z-10 flex items-center justify-center bg-gray-50 rounded-full p-1">
                                <CheckCircle2
                                    v-if="getStepStatus(index) === 'completed'"
                                    class="text-[#00C853] w-8 h-8 fill-current text-white"
                                />
                                <Clock
                                    v-else-if="getStepStatus(index) === 'current'"
                                    class="text-[#007BFF] w-8 h-8 fill-[#007BFF] text-white"
                                />
                                <CheckCircle
                                    v-else
                                    class="text-gray-300 w-8 h-8 fill-gray-300 text-white"
                                />
                            </div>

                            <div class="bg-white border border-gray-200 rounded-2xl p-6 shadow-sm h-full flex flex-col justify-between">
                                <div>
                                    <h4 class="font-bold text-black mb-3">{{ step.label }}</h4>
                                    <p class="text-xs text-gray-400 mb-6 leading-relaxed">{{ step.desc }}</p>
                                </div>
                                <div class="flex items-center gap-1.5 text-[10px] text-gray-400 font-medium">
                                    <Clock class="w-3 h-3" />
                                    <span>{{ getStepDate(index) }}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Histórico de Mudanças -->
                <div v-if="(historico || chamado.historicos) && (historico.length > 0 || (chamado.historicos && chamado.historicos.length > 0))" class="mt-8 bg-white border border-gray-200 rounded-2xl p-6 shadow-sm">
                    <h4 class="text-sm font-bold text-gray-900 mb-4">Histórico de Mudanças de Status</h4>
                    <div class="space-y-3">
                        <div
                            v-for="(item, idx) in (historico || chamado.historicos || [])"
                            :key="idx"
                            class="flex items-start gap-3 text-sm"
                        >
                            <div class="w-2 h-2 rounded-full bg-[#ED1C24] mt-1.5 flex-shrink-0"></div>
                            <div class="text-gray-600">
                                <span class="font-medium">De {{ item.status_anterior }} → {{ item.status_novo }}</span>
                                <span class="text-gray-400 ml-2 text-xs">{{ new Date(item.data_alteracao).toLocaleString() }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</template>
