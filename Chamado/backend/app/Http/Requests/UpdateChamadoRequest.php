<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class UpdateChamadoRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'tipo' => 'sometimes|required|in:Elétrica,Hidráulica,Infraestrutura,Outros',
            'local' => 'sometimes|required|string|max:255',
            'descricao' => 'sometimes|required|string',
            'prioridade' => 'sometimes|required|in:Baixa,Média,Alta',
            'status' => 'sometimes|required|in:Aberto,Em Análise,Em Execução,Concluído',
            'assunto' => 'sometimes|required|string|max:255',
            'tipo_servico' => 'sometimes|required|in:Interno,Externo',
            'observacao' => 'nullable|string|max:1000',
        ];
    }
}
