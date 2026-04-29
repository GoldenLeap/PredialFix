<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Orcamento extends Model
{
    protected $fillable = [
        'chamado_id',
        'fornecedor',
        'valor',
        'descricao_pecas',
        'status',
    ];

    public function chamado()
    {
        return $this->belongsTo(Chamado::class);
    }
}
