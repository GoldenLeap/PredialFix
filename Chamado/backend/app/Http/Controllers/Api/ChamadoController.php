<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Chamado;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ChamadoController extends Controller
{

    // Lista apenas os chamados do usuário autenticado.

    public function index()
    {
        $chamados = auth()->user()->chamados()
            ->with('historicos')
            ->latest()
            ->get();

        return response()->json($chamados);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'tipo' => 'required|in:Elétrica,Hidráulica,Infraestrutura,Outros',
            'local' => 'required|string',
            'assunto' => 'required|string|max:255',
            'descricao' => 'required|string',
            'prioridade' => 'required|in:Baixa,Média,Alta',
            'tipo_servico' => 'required|in:Interno,Externo',
            'imagem' => 'nullable|image|max:10240', // Max 10MB
            'observacao' => 'nullable|string|max:1000',
        ]);

        $data = $validated;
        $data['usuario_id'] = auth()->id();
        $data['status'] = 'Aberto';

        if ($request->hasFile('imagem')) {
            $path = $request->file('imagem')->store('chamados', 'public');
            $data['imagem_path'] = $path;
        }

        unset($data['imagem']);

        $chamado = Chamado::create($data);

        return response()->json([
            'message' => 'Chamado criado com sucesso via Mobile!',
            'data' => $chamado
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $chamado = Chamado::findOrFail($id);

        // Auth do chamado ou Responsável ou Admin
        if ($chamado->usuario_id !== auth()->id() && auth()->user()->cargo !== 'responsavel' && auth()->user()->cargo !== 'admin') {
            return response()->json(['message' => 'Não autorizado'], 403);
        }

        $validated = $request->validate([
            'status' => 'required|in:Aberto,Em Análise,Em Execução,Concluído',
            'observacao' => 'nullable|string|max:1000',
        ]);

        $oldStatus = $chamado->status;
        $chamado->update($validated);

        if ($request->status !== $oldStatus) {
            $chamado->historicos()->create([
                'status_anterior' => $oldStatus,
                'status_novo' => $request->status,
                'alterado_por' => auth()->id(),
                'observacao' => $request->input('observacao', null),
                'data_alteracao' => now(),
            ]);
        }

        return response()->json([
            'message' => "Chamado atualizado com sucesso!",
            'data' => $chamado
        ], 200);
    }
}

