<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

/**
 * Regra de validação que garante que a transição de status do chamado segue
 * o workflow definido:
 *
 *  Aberto → Em Análise
 *  Em Análise → Em Execução | Aguardando Material
 *  Aguardando Material → Em Execução
 *  Em Execução → Concluído | Aguardando Material
 *  Concluído → Aberto (reabrir)
 */
class ValidStatusTransition implements ValidationRule
{
    /** Mapa de transições permitidas. */
    private const TRANSICOES = [
        'Aberto' => ['Em Análise'],
        'Em Análise' => ['Em Execução', 'Aguardando Material'],
        'Aguardando Material' => ['Em Execução'],
        'Em Execução' => ['Concluído', 'Aguardando Material'],
        'Concluído' => ['Aberto'],
    ];

    protected string $statusAtual;

    public function __construct(string $statusAtual)
    {
        $this->statusAtual = $statusAtual;
    }

    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        // Se o status não mudou, não precisa validar transição
        if ($value === $this->statusAtual) {
            return;
        }

        $permitidos = self::TRANSICOES[$this->statusAtual] ?? [];

        if (!in_array($value, $permitidos)) {
            $listaPermitidos = implode(', ', $permitidos);
            $fail("Transição de status inválida: \"{$this->statusAtual}\" → \"{$value}\". "
                . "Transições permitidas a partir de \"{$this->statusAtual}\": {$listaPermitidos}.");
        }
    }

    /**
     * Retorna as transições permitidas para um dado status.
     */
    public static function transicoesPermitidas(string $status): array
    {
        return self::TRANSICOES[$status] ?? [];
    }
}
