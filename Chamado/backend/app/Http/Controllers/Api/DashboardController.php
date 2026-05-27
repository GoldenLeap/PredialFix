<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Chamado;
use App\Models\BudgetConfig;
use App\Models\HistoricoChamado;
use Illuminate\Http\Request;
use Carbon\Carbon;

class DashboardController extends Controller
{
    /**
     * Retorna os dados consolidados para o painel do responsável.
     * GET /api/dashboard
     */
    public function index(Request $request)
    {
        $mes = $request->input('mes', Carbon::now()->month);
        $ano = $request->input('ano', Carbon::now()->year);

        // --- Visão geral financeira ---
        $budgetConfig = BudgetConfig::where('month', $mes)->where('year', $ano)->first();
        $orcamentoTotal = $budgetConfig ? $budgetConfig->total_budget : 0;

        $chamadosDoMes = Chamado::whereMonth('created_at', $mes)
            ->whereYear('created_at', $ano)
            ->get();

        $totalGasto = $chamadosDoMes->sum(fn($c) => ($c->custo_mao_obra ?? 0) + ($c->custo_materiais ?? 0));
        $orcamentoRestante = $orcamentoTotal - $totalGasto;

        // --- Contagem de chamados ---
        $totalChamados = Chamado::count();
        $chamadosAbertos    = Chamado::where('status', 'Aberto')->count();
        $emAndamento        = Chamado::whereIn('status', ['Em Análise', 'Em Execução'])->count();
        $aguardandoMaterial = Chamado::where('status', 'Aguardando Material')->count();
        $finalizados        = Chamado::where('status', 'Concluído')->count();

        // --- Gastos por categoria (tipo) no mês ---
        $gastosPorCategoria = Chamado::whereMonth('created_at', $mes)
            ->whereYear('created_at', $ano)
            ->selectRaw('tipo, SUM(COALESCE(custo_mao_obra, 0) + COALESCE(custo_materiais, 0)) as total_gasto')
            ->groupBy('tipo')
            ->get()
            ->pluck('total_gasto', 'tipo');

        // --- Atividades recentes (últimos 10 históricos) ---
        $atividadesRecentes = HistoricoChamado::with('chamado:id,assunto,tipo', 'alteradoPor:id,name')
            ->latest('data_alteracao')
            ->take(10)
            ->get()
            ->map(function ($h) {
                return [
                    'chamado_id'   => $h->chamado_id,
                    'assunto'      => $h->chamado->assunto ?? 'N/A',
                    'tipo'         => $h->chamado->tipo ?? 'N/A',
                    'status_novo'  => $h->status_novo,
                    'alterado_por' => $h->alteradoPor->name ?? 'Sistema',
                    'data'         => $h->data_alteracao,
                    'descricao'    => "Chamado #{$h->chamado_id} atualizado para \"{$h->status_novo}\"",
                ];
            });

        return response()->json([
            'financeiro' => [
                'orcamento_total'    => $orcamentoTotal,
                'total_gasto'        => $totalGasto,
                'orcamento_restante' => $orcamentoRestante,
                'percentual_uso'     => $orcamentoTotal > 0 ? round(($totalGasto / $orcamentoTotal) * 100, 1) : 0,
            ],
            'chamados' => [
                'total'              => $totalChamados,
                'abertos'            => $chamadosAbertos,
                'em_andamento'       => $emAndamento,
                'aguardando_material'=> $aguardandoMaterial,
                'finalizados'        => $finalizados,
            ],
            'gastos_por_categoria' => $gastosPorCategoria,
            'atividades_recentes'  => $atividadesRecentes,
        ]);
    }
}
