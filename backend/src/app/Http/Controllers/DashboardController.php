<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\Chamado;
use App\Models\User;
use Inertia\Inertia;

class DashboardController extends Controller
{
    public function __invoke(Request $request)
    {
        $stats = [
            'total' => Chamado::count(),
            'abertos' => Chamado::where('status', 'Aberto')->count(),
            'em_analise' => Chamado::where('status', 'Em Análise')->count(),
            'em_execucao' => Chamado::where('status', 'Em Execução')->count(),
            'concluidos' => Chamado::where('status', 'Concluído')->count(),
        ];

        $recentChamados = Chamado::with('user')->latest()->take(5)->get();

        return Inertia::render('Dashboard', [
            'stats' => $stats,
            'recentChamados' => $recentChamados,
        ]);
    }
}
