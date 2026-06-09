<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Chamado;
use App\Models\User;
use App\Http\Requests\StoreChamadoRequest;
use App\Http\Requests\UpdateChamadoRequest;
use Inertia\Inertia;
use App\Notifications\ChamadoStatusChanged;

class ChamadoController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->cargo === 'solicitante') {
            $chamados = Chamado::with(['user', 'historicos'])->where('usuario_id', $user->id)->latest()->get();
        } else {
            $chamados = Chamado::with(['user', 'historicos'])->latest()->get();
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

        $chamado = $request->user()->chamados()->create($validated);
        
        // Enviar notificação por email para todos os admins e responsaveis
        $admins = User::whereIn('cargo', ['admin', 'responsavel'])->get();
        foreach ($admins as $admin) {
            $admin->notify(new ChamadoStatusChanged($chamado, 'Novo', 'Aberto'));
        }

        return redirect()->route('dashboard')
            ->with('success', 'Chamado criado com sucesso.');
    }

    public function show(Chamado $chamado)
    {
        \Illuminate\Support\Facades\Gate::authorize('view', $chamado);
        $chamado->load(['user', 'historicos.user', 'orcamentos', 'materiais', 'evidencias']);
        
        $materiais = \App\Models\Material::orderBy('categoria')->orderBy('nome')->get();
        
        return Inertia::render('Chamados/Show', [
            'chamado' => $chamado,
            'historico' => $chamado->historicos()->with('user')->latest()->get(),
            'materiais_disponiveis' => $materiais,
        ]);
    }

    public function edit(Chamado $chamado)
    {
        \Illuminate\Support\Facades\Gate::authorize('update', $chamado);
        $chamado->load('historicos');
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
                'observacao' => $request->input('observacao', null),
                'data_alteracao' => now(),
            ]);

            // Descontar materiais do estoque ao concluir
            if ($request->status === 'Concluído') {
                $chamado->load('materiais');
                foreach ($chamado->materiais as $mat) {
                    $mat->decrement('quantidade_atual', $mat->pivot->quantidade);
                }
            }
            // Devolver materiais ao estoque se reabrir um chamado concluído
            if ($oldStatus === 'Concluído') {
                $chamado->load('materiais');
                foreach ($chamado->materiais as $mat) {
                    $mat->increment('quantidade_atual', $mat->pivot->quantidade);
                }
            }

            // Enviar notificação por email ao solicitante
            $chamado->load('user');
            $chamado->user->notify(new ChamadoStatusChanged($chamado, $oldStatus, $request->status));
        }

        return redirect()->route('chamados.show', $chamado)
            ->with('success', 'Chamado atualizado com sucesso.');
    }

    public function destroy(Chamado $chamado)
    {
        \Illuminate\Support\Facades\Gate::authorize('delete', $chamado);
        $chamado->delete();
        return redirect()->route('dashboard')
            ->with('success', 'Chamado excluído com sucesso.');
    }

    public function addMaterial(Request $request, Chamado $chamado)
    {
        \Illuminate\Support\Facades\Gate::authorize('update', $chamado);

        $validated = $request->validate([
            'material_id' => 'required|exists:materials,id',
            'quantidade'  => 'required|integer|min:1',
        ]);

        $material = \App\Models\Material::findOrFail($validated['material_id']);
        $subtotal = $material->valor_unitario * $validated['quantidade'];

        // Attach or update pivot
        if ($chamado->materiais()->where('material_id', $material->id)->exists()) {
            $chamado->materiais()->updateExistingPivot($material->id, [
                'quantidade'     => \DB::raw('quantidade + ' . $validated['quantidade']),
                'subtotal'       => \DB::raw('subtotal + ' . $subtotal),
            ]);
        } else {
            $chamado->materiais()->attach($material->id, [
                'quantidade'    => $validated['quantidade'],
                'valor_unitario' => $material->valor_unitario,
                'subtotal'      => $subtotal,
            ]);
        }

        // Recalculate custo_materiais
        $total = $chamado->materiais()->sum('chamado_material.subtotal');
        $chamado->update(['custo_materiais' => $total]);

        return redirect()->route('chamados.show', $chamado)
            ->with('success', 'Material adicionado ao chamado.');
    }

    public function removeMaterial(Request $request, Chamado $chamado, \App\Models\Material $material)
    {
        \Illuminate\Support\Facades\Gate::authorize('update', $chamado);

        $chamado->materiais()->detach($material->id);

        // Recalculate custo_materiais
        $total = $chamado->materiais()->sum('chamado_material.subtotal');
        $chamado->update(['custo_materiais' => $total]);

        return redirect()->route('chamados.show', $chamado)
            ->with('success', 'Material removido do chamado.');
    }
}
