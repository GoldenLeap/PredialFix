<script setup lang="ts">
import { Head, Link, useForm } from '@inertiajs/vue3';
import { Mail, ArrowLeft, Loader2 } from 'lucide-vue-next';
import logoSenai from '../../../images/logo senai.png';
defineProps<{
    status?: string;
}>();

const form = useForm({
    email: '',
});

const submit = () => {
    form.post('/forgot-password');
};
</script>

<template>
    <Head title="Recuperar Senha" />

    <div class="min-h-screen bg-[#FF0000] flex flex-col items-center justify-center p-6 font-sans">
        
        <!-- Mensagem de Sucesso -->
        <div v-if="status" class="mb-6 max-w-md w-full font-bold text-sm text-green-100 bg-green-600/90 border border-green-500 p-4 rounded-2xl shadow-lg text-center animate-in fade-in slide-in-from-top-4">
            {{ status }}
        </div>

        <!-- Card Branco Central -->
        <div class="bg-white w-full max-w-xl rounded-[3rem] p-10 md:p-14 shadow-2xl relative">
            
            <!-- Botão Voltar -->
            <Link href="/login" class="absolute top-8 left-8 text-gray-400 hover:text-[#FF0000] transition-colors p-2 rounded-full hover:bg-gray-50">
                <ArrowLeft class="w-6 h-6" />
            </Link>

            <!-- Logo e Título -->
            <div class="flex flex-col items-center justify-center gap-4 mb-10 mt-4">
                <div class="bg-[#FF0000] px-6 py-2 mb-2">
                    <img :src="logoSenai" alt="" srcset="">
                </div>
                
                <h1 class="text-2xl font-black text-[#FC0000] tracking-tight">Recuperar Senha</h1>
                <p class="text-center text-sm text-gray-500 font-medium px-4 leading-relaxed">
                    Esqueceu sua senha? Sem problemas. Informe seu e-mail institucional e enviaremos um link de redefinição.
                </p>
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

                <!-- Botão Enviar -->
                <button 
                    type="submit" 
                    :disabled="form.processing"
                    class="w-full bg-[#FC0000] hover:bg-red-700 hover:cursor-pointer text-white font-black py-6 rounded-2xl shadow-xl shadow-blue-900/20 transition-all active:scale-[0.98] flex items-center justify-center gap-3 uppercase tracking-widest disabled:opacity-50"
                >
                    <Loader2 v-if="form.processing" class="w-5 h-5 animate-spin" />
                    <span>{{ form.processing ? 'Enviando...' : 'Enviar Link de Recuperação' }}</span>
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
