<script setup lang="ts">
import { Head, useForm, router, usePage, Link } from '@inertiajs/vue3';
import { ArrowLeft, CheckCircle2, Clock, CheckCircle, MapPin, RefreshCcw, Send, Package, Camera, Banknote, Plus, Trash2 } from 'lucide-vue-next';
import { computed, ref } from 'vue';

const props = defineProps<{
    chamado: any;
    historico: any[];
    materiais_disponiveis: any[];
}>();

const page = usePage();
const user = computed(() => page.props.auth.user);

const canEditChamado = computed(() => {
    return ['admin', 'responsavel'].includes(user.value?.cargo);
});

const isConcluido = computed(() => props.chamado.status === 'Concluído');

const canUpdateStatus = computed(() => {
    if (!canEditChamado.value) return false;
    return !isConcluido.value;
});

const canEditCosts = computed(() => canEditChamado.value && !isConcluido.value);

const goBack = () => {
    router.visit('/chamados', { replace: true });
};

const pipelineSteps = [
    { key: 'criado', label: 'Criado', desc: 'Solicitação criada' },
    { key: 'em_analise', label: 'Em Análise', desc: 'Avaliando escopo' },
    { key: 'aguardando_material', label: 'Aguardando', desc: 'Falta de material' },
    { key: 'em_execucao', label: 'Em Execução', desc: 'Técnico trabalhando' },
    { key: 'concluido', label: 'Concluído', desc: 'Finalizado' },
];

const statusOrder: Record<string, number> = {
    'criado': 0,
    'em_analise': 1,
    'aguardando_material': 2,
    'em_execucao': 3,
    'concluido': 4,
};

const getStatusKey = (status: string): string => {
    const s = status.toLowerCase();
    if (s.includes('aguardando')) return 'aguardando_material';
    if (s.includes('análise') || s.includes('analise')) return 'em_analise';
    if (s.includes('execução') || s.includes('execucao') || s.includes('progresso')) return 'em_execucao';
    if (s.includes('concluído') || s.includes('concluido')) return 'concluido';
    return 'criado';
};

const getStepStatus = (stepIndex: number) => {
    const currentKey = getStatusKey(props.chamado.status);
    const currentIndex = statusOrder[currentKey] ?? 0;

    if (stepIndex < currentIndex) return 'completed';
    if (stepIndex === currentIndex) return 'current';
    return 'pending';
};

const formatDateTime = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleString('pt-BR', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' });
};

const formatCurrency = (value: number) => {
    return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value);
};

const getStepDate = (stepIndex: number) => {
    const stepKeys = ['criado', 'em_analise', 'aguardando_material', 'em_execucao', 'concluido'];
    const stepKey = stepKeys[stepIndex];

    if (stepIndex === 0) return formatDateTime(props.chamado.created_at);

    const historicos = props.historico || props.chamado.historicos || [];
    const statusMap: Record<string, string> = {
        'em_analise': 'Em Análise',
        'aguardando_material': 'Aguardando Material',
        'em_execucao': 'Em Execução',
        'concluido': 'Concluído',
    };

    let hist = historicos.find((h: any) => (h.status_novo || '').toLowerCase().includes(stepKey.replace('_', ' ')));
    return hist ? formatDateTime(hist.data_alteracao) : 'Aguardando...';
};

const statusForm = useForm({
    status: props.chamado.status,
    observacao: '',
});

const statusOptions = computed(() => {
    return ['Aberto', 'Em Análise', 'Aguardando Material', 'Em Execução', 'Concluído']
        .filter(opt => opt !== props.chamado.status);
});

const hasStatusChange = computed(() => statusForm.status !== props.chamado.status);

const submitStatusUpdate = () => {
    if (!hasStatusChange.value) return;
    router.put(`/chamados/${props.chamado.id}`, statusForm.data(), {
        onSuccess: () => statusForm.reset('observacao'),
    });
};
const laborForm = useForm({
    custo_mao_obra: props.chamado.custo_mao_obra || 0,
});

