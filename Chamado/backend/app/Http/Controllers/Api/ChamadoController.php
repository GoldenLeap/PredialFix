<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Chamado;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Notifications\ChamadoStatusChanged;
use App\Notifications\ChamadoCreated;
use App\Notifications\TecnicoAtribuido;
use App\Notifications\EstoqueCritico;
use App\Rules\ValidStatusTransition;
use Carbon\Carbon;

class ChamadoController extends Controller
{
    /** Mapeamento de notificações por status (simulação de progresso). */
    private array $notificacoes = [
        'Em Análise' => 'Seu chamado está sendo analisado pela equipe.',
        'Em Execução' => 'Técnico a caminho. O serviço foi iniciado.',
        'Concluído' => 'Serviço finalizado. Chamado encerrado com sucesso!',
    ];

    /**
     * Lista chamados:
     *  - Admin/Responsável: todos os chamados (com filtros opcionais).
     *  - Usuário comum: apenas os próprios chamados.
     * GET /api/chamados
     */
    public function index(Request $request)
    {
        $user = auth()->user();
        $cargo = $user->cargo;

        if (in_array($cargo, ['admin', 'responsavel'])) {
            $query = Chamado::with(['user:id,name', 'historicos', 'tecnico:id,name']);

            // Filtros opcionais para responsável
            if ($request->filled('status')) {
                $query->where('status', $request->status);
            }
            if ($request->filled('prioridade')) {
                $query->where('prioridade', $request->prioridade);
            }
            if ($request->filled('tipo')) {
                $query->where('tipo', $request->tipo);
            }

            $chamados = $query->latest()->get();
        } else {
            $chamados = $user->chamados()
                ->with('historicos')
                ->latest()
                ->get();
        }

        return response()->json($chamados);
    }

    /**
     * Retorna estatísticas para o Dashboard visual.
     * GET /api/chamados/dashboard
     */
    public function dashboard()
    {
        $user = auth()->user();
        $query = Chamado::query();
        $now = Carbon::now();

        // Se não for admin, vê apenas as próprias estatísticas
        if (!in_array($user->cargo, ['admin', 'responsavel'])) {
            $query->where('usuario_id', $user->id);
        }

        $stats = [
            'total' => (clone $query)->count(),
            'atual' => (clone $query)->whereMonth('created_at', $now->month)
                ->whereYear('created_at', $now->year)->count(),
            'abertos' => (clone $query)->where('status', 'Aberto')->count(),
            'em_execucao' => (clone $query)->where('status', 'Em Execução')->count(),
            'concluidos' => (clone $query)->where('status', 'Concluído')->count(),
            'por_prioridade' => [
                'Alta' => (clone $query)->where('prioridade', 'Alta')->count(),
                'Média' => (clone $query)->where('prioridade', 'Média')->count(),
                'Baixa' => (clone $query)->where('prioridade', 'Baixa')->count(),
            ]
        ];

        return response()->json($stats);
    }

