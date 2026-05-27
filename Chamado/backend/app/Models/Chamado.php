<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Chamado extends Model
{
protected $fillable = [
        'usuario_id',
        'tecnico_id',
        'tipo',
        'local',
        'assunto',
        'descricao',
        'prioridade',
        'status',
        'tipo_servico',
        'imagem_path',
        'observacao',
        'custo_mao_obra',
        'custo_materiais',
    ];

    protected $appends = ['imagem_url'];

    public function getImagemUrlAttribute()
    {
        return $this->imagem_path ? asset('storage/' . $this->imagem_path) : null;
    }

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

    public function tecnico()
    {
        return $this->belongsTo(User::class, 'tecnico_id');
    }
}
