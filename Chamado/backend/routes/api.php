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
| API Routes — PredialFix Mobile
|--------------------------------------------------------------------------
|
| Prefixo automático: /api
| Autenticação: Laravel Sanctum (token via Bearer)
| Controle de acesso: middleware 'role' (CheckRole)
|
| Cargos existentes: solicitante | responsavel | admin
|
*/

// ═══════════════════════════════════════════════════════════════
// ROTAS PÚBLICAS (sem autenticação)
// ═══════════════════════════════════════════════════════════════

// POST /api/login  → Autentica e devolve um Bearer token
Route::post('/login', [AuthController::class, 'login']);

// POST /api/register → Registra novo usuário e devolve um Bearer token
Route::post('/register', [AuthController::class, 'register']);


// ═══════════════════════════════════════════════════════════════
// ROTAS PROTEGIDAS — qualquer usuário autenticado via Sanctum
// ═══════════════════════════════════════════════════════════════
Route::middleware('auth:sanctum')->group(function () {

    // ── Autenticação e Perfil ───────────────────────────────────
    // POST /api/logout  → Revoga o token atual
    Route::post('/logout', [AuthController::class, 'logout']);

    // GET /api/me  → Retorna os dados do usuário autenticado
    Route::get('/me', [AuthController::class, 'me']);

    // PUT /api/profile  → Atualiza dados básicos do perfil (nome, email)
    Route::put('/profile', [\App\Http\Controllers\Api\ProfileController::class, 'update']);
    
    // PUT /api/profile/password  → Atualiza a senha
    Route::put('/profile/password', [\App\Http\Controllers\Api\ProfileController::class, 'updatePassword']);


    // ── Chamados (acesso diferenciado por cargo) ─────────────────
    //
    // GET    /api/chamados                    → Lista (cargo-aware)
    // POST   /api/chamados                    → Abre novo chamado
    // GET    /api/chamados/historico-unidade  → Histórico de um local
    //                                           ↑ DEVE ficar antes de /{id}
    // GET    /api/chamados/{id}               → Detalhes de um chamado
    //
    Route::get('/chamados', [ChamadoController::class, 'index']);
    Route::post('/chamados', [ChamadoController::class, 'store']);

    // !! Rota com segmento literal deve vir ANTES do wildcard {id}
    Route::get('/chamados/historico-unidade', [ChamadoController::class, 'historicoUnidade']);

    Route::get('/chamados/{id}', [ChamadoController::class, 'show']);


    // ═══════════════════════════════════════════════════════════════
    // ROTAS RESTRITAS — apenas Responsável e Admin
    // ═══════════════════════════════════════════════════════════════
    Route::middleware('role:responsavel,admin')->group(function () {

        // ── Chamados (ações de gestão) ───────────────────────────
        // PUT    /api/chamados/{id}  → Atualiza status, técnico, custos
        // DELETE /api/chamados/{id}  → Remove um chamado
        Route::put('/chamados/{id}', [ChamadoController::class, 'update']);
        Route::delete('/chamados/{id}', [ChamadoController::class, 'destroy']);

        // ── Dashboard ────────────────────────────────────────────
        // GET /api/dashboard?mes=6&ano=2026
        Route::get('/dashboard', [DashboardController::class, 'index']);

        // ── Materiais (CRUD completo) ────────────────────────────
        // GET    /api/materiais          → Lista com totalizadores de estoque
        // POST   /api/materiais          → Cadastra novo material
        // GET    /api/materiais/{id}     → Detalhes de um material
        // PUT    /api/materiais/{id}     → Atualiza material
        // DELETE /api/materiais/{id}     → Remove material
        Route::get('/materiais', [MaterialController::class, 'index']);
        Route::post('/materiais', [MaterialController::class, 'store']);
        Route::get('/materiais/{id}', [MaterialController::class, 'show']);
        Route::put('/materiais/{id}', [MaterialController::class, 'update']);
        Route::delete('/materiais/{id}', [MaterialController::class, 'destroy']);

        // ── Orçamento Mensal ─────────────────────────────────────
        // GET  /api/orcamento?mes=6&ano=2026  → Config + histórico 6 meses
        // POST /api/orcamento                 → Cria ou atualiza orçamento
        Route::get('/orcamento', [BudgetController::class, 'index']);
        Route::post('/orcamento', [BudgetController::class, 'store']);

        // ── Relatórios ───────────────────────────────────────────
        // GET /api/relatorios  → Relatório paginado com filtros e totalizadores
        // Query params: busca, status, prioridade, tipo, data_inicio, data_fim, por_pagina
        Route::get('/relatorios', [ReportController::class, 'index']);
    });
});
