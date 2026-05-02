<script setup lang="ts">
import { Head, useForm, Link } from '@inertiajs/vue3';
import { Search, UploadCloud, ChevronLeft } from 'lucide-vue-next';
import { ref } from 'vue';

const form = useForm({
    tipo: '',
    local: '',
    assunto: '',
    descricao: '',
    prioridade: 'Baixa',
    tipo_servico: 'Interno',
    imagem: null as File | null,
});

const previewUrl = ref<string | null>(null);

const handleFileUpload = (event: Event) => {
    const target = event.target as HTMLInputElement;
    if (target.files && target.files.length > 0) {
        form.imagem = target.files[0];
        previewUrl.value = URL.createObjectURL(target.files[0]);
    }
};

const submit = () => {
    form.post('/chamados', {
        onSuccess: () => form.reset(),
    });
};
</script>

<template>
    <Head title="Novo Chamado" />

    <div class="min-h-screen bg-[#FF0000] text-black font-sans pb-10">
        
        <!-- Top Nav  -->
        <nav class="px-8 py-6 flex items-center justify-between">
            <Link href="/dashboard" class="flex items-center gap-2 text-white/80 hover:text-white transition-all font-bold text-sm">
                <ChevronLeft class="w-5 h-5" />
                Voltar
            </Link>
        </nav>

        <div class="max-w-3xl mx-auto w-full px-4">
            
            <h1 class="text-3xl font-bold text-white mb-6 text-center tracking-tight">Abrir novo chamado</h1>

            <form @submit.prevent="submit" class="bg-white rounded-2xl p-6 md:p-10 shadow-2xl space-y-6">
                
                <!-- Categoria -->
                <div>
                    <label class="block text-sm font-bold text-black mb-2">Categoria do problema <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <Search class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                        <select 
                            v-model="form.tipo" 
                            class="w-full bg-white border border-gray-300 rounded-xl pl-12 pr-10 py-3 text-sm text-gray-600 focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all appearance-none outline-none"
                            required
                        >
                            <option value="" disabled selected>Categoria...</option>
                            <option value="Elétrica">Elétrica</option>
                            <option value="Hidráulica">Hidráulica</option>
                            <option value="Infraestrutura">Infraestrutura</option>
                            <option value="Outros">Outros</option>
                        </select>
                        <div class="absolute right-4 top-1/2 -translate-y-1/2 pointer-events-none">
                            <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
                        </div>
                    </div>
                    <div v-if="form.errors.tipo" class="text-red-500 text-xs font-bold mt-1">{{ form.errors.tipo }}</div>
                </div>

                <!-- Localização -->
                <div>
                    <label class="block text-sm font-bold text-black mb-2">Localização <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <select 
                            v-model="form.local" 
                            class="w-full bg-white border border-gray-300 rounded-xl px-4 py-3 text-sm text-gray-600 focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all appearance-none outline-none"
                            required
                        >
                            <option value="" disabled selected>Selecione um lugar</option>
                            <option value="Sala 101">Sala 101</option>
                            <option value="Sala 102">Sala 102</option>
                            <option value="Laboratório 1">Laboratório 1</option>
                            <option value="Banheiro Principal">Banheiro Principal</option>
                            <option value="Outro">Outro (especificar na descrição)</option>
                        </select>
                        <div class="absolute right-4 top-1/2 -translate-y-1/2 pointer-events-none">
                            <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
                        </div>
                    </div>
                    <div v-if="form.errors.local" class="text-red-500 text-xs font-bold mt-1">{{ form.errors.local }}</div>
                </div>

                <!-- Assunto -->
                <div>
                    <label class="block text-sm font-bold text-black mb-2">Assunto <span class="text-red-500">*</span></label>
                    <input 
                        type="text" 
                        v-model="form.assunto" 
                        class="w-full bg-white border border-gray-300 rounded-xl px-4 py-3 text-sm text-gray-600 placeholder:text-gray-400 focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all outline-none"
                        placeholder="Um resumo breve do problema"
                        required
                    />
                    <div v-if="form.errors.assunto" class="text-red-500 text-xs font-bold mt-1">{{ form.errors.assunto }}</div>
                </div>

                <!-- Descrição -->
                <div>
                    <label class="block text-sm font-bold text-black mb-2">Descrição <span class="text-red-500">*</span></label>
                    <textarea 
                        v-model="form.descricao" 
                        rows="5"
                        class="w-full bg-white border border-gray-300 rounded-xl px-4 py-3 text-sm text-gray-600 placeholder:text-gray-400 focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all outline-none resize-none"
                        placeholder="Uma descrição detalhada do problema..."
                        required
                    ></textarea>
                    <div v-if="form.errors.descricao" class="text-red-500 text-xs font-bold mt-1">{{ form.errors.descricao }}</div>
                </div>

                <!-- Prioridade -->
                <div>
                    <label class="block text-sm font-bold text-black mb-2">Prioridade <span class="text-red-500">*</span></label>
                    <div class="grid grid-cols-3 gap-4">
                        <label v-for="p in ['Baixa', 'Média', 'Alta']" :key="p" class="cursor-pointer">
                            <input 
                                type="radio" 
                                v-model="form.prioridade" 
                                :value="p" 
                                class="sr-only peer"
                            />
                            <div class="px-4 py-2.5 text-center rounded-xl border border-gray-300 bg-white transition-all peer-checked:bg-[#B3D4FF] peer-checked:border-[#007BFF] peer-checked:text-[#007BFF]">
                                <span class="text-sm font-normal">{{ p }}</span>
                            </div>
                        </label>
                    </div>
                </div>

                <!-- Tipo de Serviço -->
                <div>
                    <label class="block text-sm font-bold text-black mb-2">Tipo de serviço <span class="text-red-500">*</span></label>
                    <div class="flex gap-4">
                        <label v-for="t in ['Interno', 'Externo']" :key="t" class="cursor-pointer w-40">
                            <input 
                                type="radio" 
                                v-model="form.tipo_servico" 
                                :value="t" 
                                class="sr-only peer"
                            />
                            <div class="px-4 py-2.5 text-center rounded-xl border border-gray-300 bg-white transition-all peer-checked:bg-[#B3D4FF] peer-checked:border-[#007BFF] peer-checked:text-[#007BFF]">
                                <span class="text-sm font-normal">{{ t }}</span>
                            </div>
                        </label>
                    </div>
                </div>

                <!-- Imagem do problema -->
                <div>
                    <label class="block text-sm font-bold text-black mb-2">Imagem do problema:</label>
                    <div class="border-2 border-dashed border-gray-200 rounded-xl p-8 flex flex-col items-center justify-center text-center cursor-pointer hover:bg-gray-50 transition-colors relative" @click="$refs.fileInput.click()">
                        <input 
                            type="file" 
                            ref="fileInput"
                            class="hidden" 
                            accept="image/png, image/jpeg, image/jpg"
                            @change="handleFileUpload"
                        >
                        
                        <div v-if="!previewUrl" class="flex flex-col items-center">
                            <UploadCloud class="w-8 h-8 text-gray-400 mb-2" />
                            <p class="text-sm font-bold text-[#007BFF]">Clique para enviar <span class="text-gray-500 font-normal">a imagem</span></p>
                            <p class="text-[10px] font-bold text-gray-400 mt-1 uppercase tracking-wider">PNG, JPG até 10MB</p>
                        </div>

                        <div v-else class="flex flex-col items-center relative w-full h-32">
                            <img :src="previewUrl" alt="Preview" class="object-contain h-full w-full rounded-lg" />
                            <div class="absolute inset-0 bg-black/40 flex items-center justify-center opacity-0 hover:opacity-100 transition-opacity rounded-lg">
                                <span class="text-white font-bold text-sm">Trocar imagem</span>
                            </div>
                        </div>
                    </div>
                    <div v-if="form.errors.imagem" class="text-red-500 text-xs font-bold mt-1">{{ form.errors.imagem }}</div>
                </div>

                <!-- Botões de Ação -->
                <div class="pt-4 flex items-center justify-between">
                    <Link 
                        href="/dashboard" 
                        class="px-10 py-3 bg-white border border-gray-300 text-black font-bold text-sm rounded-xl hover:bg-gray-50 transition-colors"
                    >
                        Cancelar
                    </Link>
                    <button 
                        type="submit" 
                        :disabled="form.processing"
                        class="px-10 py-3 bg-[#007BFF] hover:bg-blue-700 disabled:opacity-50 text-white font-bold text-sm rounded-xl transition-all shadow-md active:scale-95"
                    >
                        {{ form.processing ? 'Enviando...' : 'Enviar Chamado' }}
                    </button>
                </div>
            </form>
        </div>
    </div>
</template>

<style scoped>
/* Reset autofill e estilos base */
input, textarea, select {
    font-family: inherit;
}
</style>
