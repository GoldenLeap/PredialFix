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

}
