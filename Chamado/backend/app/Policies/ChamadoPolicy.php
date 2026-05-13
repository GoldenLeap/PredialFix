<?php

namespace App\Policies;

use App\Models\Chamado;
use App\Models\User;

class ChamadoPolicy
{
    /**
     * Responsável pode ver qualquer chamado.
     * Solicitante só pode ver os seus próprios.
     * Admin vê tudo.
     */
    public function view(User $user, Chamado $chamado): bool
    {
        if ($user->cargo === 'admin' || $user->cargo === 'responsavel') {
            return true;
        }

        return $chamado->usuario_id === $user->id;
    }

    /**
     * Responsável pode editar qualquer chamado.
     * Solicitante pode editar apenas os seus próprios.
     * Admin pode editar tudo (mas não pode alterar de Admin/responsável para solicitante).
     */
    public function update(User $user, Chamado $chamado): bool
    {
        if ($user->cargo === 'admin' || $user->cargo === 'responsavel') {
            return true;
        }

        return $chamado->usuario_id === $user->id;
    }

    /**
     * Apenas responsável e admin podem excluir chamados.
     */
    public function delete(User $user, Chamado $chamado): bool
    {
        return in_array($user->cargo, ['admin', 'responsavel']);
    }
}
