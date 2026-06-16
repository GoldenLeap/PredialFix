<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Material;
use Illuminate\Http\Request;

class MaterialController extends Controller
{
    /**
     * Lista todos os materiais com totalizadores de status de estoque.
     * GET /api/materiais
     */
    public function index(Request $request)
    {
        $query = Material::query();

        if ($request->has('busca')) {
            $query->where('nome', 'like', '%' . $request->busca . '%')
                  ->orWhere('categoria', 'like', '%' . $request->busca . '%');
        }

        $materiais = $query->latest()->get();

        $total     = $materiais->count();
        $critico   = $materiais->filter(fn($m) => $m->quantidade_atual < $m->quantidade_minima)->count();
        $baixo     = $materiais->filter(fn($m) => $m->quantidade_atual >= $m->quantidade_minima && $m->quantidade_atual <= ($m->quantidade_minima * 1.5))->count();
        $adequado  = $materiais->filter(fn($m) => $m->quantidade_atual > ($m->quantidade_minima * 1.5))->count();

        // Adiciona status calculado a cada item
        $materiais = $materiais->map(function ($m) {
            if ($m->quantidade_atual < $m->quantidade_minima) {
                $m->status_estoque = 'Crítico';
            } elseif ($m->quantidade_atual <= ($m->quantidade_minima * 1.5)) {
                $m->status_estoque = 'Baixo';
            } else {
                $m->status_estoque = 'Adequado';
            }
            return $m;
        });

        return response()->json([
            'totalizadores' => compact('total', 'critico', 'baixo', 'adequado'),
            'materiais'     => $materiais,
        ]);
    }

    /**
     * Cadastra um novo material.
     * POST /api/materiais
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nome'               => 'required|string|max:255',
            'categoria'          => 'required|string|max:100',
            'localizacao'        => 'required|string|max:255',
            'quantidade_atual'   => 'required|numeric|min:0',
            'quantidade_minima'  => 'required|numeric|min:0',
            'unidade'            => 'required|string|max:50',
        ]);

        $material = Material::create($validated);

        return response()->json([
            'message' => 'Material cadastrado com sucesso!',
            'data'    => $material,
        ], 201);
    }

    /**
     * Exibe os detalhes de um material.
     * GET /api/materiais/{id}
     */
    public function show($id)
    {
        $material = Material::findOrFail($id);
        return response()->json($material);
    }

    /**
     * Atualiza um material existente.
     * PUT /api/materiais/{id}
     */
    public function update(Request $request, $id)
    {
        $material = Material::findOrFail($id);

        $validated = $request->validate([
            'nome'               => 'sometimes|required|string|max:255',
            'categoria'          => 'sometimes|required|string|max:100',
            'localizacao'        => 'sometimes|required|string|max:255',
            'quantidade_atual'   => 'sometimes|required|numeric|min:0',
            'quantidade_minima'  => 'sometimes|required|numeric|min:0',
            'unidade'            => 'sometimes|required|string|max:50',
        ]);

        $material->update($validated);

        return response()->json([
            'message' => 'Material atualizado com sucesso!',
            'data'    => $material,
        ]);
    }

    /**
     * Remove um material.
     * DELETE /api/materiais/{id}
     */
    public function destroy($id)
    {
        $material = Material::findOrFail($id);

        $hasActiveChamados = $material->chamados()
            ->where('status', '!=', 'Concluído')
            ->exists();

        if ($hasActiveChamados) {
            return response()->json([
                'message' => 'Não é possível remover este material pois ele está associado a chamados ativos.'
            ], 422);
        }

        $material->delete();

        return response()->json(['message' => 'Material removido com sucesso!']);
    }
}
