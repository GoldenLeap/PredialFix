<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckRole
{
    /**
     * Verifica se o usuário autenticado possui um dos cargos permitidos.
     *
     * Uso na rota: middleware('role:responsavel,admin')
     */
    public function handle(Request $request, Closure $next, string ...$roles): Response
    {
        $user = $request->user();

        if (!$user || !in_array($user->cargo, $roles)) {
            return response()->json([
                'message' => 'Acesso restrito. Permissão insuficiente.',
            ], 403);
        }

        return $next($request);
    }
}