const submitLaborCost = () => {
    router.put(`/chamados/${props.chamado.id}`, { custo_mao_obra: laborForm.custo_mao_obra }, {
        preserveScroll: true,
    });
};

// ---- Material Management ----
const showAddMaterial = ref(false);
const materialForm = useForm({
    material_id: '',
    quantidade: 1,
});

const selectedMaterial = computed(() =>
    props.materiais_disponiveis.find((m: any) => m.id == materialForm.material_id)
);

const addMaterial = () => {
    if (!materialForm.material_id) return;
    materialForm.post(`/chamados/${props.chamado.id}/materiais`, {
        onSuccess: () => {
            materialForm.reset();
            showAddMaterial.value = false;
        },
    });
};

const removeMaterial = (materialId: number) => {
    if (!confirm('Remover este material do chamado?')) return;
    router.delete(`/chamados/${props.chamado.id}/materiais/${materialId}`);
};

const materiaisAgrupados = computed(() => {
    const grupos: Record<string, any[]> = {};
    props.materiais_disponiveis.forEach(m => {
        const cat = m.categoria || 'Outros';
        if (!grupos[cat]) grupos[cat] = [];
        grupos[cat].push(m);
    });
    return grupos;
});
</script>

<template>
    <Head title="Detalhes do Chamado" />

    <div class="min-h-screen bg-background text-foreground font-sans pb-20">
        <!-- Premium Header -->
        <div class="bg-card/80 backdrop-blur-xl border-b border-border py-6 px-8 flex items-center relative shadow-sm sticky top-0 z-20">
            <button @click="goBack" class="absolute left-8 p-2 rounded-full hover:bg-muted transition-colors cursor-pointer outline-none group">
                <ArrowLeft class="w-6 h-6 text-muted-foreground group-hover:text-primary transition-colors" stroke-width="2.5" />
            </button>
            <h1 class="w-full text-center text-xl font-bold tracking-tight bg-gradient-to-r from-primary to-blue-400 bg-clip-text text-transparent">
                Protocolo #{{ chamado.id }}
            </h1>
            <div v-if="canEditChamado" class="absolute right-8">
                <Link :href="`/chamados/${chamado.id}/edit`" class="text-sm font-semibold text-primary hover:text-primary/80 transition-colors">
                    Editar
                </Link>
            </div>
        </div>

        <div class="p-4 md:p-8 max-w-6xl mx-auto space-y-8 mt-4 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <!-- Main Content Card -->
            <div class="bg-card border border-border/50 rounded-3xl p-6 md:p-10 shadow-xl shadow-black/5 relative overflow-hidden">
                <div class="absolute top-0 right-0 w-64 h-64 bg-primary/5 rounded-full blur-3xl -z-10 -mr-20 -mt-20"></div>
                
                <div class="flex flex-col md:flex-row justify-between items-start gap-4 mb-8">
                    <div>
                        <span class="text-xs font-bold uppercase tracking-widest text-primary/80 mb-2 block">{{ chamado.tipo }}</span>
                        <h2 class="text-3xl font-black tracking-tight leading-none text-foreground">
                            {{ chamado.assunto || chamado.tipo }}
                        </h2>
                    </div>
                    <span class="bg-primary/10 text-primary border border-primary/20 px-5 py-2 rounded-full text-sm font-bold shadow-sm">
                        {{ chamado.status }}
                    </span>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <!-- Coluna da Esquerda (Info Básica) -->
                    <div class="md:col-span-2 space-y-8">
                        <div class="flex flex-col sm:flex-row gap-6">
                            <div class="flex-1">
                                <span class="text-[10px] text-muted-foreground font-bold uppercase tracking-widest mb-1 block">Localização</span>
                                <p class="font-semibold text-sm flex items-center gap-2">
                                    <MapPin class="w-4 h-4 text-primary" /> {{ chamado.local }}
                                    <span v-if="chamado.bloco" class="text-muted-foreground opacity-70">| Bloco: {{ chamado.bloco }}</span>
                                </p>
                            </div>
                            <div v-if="chamado.patrimonio_sim" class="flex-1">
                                <span class="text-[10px] text-muted-foreground font-bold uppercase tracking-widest mb-1 block">Patrimônio</span>
                                <p class="font-semibold text-sm px-3 py-1 bg-muted rounded-lg inline-block">
                                    {{ chamado.numero_patrimonio }}
                                </p>
                            </div>
                        </div>
                        
                        <div>
                            <span class="text-[10px] text-muted-foreground font-bold uppercase tracking-widest mb-2 block">Descrição do problema</span>
                            <div class="bg-muted/40 p-5 rounded-2xl border border-border/50">
                                <p class="text-muted-foreground leading-relaxed text-sm whitespace-pre-wrap">
                                    {{ chamado.descricao }}
                                </p>
                            </div>
                        </div>

                        <!-- Custos e Financeiro -->
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div class="bg-muted/30 p-5 rounded-2xl border border-border/50 flex items-center gap-4">
                                <div class="p-3 bg-primary/10 rounded-xl text-primary"><Banknote class="w-5 h-5"/></div>
                                <div>
                                    <span class="text-xs text-muted-foreground font-semibold">Custo Mão de Obra</span>
                                    <p class="font-bold text-lg">{{ formatCurrency(chamado.custo_mao_obra || 0) }}</p>
                                </div>
                            </div>
                            <div class="bg-muted/30 p-5 rounded-2xl border border-border/50 flex items-center gap-4">
                                <div class="p-3 bg-primary/10 rounded-xl text-primary"><Package class="w-5 h-5"/></div>
                                <div>
                                    <span class="text-xs text-muted-foreground font-semibold">Custo Materiais</span>
                                    <p class="font-bold text-lg">{{ formatCurrency(chamado.custo_materiais || 0) }}</p>
                                </div>
                            </div>
                        </div>

                        <!-- Materiais do Chamado -->
                        <div v-if="canEditCosts" class="space-y-3">
                            <div class="flex items-center justify-between">
                                <span class="text-[10px] text-muted-foreground font-bold uppercase tracking-widest flex items-center gap-2">
                                    <Package class="w-3 h-3"/> Materiais Consumidos
                                </span>
                                <button @click="showAddMaterial = !showAddMaterial"
                                    class="flex items-center gap-1.5 text-xs font-semibold text-primary hover:bg-primary/10 px-3 py-1.5 rounded-xl transition-all">
                                    <Plus class="w-3.5 h-3.5" /> Adicionar
                                </button>
                            </div>

                            <!-- Formulário de adição -->
                            <div v-if="showAddMaterial" class="bg-muted/40 border border-border rounded-2xl p-4 space-y-3 animate-in fade-in slide-in-from-top-2 duration-200">
                                <select v-model="materialForm.material_id"
                                    class="w-full bg-background border border-input rounded-xl px-3 py-2.5 text-sm focus:ring-2 focus:ring-primary outline-none transition-all">
                                    <option value="" disabled>Selecione o material…</option>
                                    <optgroup v-for="(materiais, categoria) in materiaisAgrupados" :key="categoria" :label="categoria">
                                        <option v-for="m in materiais" :key="m.id" :value="m.id" :disabled="m.quantidade_atual <= 0">
                                            {{ m.nome }} ({{ m.quantidade_atual }} {{ m.unidade }} disp. | R$ {{ m.valor_unitario }})
                                        </option>
                                    </optgroup>
                                </select>
                                <div class="flex gap-2">
                                    <div class="flex-1">
                                        <label class="text-[10px] text-muted-foreground font-bold uppercase tracking-widest mb-1 block">Quantidade</label>
                                        <input type="number" v-model.number="materialForm.quantidade" min="1"
                                            class="w-full bg-background border border-input rounded-xl px-3 py-2.5 text-sm focus:ring-2 focus:ring-primary outline-none" />
                                    </div>
                                    <div v-if="selectedMaterial" class="flex-1">
                                        <label class="text-[10px] text-muted-foreground font-bold uppercase tracking-widest mb-1 block">Subtotal</label>
                                        <p class="px-3 py-2.5 text-sm font-bold text-primary">
                                            {{ formatCurrency((selectedMaterial.valor_unitario || 0) * materialForm.quantidade) }}
                                        </p>
                                    </div>
                                </div>
                                <div class="flex gap-2">
                                    <button @click="showAddMaterial = false"
                                        class="flex-1 py-2 text-sm font-semibold text-muted-foreground hover:bg-muted rounded-xl transition-all">Cancelar</button>
                                    <button @click="addMaterial" :disabled="!materialForm.material_id || materialForm.processing"
                                        class="flex-1 py-2 text-sm font-semibold bg-primary text-primary-foreground rounded-xl hover:bg-primary/90 transition-all disabled:opacity-50">
                                        Confirmar
                                    </button>
                                </div>
                            </div>

                            <!-- Lista de materiais já adicionados -->
                            <div v-if="chamado.materiais && chamado.materiais.length > 0" class="bg-card border border-border overflow-hidden rounded-2xl">
                                <table class="w-full text-sm text-left">
                                    <thead class="text-xs text-muted-foreground bg-muted/50 uppercase border-b border-border">
                                        <tr>
                                            <th class="px-4 py-3 font-semibold">Item</th>
                                            <th class="px-4 py-3 font-semibold text-center">Qtd</th>
                                            <th class="px-4 py-3 font-semibold text-right">Subtotal</th>
                                            <th class="px-4 py-3"></th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-border">
                                        <tr v-for="mat in chamado.materiais" :key="mat.id" class="hover:bg-muted/30 transition-colors">
                                            <td class="px-4 py-3 font-medium">{{ mat.nome }}</td>
                                            <td class="px-4 py-3 text-center text-muted-foreground">{{ mat.pivot.quantidade }} {{ mat.unidade }}</td>
                                            <td class="px-4 py-3 text-right font-medium text-primary">{{ formatCurrency(mat.pivot.subtotal) }}</td>
                                            <td class="px-4 py-3 text-center">
                                                <button @click="removeMaterial(mat.id)" class="text-rose-500 hover:text-rose-700 p-1 rounded-lg hover:bg-rose-50 dark:hover:bg-rose-900/20 transition-all">
                                                    <Trash2 class="w-3.5 h-3.5" />
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div v-else class="bg-muted/30 rounded-2xl p-4 text-center text-sm text-muted-foreground italic">
                                Nenhum material adicionado ainda.
                            </div>
                        </div>

                        <!-- Visualização somente leitura (concluído ou não-editor) -->
                        <div v-else-if="chamado.materiais && chamado.materiais.length > 0">
                            <span class="text-[10px] text-muted-foreground font-bold uppercase tracking-widest mb-3 block flex items-center gap-2">
                                <Package class="w-3 h-3"/> Materiais Consumidos
                            </span>
                            <div class="bg-card border border-border overflow-hidden rounded-2xl">
                                <table class="w-full text-sm text-left">
                                    <thead class="text-xs text-muted-foreground bg-muted/50 uppercase border-b border-border">
                                        <tr>
                                            <th class="px-4 py-3 font-semibold">Item</th>
                                            <th class="px-4 py-3 font-semibold text-center">Qtd</th>
                                            <th class="px-4 py-3 font-semibold text-right">Subtotal</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-border">
                                        <tr v-for="mat in chamado.materiais" :key="mat.id" class="hover:bg-muted/30 transition-colors">
                                            <td class="px-4 py-3 font-medium">{{ mat.nome }}</td>
                                            <td class="px-4 py-3 text-center text-muted-foreground">{{ mat.pivot.quantidade }} {{ mat.unidade }}</td>
                                            <td class="px-4 py-3 text-right font-medium text-primary">{{ formatCurrency(mat.pivot.subtotal) }}</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Evidências Fotográficas -->
                        <div v-if="(chamado.evidencias && chamado.evidencias.length > 0) || chamado.imagem_url">
                            <span class="text-[10px] text-muted-foreground font-bold uppercase tracking-widest mb-3 block flex items-center gap-2">
                                <Camera class="w-3 h-3"/> Evidências Visuais
                            </span>
                            <div class="grid grid-cols-2 sm:grid-cols-3 gap-4">
                                <!-- Foto Original Antiga -->
                                <div v-if="chamado.imagem_url" class="relative group aspect-square rounded-2xl overflow-hidden border border-border shadow-sm">
                                    <img :src="chamado.imagem_url" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110" />
                                    <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent flex items-end p-3">
                                        <span class="text-white text-xs font-bold">Relato Inicial</span>
                                    </div>
                                </div>
                                <!-- Novas Evidencias -->
                                <div v-for="ev in chamado.evidencias" :key="ev.id" class="relative group aspect-square rounded-2xl overflow-hidden border border-border shadow-sm">
                                    <img :src="ev.url" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110" />
                                    <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent flex items-end p-3">
                                        <span class="text-white text-xs font-bold capitalize">{{ ev.tipo }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Coluna da Direita (Ações) -->
                    <div class="space-y-6">
                        <div v-if="canUpdateStatus" class="bg-muted/30 border border-border rounded-2xl p-5 shadow-sm">
                            <h4 class="text-sm font-bold mb-4 flex items-center gap-2 text-foreground">
                                <RefreshCcw class="w-4 h-4 text-primary" />
                                Atualizar Status
                            </h4>
                            <form @submit.prevent="submitStatusUpdate" class="space-y-4">
                                <div>
                                    <label class="block text-[10px] font-bold text-muted-foreground uppercase tracking-widest mb-1.5">Novo Status</label>
                                    <select
                                        v-model="statusForm.status"
                                        class="w-full border border-input bg-background rounded-xl px-3 py-2.5 text-sm focus:ring-2 focus:ring-primary focus:border-transparent transition-all outline-none"
                                    >
                                        <option v-for="opt in statusOptions" :key="opt" :value="opt">
                                            {{ opt }}
                                        </option>
                                    </select>
                                </div>
                                <div>
                                    <label class="block text-[10px] font-bold text-muted-foreground uppercase tracking-widest mb-1.5">Observação (opcional)</label>
                                    <textarea
                                        v-model="statusForm.observacao"
                                        rows="2"
                                        placeholder="Adicione um comentário..."
                                        class="w-full border border-input bg-background rounded-xl px-3 py-2.5 text-sm focus:ring-2 focus:ring-primary focus:border-transparent transition-all outline-none resize-none"
                                    ></textarea>
                                </div>
                                <button
                                    type="submit"
                                    :disabled="!hasStatusChange || statusForm.processing"
                                    class="w-full px-4 py-2.5 bg-primary hover:bg-primary/90 text-primary-foreground disabled:opacity-50 font-semibold rounded-xl text-sm shadow-md transition-all active:scale-[0.98] flex items-center justify-center gap-2"
                                >
                                    {{ statusForm.processing ? 'Salvando...' : 'Atualizar' }}
                                    <Send class="w-4 h-4" />
                                </button>
                            </form>
                        </div>
                        <!-- Custo Mão de Obra -->
                        <div v-if="canEditCosts" class="bg-muted/30 border border-border rounded-2xl p-5 shadow-sm">
                            <h4 class="text-sm font-bold mb-4 flex items-center gap-2 text-foreground">
                                <Banknote class="w-4 h-4 text-primary" />
                                Custo Mão de Obra
                            </h4>
                            <div class="space-y-3">
                                <div class="relative">
                                    <span class="absolute left-3 top-1/2 -translate-y-1/2 text-sm font-bold text-muted-foreground">R$</span>
                                    <input
                                        type="number"
                                        step="0.01"
                                        min="0"
                                        v-model.number="laborForm.custo_mao_obra"
                                        class="w-full pl-10 pr-4 py-2.5 border border-input bg-background rounded-xl text-sm focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all"
                                        placeholder="0,00"
                                    />
                                </div>
                                <button
                                    @click="submitLaborCost"
                                    :disabled="laborForm.processing"
                                    class="w-full py-2.5 bg-primary hover:bg-primary/90 text-primary-foreground font-semibold rounded-xl text-sm transition-all active:scale-[0.98] disabled:opacity-50 flex items-center justify-center gap-2"
                                >
                                    <Send class="w-4 h-4" /> Salvar Custo
                                </button>
                            </div>
                        </div>
                        
                        <div v-else-if="canEditChamado && !canUpdateStatus" class="bg-muted border border-border rounded-2xl p-5">
                            <p class="text-xs text-muted-foreground font-medium text-center">
                                Status bloqueado (Chamado Concluído).
                            </p>
                        </div>

                        <div v-if="chamado.observacao" class="bg-amber-500/10 p-5 rounded-2xl border border-amber-500/20">
                            <span class="text-[10px] text-amber-600 dark:text-amber-400 font-bold uppercase tracking-widest mb-2 block">Nota Administrativa</span>
                            <p class="text-amber-800 dark:text-amber-200 text-sm leading-relaxed">
                                {{ chamado.observacao }}
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Timeline -->
            <div class="space-y-6 bg-card border border-border/50 rounded-3xl p-6 md:p-10 shadow-lg">
                <h3 class="font-black text-xl tracking-tight text-foreground">Linha do Tempo</h3>
                <div class="relative pt-4">
                    <div class="hidden lg:block absolute top-[130px] left-[10%] right-[10%] h-0.5 bg-muted -z-0"></div>

                    <div class="grid grid-cols-2 lg:grid-cols-5 gap-4 pt-4">
                        <div v-for="(step, index) in pipelineSteps" :key="step.key" class="relative pt-4">
                            <div class="absolute top-0 left-1/2 -translate-x-1/2 -translate-y-1/2 z-10 flex items-center justify-center bg-card rounded-full p-1 border border-background shadow-sm">
                                <CheckCircle2 v-if="getStepStatus(index) === 'completed'" class="text-emerald-500 w-6 h-6 fill-current text-white" />
                                <Clock v-else-if="getStepStatus(index) === 'current'" class="text-primary w-6 h-6 fill-primary text-white animate-pulse" />
                                <CheckCircle v-else class="text-muted w-6 h-6 fill-muted text-white" />
                            </div>

                            <div class="bg-background border border-border rounded-2xl p-4 shadow-sm h-full flex flex-col justify-between items-center text-center">
                                <div>
                                    <h4 class="font-bold text-sm text-foreground mb-1">{{ step.label }}</h4>
                                    <p class="text-[10px] text-muted-foreground leading-relaxed">{{ step.desc }}</p>
                                </div>
                                <div class="mt-3 flex items-center gap-1 text-[9px] text-muted-foreground font-medium">
                                    <Clock class="w-3 h-3" />
                                    <span>{{ getStepDate(index) }}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Histórico Detalhado -->
                <div v-if="(historico || chamado.historicos) && (historico.length > 0 || (chamado.historicos && chamado.historicos.length > 0))" class="mt-10 pt-8 border-t border-border">
                    <h4 class="text-sm font-bold mb-4 flex items-center gap-2">Histórico de Movimentações</h4>
                    <div class="space-y-4">
                        <div v-for="(item, idx) in (historico || chamado.historicos || [])" :key="idx" class="flex items-start gap-4 text-sm group">
                            <div class="w-2 h-2 rounded-full bg-primary mt-1.5 flex-shrink-0 group-hover:scale-150 transition-transform"></div>
                            <div class="flex-1 border-b border-border/50 pb-3">
                                <div class="flex justify-between items-start">
                                    <span class="font-medium text-foreground">Status alterado para <span class="text-primary">{{ item.status_novo }}</span></span>
                                    <span class="text-muted-foreground text-xs font-mono bg-muted px-2 py-0.5 rounded">{{ formatDateTime(item.data_alteracao) }}</span>
                                </div>
                                <p v-if="item.observacao" class="text-muted-foreground text-xs mt-1 italic">"{{ item.observacao }}"</p>
                                <p v-if="item.alterado_por" class="text-[10px] text-muted-foreground mt-1 uppercase tracking-wider font-semibold">Por: {{ item.alterado_por.name || 'Sistema' }}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>