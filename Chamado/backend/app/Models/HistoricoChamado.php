<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class HistoricoChamado extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'chamado_id',
        'status_anterior',
        'status_novo',
        'alterado_por',
        'observacao',
        'data_alteracao',
    ];

    public function chamado()
    {
        return $this->belongsTo(Chamado::class);
    }

    /** Usuário que realizou a alteração de status. */
    public function user()
    {
        return $this->belongsTo(User::class, 'alterado_por');
    }

    /** Alias para eager loading com nome semântico: ->with('historicos.alteradoPor') */
    public function alteradoPor()
    {
        return $this->belongsTo(User::class, 'alterado_por');
    }
}

