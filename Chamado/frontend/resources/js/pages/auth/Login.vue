<script setup lang="ts">
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';
import { Mail, Lock, Eye, EyeOff, Loader2 } from 'lucide-vue-next';

import logoPredial from '../../../../resources/images/logo.png';
import logoSenai from '@/../../resources/images/logo senai.png';

defineProps<{
    status?: string;
}>();

const form = useForm({
    email: '',
    password: '',
    remember: false,
});

const showPassword = ref(false);

const submit = () => {
    form.post('/login', {
        onFinish: () => {
            form.reset('password');
        },
    });
};
</script>

<template>
    <Head title="Acesso ao Sistema" />

    <div class="min-h-screen bg-[#FF0000] flex flex-col items-center justify-center p-6 font-sans">
        
        <!-- Mensagem de Status (se houver) -->
        <div v-if="status" class="mb-4 font-bold text-sm text-white bg-black/20 px-6 py-2 rounded-full">
            {{ status }}
        </div>

        <!-- Card Branco Central -->
        <div class="bg-white w-full max-w-2xl rounded-[3rem] p-10 md:p-16 shadow-2xl relative">
            
            <!-- Logos -->
            <div class="flex flex-col items-center justify-center gap-6 mb-12">
                <!-- SENAI Logo -->
                <div class="bg-[#FF0000] px-6 py-2">
                   <img :src="logoSenai" alt="">
                </div>
                
                <!-- PredialFix Logo -->
                <div class="flex flex-col items-center">
                    <div class="flex items-center justify-center w-64 h-64 mb-2">
                        <img :src="logoPredial" alt="PredialFix Logo" class="w-full h-full object-contain">
                    </div>
                </div>
            </div>

            <form @submit.prevent="submit" class="space-y-8">
                <!-- E-mail -->
                <div>
                    <label class="block text-xs font-black text-gray-400 uppercase tracking-[0.2em] mb-3 ml-2">E-mail Institucional</label>
                    <div class="relative group">
                        <Mail class="absolute left-6 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-300 group-focus-within:text-[#FF0000] transition-colors" />
                        <input 
                            type="email" 
                            v-model="form.email"
                            required
                            autofocus
                            placeholder="seu.nome@senai.br"
                            class="w-full bg-gray-50 border-2 border-gray-100 rounded-2xl pl-16 pr-6 py-5 text-gray-900 font-bold focus:outline-none focus:border-[#FF0000] focus:ring-0 transition-all placeholder:text-gray-300"
                        />
                    </div>
                    <p v-if="form.errors.email" class="mt-2 text-red-600 text-xs font-bold ml-2">{{ form.errors.email }}</p>
                </div>

                <!-- Senha -->
                <div>
                    <div class="flex justify-between items-center mb-3 px-2">
                        <label class="text-xs font-black text-gray-400 uppercase tracking-[0.2em]">Senha</label>
                        <Link href="/forgot-password" class="text-[10px] font-black text-gray-300 hover:text-[#FF0000] uppercase tracking-widest transition-colors">Esqueceu a senha?</Link>
                    </div>
                    <div class="relative group">
                        <Lock class="absolute left-6 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-300 group-focus-within:text-[#FF0000] transition-colors" />
                        <input 
                            :type="showPassword ? 'text' : 'password'" 
                            v-model="form.password"
                            required
                            placeholder="••••••••"
                            class="w-full bg-gray-50 border-2 border-gray-100 rounded-2xl pl-16 pr-14 py-5 text-gray-900 font-bold focus:outline-none focus:border-[#FF0000] focus:ring-0 transition-all placeholder:text-gray-300"
                        />
                        <button 
                            type="button" 
                            @click="showPassword = !showPassword"
                            class="absolute right-6 top-1/2 -translate-y-1/2 text-gray-300 hover:text-[#FF0000] transition-colors"
                        >
                            <Eye v-if="!showPassword" class="w-5 h-5" />
                            <EyeOff v-else class="w-5 h-5" />
                        </button>
                    </div>
                    <p v-if="form.errors.password" class="mt-2 text-red-600 text-xs font-bold ml-2">{{ form.errors.password }}</p>
                </div>

                <!-- Botão de Entrar -->
                <button 
                    type="submit" 
                    :disabled="form.processing"
                    class="w-full bg-[#FF0000] hover:bg-red-700 text-white font-black py-6 rounded-2xl shadow-xl shadow-red-200 transition-all active:scale-[0.98] flex items-center justify-center gap-3 uppercase tracking-widest disabled:opacity-50"
                >
                    <Loader2 v-if="form.processing" class="w-5 h-5 animate-spin" />
                    <span>{{ form.processing ? 'Verificando...' : 'Entrar no Sistema' }}</span>
                </button>
            </form>
        </div>

        <!-- Rodapé -->
        <p class="mt-10 text-white/50 text-[10px] font-bold uppercase tracking-[0.3em]">
            © 2026 SENAI - PredialFix
        </p>
    </div>
</template>

<style scoped>
input:-webkit-autofill {
    -webkit-box-shadow: 0 0 0 1000px #f9fafb inset !important;
}
</style>
