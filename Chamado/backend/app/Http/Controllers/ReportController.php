<?php

namespace App\Http\Controllers;

use App\Models\Chamado;
use App\Models\HistoricoChamado;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ReportController extends Controller
{
    public function index(Request $request)
    {
        $query = Chamado::with(['user', 'historicos', 'orcamentos']);

        // Filtros opcionais
        if ($request->has('status') && $request->status) {
            $query->where('status', $request->status);
        }
        if ($request->has('tipo') && $request->tipo) {
            $query->where('tipo', $request->tipo);
        }
        if ($request->has('data_inicio') && $request->data_inicio) {
            $query->whereDate('created_at', '>=', $request->data_inicio);
        }
        if ($request->has('data_fim') && $request->data_fim) {
            $query->whereDate('created_at', '<=', $request->data_fim);
        }

        $reports = $query->latest()->paginate(10);

        // Estatísticas para o relatório
        $stats = [
            'total' => Chamado::count(),
            'abertos' => Chamado::where('status', 'Aberto')->count(),
            'em_analise' => Chamado::where('status', 'Em Análise')->count(),
            'em_execucao' => Chamado::where('status', 'Em Execução')->count(),
            'concluidos' => Chamado::where('status', 'Concluído')->count(),
        ];

        $chamadosByTipo = Chamado::selectRaw('tipo, count(*) as total')
            ->groupBy('tipo')
            ->orderByDesc('total')
            ->get();

        $chamadosByMonth = Chamado::selectRaw('MONTH(created_at) as month, YEAR(created_at) as year, count(*) as total')
            ->groupBy('year', 'month')
            ->orderByDesc('year')
            ->orderByDesc('month')
            ->take(6)
            ->get();

        return Inertia::render('Relatorios', [
            'reports' => $reports,
            'stats' => $stats,
            'chamadosByTipo' => $chamadosByTipo,
            'chamadosByMonth' => $chamadosByMonth,
        ]);
    }

    public function exportPdf()
    {
        $chamados = Chamado::with(['user', 'historicos'])->latest()->get();

        return Inertia::location(route('reports.index', ['download' => 1]));
    }
}
