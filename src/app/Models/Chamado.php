<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Chamado extends Model
{
    protected $fillable = [
        'usuario_id',
        'tipo',
        'local',
        'descricao',
        'prioridade',
        'status',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'usuario_id');
    }

    public function historicos()
    {
        return $this->hasMany(HistoricoChamado::class);
    }

    public function orcamentos()
    {
        return $this->hasMany(Orcamento::class);
    }
}
