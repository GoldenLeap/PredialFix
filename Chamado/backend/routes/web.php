<?php

use Illuminate\Support\Facades\Route;
use Laravel\Fortify\Features;
use Inertia\Inertia;
use App\Http\Controllers\DashboardController;

// Redireciona a raiz para o login
Route::get('/', function () {
    return redirect()->route('login');
});

Route::get('/dashboard', DashboardController::class)->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware(['auth', 'verified'])->group(function () {
    Route::resource('chamados', App\Http\Controllers\ChamadoController::class);

    Route::get('/orcamento', [App\Http\Controllers\BudgetController::class, 'index'])->name('orcamento.index');
    Route::post('/orcamento', [App\Http\Controllers\BudgetController::class, 'update'])->name('orcamento.update');

    Route::get('/materiais', [App\Http\Controllers\MaterialController::class, 'index'])->name('materiais.index');
    Route::get('/materiais/criar', function () {
        return Inertia::render('Materiais/Create');
    })->name('materiais.create');

    Route::get('/relatorios', [App\Http\Controllers\ReportController::class, 'index'])->name('relatorios.index');
    Route::get('/relatorios/pdf', [App\Http\Controllers\ReportController::class, 'exportPdf'])->name('relatorios.pdf');
});

require __DIR__.'/settings.php';
