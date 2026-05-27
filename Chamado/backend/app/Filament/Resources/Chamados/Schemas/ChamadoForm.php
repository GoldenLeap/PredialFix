<?php

namespace App\Filament\Resources\Chamados\Schemas;

use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Schemas\Schema;

class ChamadoForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                \Filament\Forms\Components\Select::make('usuario_id')
                    ->relationship('user', 'name')
                    ->required()
                    ->searchable()
                    ->preload(),
                \Filament\Forms\Components\Select::make('tipo')
                    ->options([
                        'Elétrica' => 'Elétrica',
                        'Hidráulica' => 'Hidráulica',
                        'Infraestrutura' => 'Infraestrutura',
                        'Outros' => 'Outros',
                    ])
                    ->required(),
                TextInput::make('local')
                    ->required(),
                TextInput::make('bloco')
                    ->label('Bloco')
                    ->placeholder('Ex: Bloco A, Bloco B...'),
                \Filament\Forms\Components\Select::make('prioridade')
                    ->options([
                        'Baixa' => 'Baixa',
                        'Média' => 'Média',
                        'Alta' => 'Alta',
                    ])
                    ->required(),
                \Filament\Forms\Components\Select::make('status')
                    ->options([
                        'Aberto' => 'Aberto',
                        'Em Análise' => 'Em Análise',
                        'Em Execução' => 'Em Execução',
                        'Concluído' => 'Concluído',
                    ])
                    ->required()
                    ->default('Aberto'),
                \Filament\Forms\Components\Toggle::make('patrimonio_sim')
                    ->label('É Patrimônio?')
                    ->default(false),
                TextInput::make('numero_patrimonio')
                    ->label('Número do Patrimônio')
                    ->placeholder('Digite o número do patrimônio')
                    ->visible(fn ($get) => $get('patrimonio_sim') === true),
                Textarea::make('descricao')
                    ->required()
                    ->columnSpanFull(),
            ])
            ->columns(2);
    }
}
