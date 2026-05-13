<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

use App\Models\BudgetConfig;
use Carbon\Carbon;

class BudgetController extends Controller
{
    public function index(Request $request)
    {
        $now = Carbon::now();
        $month = $request->input('month', $now->month);
        $year = $request->input('year', $now->year);

        $config = BudgetConfig::where('month', $month)->where('year', $year)->first();

        if (!$config) {
            $config = BudgetConfig::create([
                'month' => $month,
                'year' => $year,
                'total_budget' => 50000,
                'allocations' => [
                    'Encanação' => 0.3,
                    'Manutenção geral' => 0.5,
                    'Pintura' => 0.2
                ]
            ]);
        }

        $history = BudgetConfig::orderBy('year', 'desc')->orderBy('month', 'desc')->take(6)->get();

        $months = [
            '01' => 'Janeiro', '02' => 'Fevereiro', '03' => 'Março',
            '04' => 'Abril', '05' => 'Maio', '06' => 'Junho',
            '07' => 'Julho', '08' => 'Agosto', '09' => 'Setembro',
            '10' => 'Outubro', '11' => 'Novembro', '12' => 'Dezembro',
        ];

        $years = range($now->year - 2, $now->year + 1);

        return Inertia::render('Orcamento', [
            'config' => $config,
            'history' => $history,
            'months' => $months,
            'years' => $years,
        ]);
    }

    public function update(Request $request)
    {
        $validated = $request->validate([
            'month' => 'required|integer|min:1|max:12',
            'year' => 'required|integer|min:2024|max:2030',
            'total_budget' => 'required|numeric|min:0',
            'alert_enabled' => 'sometimes|boolean',
        ]);

        $config = BudgetConfig::updateOrCreate(
            ['month' => $validated['month'], 'year' => $validated['year']],
            ['total_budget' => $validated['total_budget']]
        );

        return redirect()->route('orcamento.index', ['month' => $validated['month'], 'year' => $validated['year']])
            ->with('success', 'Orçamento atualizado com sucesso.');
    }
}
