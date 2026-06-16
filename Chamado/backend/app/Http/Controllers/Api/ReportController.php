<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Chamado;
use Illuminate\Http\Request;

class ReportController extends Controller
{
    /**
     * Retorna relatório paginado de chamados com dados de custo.
     * GET /api/relatorios
     *
     * Query params opcionais:
     *  - busca        : filtra por ID do chamado ou assunto
     *  - status       : filtra por status
     *  - prioridade   : filtra por prioridade
     *  - tipo         : filtra por tipo (Elétrica, Hidráulica, etc.)
     *  - data_inicio  : data inicial (Y-m-d)
     *  - data_fim     : data final (Y-m-d)
     *  - por_pagina   : itens por página (padrão: 10)
     */
    public function index(Request $request)
    {
        $query = Chamado::with([
            'user:id,name',
            'tecnico:id,name',
        ]);

        if ($request->filled('busca')) {
            $busca = $request->busca;
            $query->where(function ($q) use ($busca) {
                $q->where('id', 'like', "%{$busca}%")
                  ->orWhere('assunto', 'like', "%{$busca}%");
            });
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('prioridade')) {
            $query->where('prioridade', $request->prioridade);
        }

        if ($request->filled('tipo')) {
            $query->where('tipo', $request->tipo);
        }

        if ($request->filled('data_inicio')) {
            $query->whereDate('created_at', '>=', $request->data_inicio);
        }

        if ($request->filled('data_fim')) {
            $query->whereDate('created_at', '<=', $request->data_fim);
        }

        $porPagina = $request->input('por_pagina', 10);
        $chamados  = $query->latest()->paginate($porPagina);

        // Totalizadores do relatório
        $servicosTotal   = Chamado::count();
        $custoTotal      = Chamado::selectRaw('SUM(COALESCE(custo_mao_obra, 0) + COALESCE(custo_materiais, 0)) as total')->value('total') ?? 0;
        $custoMaoObra    = Chamado::selectRaw('SUM(COALESCE(custo_mao_obra, 0)) as total')->value('total') ?? 0;
        $custoMateriais  = Chamado::selectRaw('SUM(COALESCE(custo_materiais, 0)) as total')->value('total') ?? 0;
        
        $abertos = Chamado::where('status', 'Aberto')->count();
        $emAnalise = Chamado::where('status', 'Em Análise')->count();
        $emExecucao = Chamado::where('status', 'Em Execução')->count();
        $concluidos = Chamado::where('status', 'Concluído')->count();

        // Formata os itens para o formato do relatório
        $chamados->getCollection()->transform(function ($c) {
            return [
                'id'               => $c->id,
                'data'             => $c->created_at->format('d/m/Y'),
                'servico'          => $c->assunto,
                'tipo'             => $c->tipo,
                'prioridade'       => $c->prioridade,
                'status'           => $c->status,
                'local'            => $c->local,
                'tecnico'          => $c->tecnico->name ?? 'Não atribuído',
                'custo_mao_obra'   => (float) ($c->custo_mao_obra ?? 0),
                'custo_materiais'  => (float) ($c->custo_materiais ?? 0),
                'custo_total'      => (float) (($c->custo_mao_obra ?? 0) + ($c->custo_materiais ?? 0)),
                'solicitante'      => $c->user->name ?? 'N/A',
            ];
        });

        return response()->json([
            'totalizadores' => [
                'servicos_total'  => $servicosTotal,
                'custo_total'     => (float) $custoTotal,
                'custo_mao_obra'  => (float) $custoMaoObra,
                'custo_materiais' => (float) $custoMateriais,
                'abertos'         => $abertos,
                'em_analise'      => $emAnalise,
                'em_execucao'     => $emExecucao,
                'concluidos'      => $concluidos,
            ],
            'relatorio' => $chamados,
        ]);
    }
}
