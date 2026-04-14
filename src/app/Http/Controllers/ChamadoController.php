<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\Chamado;
use App\Http\Requests\StoreChamadoRequest;
use App\Http\Requests\UpdateChamadoRequest;
use Inertia\Inertia;

class ChamadoController extends Controller
{
    public function index()
    {
        $chamados = Chamado::with('user')->latest()->get();
        return Inertia::render('Chamados/Index', [
            'chamados' => $chamados
        ]);
    }

    public function create()
    {
        return Inertia::render('Chamados/Create');
    }

    public function store(StoreChamadoRequest $request)
    {
        $request->user()->chamados()->create($request->validated());

        return redirect()->route('chamados.index')
            ->with('success', 'Chamado criado com sucesso.');
    }

    public function show(Chamado $chamado)
    {
        $chamado->load(['user', 'historicos.user', 'orcamentos']);
        return Inertia::render('Chamados/Show', [
            'chamado' => $chamado
        ]);
    }

    public function edit(Chamado $chamado)
    {
        return Inertia::render('Chamados/Edit', [
            'chamado' => $chamado
        ]);
    }

    public function update(UpdateChamadoRequest $request, Chamado $chamado)
    {
        $oldStatus = $chamado->status;
        $chamado->update($request->validated());

        if ($request->has('status') && $request->status !== $oldStatus) {
            $chamado->historicos()->create([
                'status_anterior' => $oldStatus,
                'status_novo' => $request->status,
                'alterado_por' => $request->user()->id,
                'data_alteracao' => now(),
            ]);
        }

        return redirect()->route('chamados.index')
            ->with('success', 'Chamado atualizado com sucesso.');
    }

    public function destroy(Chamado $chamado)
    {
        $chamado->delete();
        return redirect()->route('chamados.index')
            ->with('success', 'Chamado excluído com sucesso.');
    }
}
