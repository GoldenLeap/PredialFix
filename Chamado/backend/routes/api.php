<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ChamadoController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\MaterialController;
use App\Http\Controllers\Api\BudgetController;
use App\Http\Controllers\Api\ReportController;

/*
|--------------------------------------------------------------------------
| API Routes — PredialFix
|--------------------------------------------------------------------------
*/

// ── Rota pública: login ──────────────────────────────────────────────────
Route::post('/login', [AuthController::class, 'login']);

// ── Rotas autenticadas (qualquer usuário logado) ─────────────────────────
Route::middleware('auth:sanctum')->group(function () {

    // Dados do usuário autenticado e logout
    Route::get('/user', fn(Request $request) => $request->user());
    Route::post('/logout', [AuthController::class, 'logout']);

    // ── Chamados ─────────────────────────────────────────────────────────
    // Listar chamados (responsável vê todos; usuário vê os próprios)
    Route::get('/chamados', [ChamadoController::class, 'index']);

    // Histórico da Unidade — deve vir ANTES de /chamados/{id}
    Route::get('/chamados/historico-unidade', [ChamadoController::class, 'historicoUnidade']);

    // Ver detalhe de um chamado específico
    Route::get('/chamados/{id}', [ChamadoController::class, 'show']);

    // Abrir novo chamado (qualquer usuário autenticado)
    Route::post('/chamados', [ChamadoController::class, 'store']);

    // ── Rotas exclusivas para Responsável / Admin ─────────────────────────
    Route::middleware('role:responsavel,admin')->group(function () {

        // Atualizar status, técnico e custos de um chamado
        Route::put('/chamados/{id}', [ChamadoController::class, 'update']);

        // Dashboard — visão geral financeira e de chamados
        Route::get('/dashboard', [DashboardController::class, 'index']);

        // Gestão de Materiais
        Route::get('/materiais',        [MaterialController::class, 'index']);
        Route::post('/materiais',       [MaterialController::class, 'store']);
        Route::get('/materiais/{id}',   [MaterialController::class, 'show']);
        Route::put('/materiais/{id}',   [MaterialController::class, 'update']);
        Route::delete('/materiais/{id}',[MaterialController::class, 'destroy']);

        // Orçamento Mensal
        Route::get('/orcamento',  [BudgetController::class, 'index']);
        Route::post('/orcamento', [BudgetController::class, 'store']);

        // Relatórios e Histórico de Serviços
        Route::get('/relatorios', [ReportController::class, 'index']);
    });
});
