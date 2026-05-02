<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import { ArrowLeft, CheckCircle2, Clock, CheckCircle, MapPin } from 'lucide-vue-next';

const props = defineProps<{
    chamado: any;
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

// Lógica para determinar o estado de cada passo (completo, atual, futuro)
const getStepStatus = (stepIndex: number) => {
    const currentStatus = props.chamado.status.toLowerCase();
    
    let currentIndex = 0;
    if (currentStatus.includes('análise')) currentIndex = 1;
    else if (currentStatus.includes('execução') || currentStatus.includes('progresso')) currentIndex = 2;
    else if (currentStatus.includes('concluído')) currentIndex = 3;

    if (stepIndex < currentIndex) return 'completed';
    if (stepIndex === currentIndex) return 'current';
    return 'pending';
};

// Pega a data de conclusão/alteração do passo (
const getStepDate = (stepIndex: number) => {
    if (stepIndex === 0) return new Date(props.chamado.created_at).toLocaleString([], { dateStyle: 'medium', timeStyle: 'short' });
    
    const historicos = props.chamado.historicos || [];
    let hist = null;
    if (stepIndex === 1) hist = historicos.find((h: any) => h.status_novo.toLowerCase().includes('análise'));
    if (stepIndex === 2) hist = historicos.find((h: any) => h.status_novo.toLowerCase().includes('execução') || h.status_novo.toLowerCase().includes('progresso'));
    if (stepIndex === 3) hist = historicos.find((h: any) => h.status_novo.toLowerCase().includes('concluído'));

    if (hist) return new Date(hist.data_alteracao).toLocaleString([], { dateStyle: 'medium', timeStyle: 'short' });
    
    return 'Tempo estimado...';
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
                                <span class="text-gray-400"><MapPin/></span> {{ chamado.local }}
                            </p>
                        </div>     
                        <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-2 block">Descrição do problema</span>               
                        <div class="bg-gray-50 p-6 rounded-2xl border border-gray-100/80">
                            <p class="text-gray-600 leading-relaxed text-sm">
                                {{ chamado.descricao }}
                            </p>
                        </div>
                        <div class="flex flex-col items-center">
                            <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-2 block w-full text-left">
                                Evidência do Problema
                            </span>
                           <div class="w-full max-w-sm bg-gray-50 rounded-2xl p-2 border border-gray-100 shadow-sm">
                                <img 
                                    :src="`/storage/${chamado.imagem_path}`" 
                                    alt="Imagem do problema" 
                                    class="w-full h-64 object-cover rounded-xl border border-gray-200/50 shadow-inner"
                                />
                            </div>
                        </div>
                        
                    
                </div>
            </div>

            <!-- Linha do Tempo -->
            <div class="space-y-8">
                <h3 class="text-center font-bold text-black text-lg">Linha do tempo</h3>
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
            </div>

        </div>
    </div>
</template>

<style scoped>
.bg-white { background-color: #ffffff !important; }
.bg-gray-50 { background-color: #f9fafb !important; }
</style>
