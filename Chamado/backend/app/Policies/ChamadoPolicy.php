<?php

namespace App\Policies;

use App\Models\Chamado;
use App\Models\User;

class ChamadoPolicy
{
    
    // Responsável pode ver qualquer chamado.
    // Solicitante só pode ver os seus próprios.
    public function view(User $user, Chamado $chamado): bool
    {
        if ($user->cargo === 'responsavel') {
            return true;
        }

        return $chamado->usuario_id === $user->id;
    }

    
     // Responsável pode editar qualquer chamado.
     // Solicitante pode editar apenas os seus próprios.
    public function update(User $user, Chamado $chamado): bool
    {
        if ($user->cargo === 'responsavel') {
            return true;
        }

        return $chamado->usuario_id === $user->id;
    }

    /**
     * Apenas responsável pode excluir chamados.
     */
    public function delete(User $user, Chamado $chamado): bool
    {
        return $user->cargo === 'responsavel';
    }
}
