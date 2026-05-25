<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\Chamado;
use App\Models\Material;
use App\Models\User;
use Inertia\Inertia;

class DashboardController extends Controller
{
    public function __invoke(Request $request)
    {
        $user = $request->user();

        if ($user->cargo === 'solicitante') {
            $recentChamados = Chamado::with('historicos')
                ->where('usuario_id', $user->id)
                ->whereIn('status', ['Aberto', 'Em Análise', 'Em Execução'])
                ->latest()
                ->take(5)
                ->get();

            return Inertia::render('HomeDocente', [
                'recentChamados' => $recentChamados,
            ]);
        }

        $stats = [
            'total' => Chamado::count(),
            'abertos' => Chamado::where('status', 'Aberto')->count(),
            'em_analise' => Chamado::where('status', 'Em Análise')->count(),
            'em_execucao' => Chamado::where('status', 'Em Execução')->count(),
            'concluidos' => Chamado::where('status', 'Concluído')->count(),
        ];

        $recentChamados = Chamado::with(['user', 'historicos'])->latest()->take(5)->get();

        $recentMaterials = Material::latest()->take(5)->get();

        $topUsers = User::withCount('chamados')
            ->orderByDesc('chamados_count')
            ->take(5)
            ->get();

        return Inertia::render('Dashboard', [
            'stats' => $stats,
            'recentChamados' => $recentChamados,
            'recentMaterials' => $recentMaterials,
            'topUsers' => $topUsers,
        ]);
    }
}