    /**
     * Abre um novo chamado.
     * POST /api/chamados
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nif' => 'required|string|max:20',
            'tipo' => 'required|in:Elétrica,Hidráulica,Infraestrutura,Outros',
            'local' => 'required|string|max:255',
            'patrimonio' => 'nullable|string|max:100',
            'assunto' => 'required|string|max:255',
            'descricao' => 'required|string',
            'prioridade' => 'required|in:Baixa,Média,Alta',
            'tipo_servico' => 'required|in:Interno,Externo',
            'imagem' => 'nullable|image|max:10240',
            'data_limite' => 'nullable|date',
            'observacao' => 'nullable|string|max:1000',
        ]);

        // Remove o campo 'imagem' dos dados validados — o upload é tratado
        // separadamente e salvo como 'imagem_path' no banco.
        $data = collect($validated)->except('imagem')->all();

        // Regra de Negócio: Conversão automática de Data -> Prioridade
        if (!empty($validated['data_limite'])) {
            $hoje = Carbon::now();
            $limite = Carbon::parse($validated['data_limite']);
            $diasRestantes = $hoje->diffInDays($limite, false);

            if ($diasRestantes <= 2) {
                $data['prioridade'] = 'Alta';
            } elseif ($diasRestantes <= 5) {
                $data['prioridade'] = 'Média';
            } else {
                $data['prioridade'] = 'Baixa';
            }
        }

        $user = auth()->user();
        $data['usuario_id'] = auth()->id();
        $data['status'] = 'Aberto';

        if ($request->hasFile('imagem')) {
            $data['imagem_path'] = $request->file('imagem')->store('chamados', 'public');
        }

        $chamado = Chamado::create($data);

        // ── Notificações ──────────────────────────────────────────────
        // 1. Email de confirmação simples ao solicitante
        try {
            \Illuminate\Support\Facades\Mail::raw(
                "Olá, um novo chamado (#{$chamado->id}) foi aberto para o setor de {$chamado->tipo} por {$user->name}.",
                function ($message) use ($user) {
                    $message->to($user->email)->subject('Confirmação de Abertura de Chamado - PredialFix');
                }
            );
        } catch (\Exception $e) {
            Log::error('Falha ao enviar email de confirmação de chamado: ' . $e->getMessage(), [
                'chamado_id' => $chamado->id,
                'user_id' => $user->id,
            ]);
        }

        // 2. Notificar admins/responsáveis (email + sininho) via Notification
        $admins = User::whereIn('cargo', ['admin', 'responsavel'])->get();
        foreach ($admins as $admin) {
            $admin->notify(new ChamadoCreated($chamado));
        }

        return response()->json([
            'message' => 'Chamado criado com sucesso!',
            'data' => $chamado,
        ], 201);
    }

    /**
     * Exibe um chamado específico com seu histórico completo.
     * GET /api/chamados/{id}
     */
    public function show($id)
    {
        $user = auth()->user();
        $chamado = Chamado::with([
            'user:id,name',
            'historicos.alteradoPor:id,name',
            'tecnico:id,name',
            'materiais',
            'evidencias'
        ])->findOrFail($id);

        // Usuário comum só pode ver os próprios chamados
        if (!in_array($user->cargo, ['admin', 'responsavel']) && $chamado->usuario_id !== $user->id) {
            return response()->json(['message' => 'Não autorizado'], 403);
        }

        return response()->json($chamado);
    }

    /**
     * Atualiza o status de um chamado e registra no histórico.
     * Apenas Responsável/Admin podem trocar de status.
     * PUT /api/chamados/{id}
     */
    public function update(Request $request, $id)
    {
        $user = auth()->user();
        $chamado = Chamado::findOrFail($id);

        if (!in_array($user->cargo, ['admin', 'responsavel'])) {
            return response()->json(['message' => 'Apenas responsáveis podem atualizar o status de um chamado.'], 403);
        }

        $validated = $request->validate([
            'status' => [
                'required',
                'in:Aberto,Em Análise,Aguardando Material,Em Execução,Concluído',
                new ValidStatusTransition($chamado->status),
            ],
            'observacao' => 'nullable|string|max:1000',
            'tecnico_id' => 'nullable|exists:users,id',
            'custo_mao_obra' => 'nullable|numeric|min:0',
            'custo_materiais' => 'nullable|numeric|min:0',
        ]);

        // ── Regra de Negócio: tecnico_id deve ser admin ou responsável ──
        if (!empty($validated['tecnico_id'])) {
            $tecnico = User::find($validated['tecnico_id']);
            if (!$tecnico || !in_array($tecnico->cargo, ['admin', 'responsavel'])) {
                return response()->json([
                    'message' => 'O técnico designado deve ser um responsável ou admin.',
                ], 422);
            }
        }

        // ── Regra de Negócio: obrigar técnico antes de "Em Execução" ──
        if ($validated['status'] === 'Em Execução') {
            $tecnicoId = $validated['tecnico_id'] ?? $chamado->tecnico_id;
            if (empty($tecnicoId)) {
                return response()->json([
                    'message' => 'É necessário designar um técnico antes de iniciar a execução.',
                ], 422);
            }
        }

        $oldStatus = $chamado->status;
        $oldTecnicoId = $chamado->tecnico_id;

        // Usa transação para garantir integridade
        DB::transaction(function () use ($chamado, $validated, $oldStatus, $oldTecnicoId, $user) {
            $chamado->update($validated);

            // Registra histórico apenas se o status mudou
            if ($validated['status'] !== $oldStatus) {
                $chamado->historicos()->create([
                    'status_anterior' => $oldStatus,
                    'status_novo' => $validated['status'],
                    'alterado_por' => $user->id,
                    'observacao' => $validated['observacao'] ?? null,
                    'data_alteracao' => now(),
                ]);

                // Notificar o solicitante sobre a mudança de status (email + sininho)
                if ($chamado->user) {
                    $chamado->user->notify(new ChamadoStatusChanged($chamado, $oldStatus, $validated['status']));
                }
            }

            // ── Notificar técnico quando é designado ──
            $novoTecnicoId = $validated['tecnico_id'] ?? null;
            if ($novoTecnicoId && $novoTecnicoId != $oldTecnicoId) {
                $tecnico = User::find($novoTecnicoId);
                if ($tecnico) {
                    $tecnico->notify(new TecnicoAtribuido($chamado));
                }
            }
        });

        // Simulação de notificação de progresso
        $notificacao = $this->notificacoes[$validated['status']] ?? null;

        return response()->json([
            'message' => 'Chamado atualizado com sucesso!',
            'notificacao' => $notificacao,
            'data' => $chamado->fresh(['user:id,name', 'tecnico:id,name', 'historicos']),
        ]);
    }

