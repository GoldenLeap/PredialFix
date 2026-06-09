<?php

namespace App\Http\Controllers;

use App\Models\Material;
use Illuminate\Http\Request;
use Inertia\Inertia;

class MaterialController extends Controller
{
    public function index()
    {
        $materials = Material::all();
        return Inertia::render('Materiais', [
            'materials' => $materials
        ]);
    }

    public function create()
    {
        return Inertia::render('Materiais/Create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'nome'               => 'required|string|max:255',
            'categoria'          => 'required|in:Elétrica,Hidráulica,Infraestrutura,Outros',
            'quantidade_atual'   => 'required|numeric|min:0',
            'quantidade_minima'  => 'required|numeric|min:0',
            'unidade'            => 'required|string|max:50',
            'valor_unitario'     => 'required|numeric|min:0',
            'localizacao'        => 'nullable|string|max:255',
        ]);

        Material::create($validated);

        return redirect()->route('materiais.index')->with('success', 'Material criado com sucesso.');
    }

    public function edit(Material $material)
    {
        return Inertia::render('Materiais/Edit', [
            'material' => $material
        ]);
    }

    public function update(Request $request, Material $material)
    {
        $validated = $request->validate([
            'nome'               => 'required|string|max:255',
            'categoria'          => 'required|in:Elétrica,Hidráulica,Infraestrutura,Outros',
            'quantidade_atual'   => 'required|numeric|min:0',
            'quantidade_minima'  => 'required|numeric|min:0',
            'unidade'            => 'required|string|max:50',
            'valor_unitario'     => 'required|numeric|min:0',
            'localizacao'        => 'nullable|string|max:255',
        ]);

        $material->update($validated);

        return redirect()->route('materiais.index')->with('success', 'Material atualizado com sucesso.');
    }

    public function destroy(Material $material)
    {
        $material->delete();
        return redirect()->route('materiais.index')->with('success', 'Material removido com sucesso.');
    }
}
