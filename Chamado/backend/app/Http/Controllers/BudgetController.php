<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

use App\Models\BudgetConfig;
use App\Models\Orcamento;
use Carbon\Carbon;

class BudgetController extends Controller
{
    public function index(Request $request)
    {
        $now = Carbon::now();
        $month = $request->input('month', $now->month);
        $year = $request->input('year', $now->year);

        $config = BudgetConfig::where('month', $month)->where('year', $year)->first();
        
        // If not found, create a default one for demonstration
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

        return Inertia::render('Orcamento', [
            'config' => $config,
            'history' => $history
        ]);
    }
}
