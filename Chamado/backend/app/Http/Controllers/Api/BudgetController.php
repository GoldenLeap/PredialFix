<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\BudgetConfig;
use App\Models\Chamado;
use Illuminate\Http\Request;
use Carbon\Carbon;

class BudgetController extends Controller
{
    /**
     * Retorna o orçamento do mês com histórico dos últimos 6 meses.
     * GET /api/orcamento?mes=3&ano=2026
     */
    public function index(Request $request)
    {
        $mes = $request->input('mes', Carbon::now()->month);
        $ano = $request->input('ano', Carbon::now()->year);

        $config = BudgetConfig::where('month', $mes)->where('year', $ano)->first();

        $totalGasto = (float) Chamado::whereMonth('created_at', $mes)
                    ->whereYear('created_at', $ano)
                    ->sum(\DB::raw('COALESCE(custo_mao_obra, 0) + COALESCE(custo_materiais, 0)'));     

        // Histórico dos últimos 6 meses
        $historico = [];
        for ($i = 5; $i >= 0; $i--) {
            $data = Carbon::createFromDate($ano, $mes, 1)->subMonths($i);
            $m = $data->month;
            $a = $data->year;

            $cfg = BudgetConfig::where('month', $m)->where('year', $a)->first();
            $gasto = (float) Chamado::whereMonth('created_at', $m)
                ->whereYear('created_at', $a)
                ->sum(\DB::raw('COALESCE(custo_mao_obra, 0) + COALESCE(custo_materiais, 0)'));

            $orcamentoInicial = $cfg ? $cfg->total_budget : 0;
            $variancia = $orcamentoInicial - $gasto;
            $mesesPt = [
                1 => 'Janeiro', 2 => 'Fevereiro', 3 => 'Março', 4 => 'Abril',
                5 => 'Maio', 6 => 'Junho', 7 => 'Julho', 8 => 'Agosto',
                9 => 'Setembro', 10 => 'Outubro', 11 => 'Novembro', 12 => 'Dezembro'
            ];
            $nomeMesFormatado = $mesesPt[$m] . ' ' . $a;
            $historico[] = [
                'mes'               => $nomeMesFormatado,
                'orcamento_inicial' => $orcamentoInicial,
                'total_gasto'       => $gasto,
                'variancia'         => $variancia,
                'status'            => $variancia >= 0 ? 'Econômico' : 'Acima',
            ];
        }

        return response()->json([
            'config'       => $config,
            'total_gasto'  =>  $totalGasto,
            'orcamento_restante' => $config ? ($config->total_budget - $totalGasto) : 0,
            'historico'    => $historico,
        ]);
    }

    /**
     * Cria ou atualiza o orçamento e alocações de um mês.
     * POST /api/orcamento
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'month'         => 'required|integer|between:1,12',
            'year'          => 'required|integer|min:2000',
            'total_budget'  => 'required|numeric|min:0',
            'allocations'   => 'nullable|array',
            'alert_enabled' => 'boolean',
        ]);

        $config = BudgetConfig::updateOrCreate(
            ['month' => $validated['month'], 'year' => $validated['year']],
            $validated
        );

        return response()->json([
            'message' => 'Orçamento salvo com sucesso!',
            'data'    => $config,
        ], 201);
    }
}
