<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Material extends Model
{
    use HasFactory;

    protected $fillable = [
        'nome',
        'categoria',
        'localizacao',
        'quantidade_atual',
        'quantidade_minima',
        'unidade',
        'valor_unitario',
    ];

    public function chamados()
    {
        return $this->belongsToMany(Chamado::class, 'chamado_material')
                    ->withPivot('quantidade', 'valor_unitario', 'subtotal')
                    ->withTimestamps();
    }
}
