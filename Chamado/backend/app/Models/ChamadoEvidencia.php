<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ChamadoEvidencia extends Model
{
    protected $table = 'chamado_evidencias';

    protected $fillable = [
        'chamado_id',
        'caminho_arquivo',
        'tipo',
    ];

    protected $appends = ['url'];

    public function getUrlAttribute()
    {
        return $this->caminho_arquivo ? asset('storage/' . $this->caminho_arquivo) : null;
    }

    public function chamado()
    {
        return $this->belongsTo(Chamado::class);
    }}
