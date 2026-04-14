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
        'data_alteracao',
    ];

    public function chamado()
    {
        return $this->belongsTo(Chamado::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'alterado_por');
    }
}
