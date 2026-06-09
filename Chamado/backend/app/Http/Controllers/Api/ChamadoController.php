<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Chamado;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Carbon\Carbon;

class ChamadoController extends Controller
{
    /** Mapeamento de notificações por status (simulação de progresso). */
    private array $notificacoes = [
        'Em Análise'  => 'Seu chamado está sendo analisado pela equipe.',
        'Em Execução' => 'Técnico a caminho. O serviço foi iniciado.',
        'Concluído'   => 'Serviço finalizado. Chamado encerrado com sucesso!',
    ];

    /**
     * Lista chamados:
     *  - Admin/Responsável: todos os chamados (com filtros opcionais).
     *  - Usuário comum: apenas os próprios chamados.
     * GET /api/chamados
     */
    public function index(Request $request)
    {
        $user  = auth()->user();
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
            'nif'          => 'required|string|max:20',
            'tipo'         => 'required|in:Elétrica,Hidráulica,Infraestrutura,Outros',
            'local'        => 'required|string|max:255',
            'patrimonio'   => 'nullable|string|max:100',
            'assunto'      => 'required|string|max:255',
            'descricao'    => 'required|string',
            'prioridade'   => 'required|in:Baixa,Média,Alta',
            'tipo_servico' => 'required|in:Interno,Externo',
            'imagem'       => 'nullable|image|max:10240',
            'data_limite'  => 'nullable|date',
            'observacao'   => 'nullable|string|max:1000',
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
        $data['status']     = 'Aberto';

        if ($request->hasFile('imagem')) {
            $data['imagem_path'] = $request->file('imagem')->store('chamados', 'public');
        }

        $chamado = Chamado::create($data);

        // Desafio Técnico: Notificação por E-mail (SMTP)
        // Certifique-se de ter configurado o .env com os dados do servidor SMTP
        try {
            Mail::raw("Olá, um novo chamado (#{$chamado->id}) foi aberto para o setor de {$chamado->tipo} por {$user->name}.", function ($message) use ($user) {
                $message->to($user->email)->subject('Confirmação de Abertura de Chamado - PredialFix');
            });
        } catch (\Exception $e) {
            // Log do erro se o SMTP falhar, mas permite que o fluxo continue
        }

        return response()->json([
            'message' => 'Chamado criado com sucesso!',
            'data'    => $chamado,
        ], 201);
    }

    /**
     * Exibe um chamado específico com seu histórico completo.
     * GET /api/chamados/{id}
     */
    public function show($id)
    {
        $user    = auth()->user();
        $chamado = Chamado::with(['user:id,name', 'historicos.alteradoPor:id,name', 'tecnico:id,name'])
            ->findOrFail($id);

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
        $user    = auth()->user();
        $chamado = Chamado::findOrFail($id);

        if (!in_array($user->cargo, ['admin', 'responsavel'])) {
            return response()->json(['message' => 'Apenas responsáveis podem atualizar o status de um chamado.'], 403);
        }

        $validated = $request->validate([
            'status'          => 'required|in:Aberto,Em Análise,Em Execução,Concluído',
            'observacao'      => 'nullable|string|max:1000',
            'tecnico_id'      => 'nullable|exists:users,id',
            'custo_mao_obra'  => 'nullable|numeric|min:0',
            'custo_materiais' => 'nullable|numeric|min:0',
        ]);

        $oldStatus = $chamado->status;
        $chamado->update($validated);

        // Registra histórico apenas se o status mudou
        if ($validated['status'] !== $oldStatus) {
            $chamado->historicos()->create([
                'status_anterior' => $oldStatus,
                'status_novo'     => $validated['status'],
                'alterado_por'    => $user->id,
                'observacao'      => $validated['observacao'] ?? null,
                'data_alteracao'  => now(),
            ]);
        }

        // Simulação de notificação de progresso
        $notificacao = $this->notificacoes[$validated['status']] ?? null;

        return response()->json([
            'message'     => 'Chamado atualizado com sucesso!',
            'notificacao' => $notificacao,
            'data'        => $chamado->fresh(['user:id,name', 'tecnico:id,name', 'historicos']),
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

        $chamados = Chamado::with(['user:id,name', 'historicos', 'tecnico:id,name'])
            ->where('local', 'like', '%' . $request->local . '%')
            ->latest()
            ->get();

        return response()->json([
            'local'    => $request->local,
            'total'    => $chamados->count(),
            'chamados' => $chamados,
        ]);
    }

    /**
     * Remove um chamado. Apenas Responsável/Admin (garantido pela rota).
     * DELETE /api/chamados/{id}
     */
    public function destroy($id)
    {
        $chamado = Chamado::findOrFail($id);
        $chamado->delete();

        return response()->json(['message' => 'Chamado removido com sucesso.']);
    }
}
