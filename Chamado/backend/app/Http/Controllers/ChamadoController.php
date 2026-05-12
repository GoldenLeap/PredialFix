<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\Chamado;
use App\Http\Requests\StoreChamadoRequest;
use App\Http\Requests\UpdateChamadoRequest;
use Inertia\Inertia;

class ChamadoController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        
        if ($user->cargo === 'solicitante') {
            $chamados = Chamado::with('user')->where('usuario_id', $user->id)->latest()->get();
        } else {
            $chamados = Chamado::with('user')->latest()->get();
        }

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
        $validated = $request->validated();

        if ($request->hasFile('imagem')) {
            $path = $request->file('imagem')->store('chamados', 'public');
            $validated['imagem_path'] = $path;
        }

        $request->user()->chamados()->create($validated);

        return redirect()->route('dashboard')
            ->with('success', 'Chamado criado com sucesso.');
    }

    public function show(Chamado $chamado)
    {
        \Illuminate\Support\Facades\Gate::authorize('view', $chamado);
        $chamado->load(['user', 'historicos.user', 'orcamentos']);
        return Inertia::render('Chamados/Show', [
            'chamado' => $chamado
        ]);
    }

    public function edit(Chamado $chamado)
    {
        \Illuminate\Support\Facades\Gate::authorize('update', $chamado);
        return Inertia::render('Chamados/Edit', [
            'chamado' => $chamado
        ]);
    }

    public function update(UpdateChamadoRequest $request, Chamado $chamado)
    {
        \Illuminate\Support\Facades\Gate::authorize('update', $chamado);
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

        return redirect()->route('dashboard')
            ->with('success', 'Chamado atualizado com sucesso.');
    }

    public function destroy(Chamado $chamado)
    {
        \Illuminate\Support\Facades\Gate::authorize('delete', $chamado);
        $chamado->delete();
        return redirect()->route('dashboard')
            ->with('success', 'Chamado excluído com sucesso.');
    }
}
