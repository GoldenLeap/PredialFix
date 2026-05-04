<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Chamado;
use Illuminate\Http\Request;


class ChamadoController extends Controller
{
    public function index()
    {
        return response()->json(Chamado::latest()->get());
    }

    public function store(Request $request)
    {
        $chamado = Chamado::create($request->all());

        return response()->json([
            'message' => 'Criado via Mobile!',
            'data' => $chamado
        ], 201);
    }


    public function update(Request $request, Chamado $chamado)
    {
        $validated = $request->validate([
            'status' => 'in:Aberto, Em Análise, Em Execução, Concluido'
        ]);

        $chamado->update($validated);

        return response()->json([
            'message' => "Atualizado via mobile",
            'data' => $chamado

        ], 200);
    }
}

