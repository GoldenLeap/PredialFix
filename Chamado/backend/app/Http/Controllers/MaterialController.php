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
}
