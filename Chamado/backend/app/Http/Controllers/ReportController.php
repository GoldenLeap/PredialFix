<?php

namespace App\Http\Controllers;

use App\Models\Chamado;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ReportController extends Controller
{
    public function index()
    {
        $reports = Chamado::with(['user', 'orcamentos'])->latest()->paginate(10);
        
        return Inertia::render('Relatorios', [
            'reports' => $reports
        ]);
    }
}
