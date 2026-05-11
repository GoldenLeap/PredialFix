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
            ->latest()
            ->get()
            ->map(function ($chamado) {
                if ($chamado->imagem_path) {
                    $chamado->imagem_url = asset('storage/' . $chamado->imagem_path);
                }
                return $chamado;
            });

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
        ]);

        $data = $validated;
        $data['usuario_id'] = auth()->id();
        $data['status'] = 'Aberto';

        if ($request->hasFile('imagem')) {
            $path = $request->file('imagem')->store('chamados', 'public');
            $data['imagem_path'] = $path;
        }

        $chamado = Chamado::create($data);

        return response()->json([
            'message' => 'Chamado criado com sucesso via Mobile!',
            'data' => $chamado
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $chamado = Chamado::findOrFail($id);

        if ($chamado->usuario_id !== auth()->id()) {
            return response()->json(['message' => 'Não autorizado'], 403);
        }

        $validated = $request->validate([
            'status' => 'required|in:Aberto,Em Análise,Em Execução,Concluído'
        ]);

        $chamado->update($validated);

        return response()->json([
            'message' => "Chamado atualizado com sucesso!",
            'data' => $chamado
        ], 200);
    }
}

