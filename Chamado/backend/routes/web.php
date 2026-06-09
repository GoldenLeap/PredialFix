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
    Route::post('/chamados/{chamado}/materiais', [App\Http\Controllers\ChamadoController::class, 'addMaterial'])->name('chamados.materiais.add');
    Route::delete('/chamados/{chamado}/materiais/{material}', [App\Http\Controllers\ChamadoController::class, 'removeMaterial'])->name('chamados.materiais.remove');

    Route::get('/orcamento', [App\Http\Controllers\BudgetController::class, 'index'])->name('orcamento.index');
    Route::post('/orcamento', [App\Http\Controllers\BudgetController::class, 'update'])->name('orcamento.update');

    Route::get('/materiais',                [App\Http\Controllers\MaterialController::class, 'index'])->name('materiais.index');
    Route::get('/materiais/create',          [App\Http\Controllers\MaterialController::class, 'create'])->name('materiais.create');
    Route::post('/materiais',                [App\Http\Controllers\MaterialController::class, 'store'])->name('materiais.store');
    Route::get('/materiais/{material}/edit', [App\Http\Controllers\MaterialController::class, 'edit'])->name('materiais.edit');
    Route::put('/materiais/{material}',      [App\Http\Controllers\MaterialController::class, 'update'])->name('materiais.update');
    Route::delete('/materiais/{material}',   [App\Http\Controllers\MaterialController::class, 'destroy'])->name('materiais.destroy');

    Route::get('/relatorios', [App\Http\Controllers\ReportController::class, 'index'])->name('relatorios.index');
    Route::get('/relatorios/pdf', [App\Http\Controllers\ReportController::class, 'exportPdf'])->name('relatorios.pdf');

    Route::post('/notifications/{id}/read', [App\Http\Controllers\NotificationController::class, 'markAsRead'])->name('notifications.read');
    Route::post('/notifications/read-all', [App\Http\Controllers\NotificationController::class, 'markAllAsRead'])->name('notifications.readAll');
});

require __DIR__.'/settings.php';
