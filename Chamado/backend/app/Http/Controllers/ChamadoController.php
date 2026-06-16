<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Chamado;
use App\Models\User;
use App\Http\Requests\StoreChamadoRequest;
use App\Http\Requests\UpdateChamadoRequest;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use App\Notifications\ChamadoStatusChanged;
use App\Notifications\ChamadoCreated;
use App\Notifications\TecnicoAtribuido;
use App\Notifications\EstoqueCritico;
use App\Rules\ValidStatusTransition;

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
            $admin->notify(new ChamadoCreated($chamado));
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
        
        // Custom validation for status transition
        if ($request->has('status')) {
            $request->validate([
                'status' => new ValidStatusTransition($chamado->status),
            ]);
        }

        // Regra de Negócio: obrigar técnico antes de "Em Execução"
        if ($request->input('status') === 'Em Execução') {
            $tecnicoId = $request->input('tecnico_id') ?? $chamado->tecnico_id;
            if (empty($tecnicoId)) {
                return back()->withErrors(['status' => 'É necessário designar um técnico antes de iniciar a execução.']);
            }
        }

        $oldStatus = $chamado->status;
        $oldTecnicoId = $chamado->tecnico_id;
        $user = $request->user();
        
        $validated = $request->validated();

        DB::transaction(function () use ($chamado, $validated, $oldStatus, $oldTecnicoId, $user, $request) {
            $chamado->update($validated);

            if ($request->has('status') && $request->status !== $oldStatus) {
                $chamado->historicos()->create([
                    'status_anterior' => $oldStatus,
                    'status_novo' => $request->status,
                    'alterado_por' => $user->id,
                    'observacao' => $request->input('observacao', null),
                    'data_alteracao' => now(),
                ]);

                // Enviar notificação por email ao solicitante
                if ($chamado->user) {
                    $chamado->user->notify(new ChamadoStatusChanged($chamado, $oldStatus, $request->status));
                }
            }

            // Notificar técnico quando é designado
            $novoTecnicoId = $validated['tecnico_id'] ?? null;
            if ($novoTecnicoId && $novoTecnicoId != $oldTecnicoId) {
                $tecnico = User::find($novoTecnicoId);
                if ($tecnico) {
                    $tecnico->notify(new TecnicoAtribuido($chamado));
                }
            }
        });

        return redirect()->route('chamados.show', $chamado)
            ->with('success', 'Chamado atualizado com sucesso.');
    }

    public function destroy(Chamado $chamado)
    {
        \Illuminate\Support\Facades\Gate::authorize('delete', $chamado);
        
        if ($chamado->status === 'Concluído') {
            return back()->withErrors(['error' => 'Chamados concluídos não podem ser excluídos. Eles fazem parte do histórico da unidade.']);
        }
        
        $chamado->delete();
        
        return redirect()->route('dashboard')
            ->with('success', 'Chamado excluído com sucesso.');
    }

    public function addMaterial(Request $request, Chamado $chamado)
    {
        \Illuminate\Support\Facades\Gate::authorize('update', $chamado);

        $validated = $request->validate([
            'material_id' => 'required|exists:materials,id',
            'quantidade'  => 'required|numeric|min:0.01',
        ]);

        $material = \App\Models\Material::findOrFail($validated['material_id']);
        
        if ($material->quantidade_atual < $validated['quantidade']) {
            return back()->withErrors(['quantidade' => "Quantidade insuficiente em estoque. Disponível: {$material->quantidade_atual} {$material->unidade}."]);
        }
        
        DB::transaction(function () use ($chamado, $material, $validated) {
            $subtotal = $material->valor_unitario * $validated['quantidade'];
            
            // Dá baixa no estoque
            $material->quantidade_atual -= $validated['quantidade'];
            $material->save();

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

            // Notificação: estoque crítico
            $material->refresh();
            if ($material->quantidade_atual < $material->quantidade_minima) {
                $admins = User::whereIn('cargo', ['admin', 'responsavel'])->get();
                foreach ($admins as $admin) {
                    $admin->notify(new EstoqueCritico($material));
                }
            }
        });

        return redirect()->route('chamados.show', $chamado)
            ->with('success', 'Material adicionado ao chamado.');
    }

    public function removeMaterial(Request $request, Chamado $chamado, \App\Models\Material $material)
    {
        \Illuminate\Support\Facades\Gate::authorize('update', $chamado);

        DB::transaction(function () use ($chamado, $material) {
            // Get pivot data to restore stock
            $pivot = $chamado->materiais()->where('material_id', $material->id)->first()?->pivot;
            
            if ($pivot) {
                // Restore stock
                $material->quantidade_atual += $pivot->quantidade;
                $material->save();
            }

            $chamado->materiais()->detach($material->id);

            // Recalculate custo_materiais
            $total = $chamado->materiais()->sum('chamado_material.subtotal');
            $chamado->update(['custo_materiais' => $total]);
        });

        return redirect()->route('chamados.show', $chamado)
            ->with('success', 'Material removido do chamado e devolvido ao estoque.');
    }
}