    /**
     * Histórico da Unidade: retorna todos os chamados de um local específico.
     * GET /api/chamados/historico-unidade?local=Sala+101
     */
    public function historicoUnidade(Request $request)
    {
        $request->validate([
            'local' => 'required|string|max:255',
        ]);

        // Sanitiza wildcards LIKE para evitar problemas com caracteres especiais
        $localSanitizado = str_replace(['%', '_'], ['\%', '\_'], $request->local);

        $chamados = Chamado::with(['user:id,name', 'historicos', 'tecnico:id,name'])
            ->where('local', 'like', '%' . $localSanitizado . '%')
            ->latest()
            ->get();

        return response()->json([
            'local' => $request->local,
            'total' => $chamados->count(),
            'chamados' => $chamados,
        ]);
    }

    /**
     * Remove um chamado. Apenas Responsável/Admin (garantido pela rota).
     * DELETE /api/chamados/{id}
     *
     * Regra de Negócio: Chamados concluídos não podem ser excluídos
     * pois fazem parte do histórico da unidade.
     */
    public function destroy($id)
    {
        $chamado = Chamado::findOrFail($id);

        if ($chamado->status === 'Concluído') {
            return response()->json([
                'message' => 'Chamados concluídos não podem ser excluídos. Eles fazem parte do histórico da unidade.',
            ], 422);
        }

        $chamado->delete();

        return response()->json(['message' => 'Chamado removido com sucesso.']);
    }

