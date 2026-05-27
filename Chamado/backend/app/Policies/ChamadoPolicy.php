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
      * Admin pode editar tudo.
      * Solicitante NÃO pode editar chamados já criados.
      */
    public function update(User $user, Chamado $chamado): bool
    {
        return in_array($user->cargo, ['admin', 'responsavel']);
    }

    /**
     * Apenas responsável e admin podem excluir chamados.
     */
    public function delete(User $user, Chamado $chamado): bool
    {
        return in_array($user->cargo, ['admin', 'responsavel']);
    }
}