    /**
     * Adiciona material consumido ao chamado.
     * POST /api/chamados/{id}/materiais
     *
     * Regra de Negócio: estoque é descontado no momento da adição.
     * Não é possível adicionar mais do que o disponível em estoque.
     */
    public function adicionarMaterial(Request $request, $id)
    {
        $user = auth()->user();
        $chamado = Chamado::findOrFail($id);

        if (!in_array($user->cargo, ['admin', 'responsavel']) && $chamado->tecnico_id !== $user->id) {
            return response()->json(['message' => 'Apenas o técnico atribuído ou um responsável podem adicionar materiais.'], 403);
        }

        $validated = $request->validate([
            'material_id' => 'required|exists:materials,id',
            'quantidade' => 'required|numeric|min:0.01',
        ]);

        $material = \App\Models\Material::findOrFail($validated['material_id']);

        // ── Regra de Negócio: não tirar mais do que tem no estoque ──
        if ($material->quantidade_atual < $validated['quantidade']) {
            return response()->json([
                'message' => "Quantidade insuficiente em estoque. Disponível: {$material->quantidade_atual} {$material->unidade}.",
                'disponivel' => $material->quantidade_atual,
                'solicitado' => $validated['quantidade'],
            ], 400);
        }

        // Usa transação para garantir integridade (desconto + pivot + custo)
        DB::transaction(function () use ($chamado, $material, $validated, $user) {
            // Dá baixa no estoque
            $material->quantidade_atual -= $validated['quantidade'];
            $material->save();

            // Calcula subtotal
            $subtotal = $validated['quantidade'] * $material->valor_unitario;

            // Associa na tabela pivô
            $chamado->materiais()->attach($material->id, [
                'quantidade' => $validated['quantidade'],
                'valor_unitario' => $material->valor_unitario,
                'subtotal' => $subtotal,
            ]);

            // Atualiza o custo total de materiais no chamado
            $chamado->custo_materiais = ($chamado->custo_materiais ?? 0) + $subtotal;
            $chamado->save();

            // ── Notificação: estoque crítico ──
            $material->refresh();
            if ($material->quantidade_atual < $material->quantidade_minima) {
                $admins = User::whereIn('cargo', ['admin', 'responsavel'])->get();
                foreach ($admins as $admin) {
                    $admin->notify(new EstoqueCritico($material));
                }
            }
        });

        return response()->json([
            'message' => 'Material adicionado com sucesso.',
            'custo_materiais' => $chamado->fresh()->custo_materiais,
        ]);
    }

    /**
     * Técnico solicita material que faltou.
     * POST /api/chamados/{id}/solicitar-material
     */
    public function solicitarMaterial(Request $request, $id)
    {
        $user = auth()->user();
        $chamado = Chamado::findOrFail($id);

        if ($chamado->tecnico_id !== $user->id && !in_array($user->cargo, ['admin', 'responsavel'])) {
            return response()->json(['message' => 'Não autorizado.'], 403);
        }

        $validated = $request->validate([
            'observacao' => 'required|string|max:1000'
        ]);

        $oldStatus = $chamado->status;

        DB::transaction(function () use ($chamado, $validated, $oldStatus, $user) {
            $chamado->status = 'Aguardando Material';
            $chamado->save();

            // Histórico
            $chamado->historicos()->create([
                'status_anterior' => $oldStatus,
                'status_novo' => 'Aguardando Material',
                'alterado_por' => $user->id,
                'observacao' => 'Solicitação de material: ' . $validated['observacao'],
                'data_alteracao' => now(),
            ]);

            // Notifica o solicitante
            if ($chamado->user) {
                $chamado->user->notify(new ChamadoStatusChanged($chamado, $oldStatus, 'Aguardando Material'));
            }

            // Notifica admins/responsáveis sobre a solicitação
            $admins = User::whereIn('cargo', ['admin', 'responsavel'])
                ->where('id', '!=', $user->id)
                ->get();
            foreach ($admins as $admin) {
                $admin->notify(new ChamadoStatusChanged($chamado, $oldStatus, 'Aguardando Material'));
            }
        });

        return response()->json([
            'message' => 'Material solicitado. Status atualizado.',
            'data' => $chamado->fresh('historicos')
        ]);
    }

    /**
     * Adiciona múltiplas evidências ao chamado.
     * POST /api/chamados/{id}/evidencias
     */
    public function adicionarEvidencias(Request $request, $id)
    {
        $user = auth()->user();
        $chamado = Chamado::findOrFail($id);

        if ($chamado->tecnico_id !== $user->id && !in_array($user->cargo, ['admin', 'responsavel'])) {
            return response()->json(['message' => 'Não autorizado.'], 403);
        }

        $request->validate([
            'fotos' => 'required|array',
            'fotos.*' => 'image|max:10240',
            'tipo' => 'required|in:antes,depois,geral',
        ]);

        $evidencias = [];

        if ($request->hasFile('fotos')) {
            foreach ($request->file('fotos') as $foto) {
                $path = $foto->store('chamados/evidencias', 'public');
                $evidencias[] = $chamado->evidencias()->create([
                    'caminho_arquivo' => $path,
                    'tipo' => $request->tipo,
                ]);
            }
        }

        return response()->json([
            'message' => 'Evidências adicionadas com sucesso.',
            'evidencias' => $evidencias
        ]);
    }
}
