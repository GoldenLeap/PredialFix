<?php

namespace App\Filament\Resources\Orcamentos\Schemas;

use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Schemas\Schema;

class OrcamentoForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                \Filament\Forms\Components\Select::make('chamado_id')
                    ->relationship('chamado', 'id')
                    ->getOptionLabelFromRecordUsing(fn ($record) => "Chamado #{$record->id} - {$record->tipo}")
                    ->required()
                    ->searchable()
                    ->preload(),
                TextInput::make('fornecedor')
                    ->required(),
                TextInput::make('valor')
                    ->required()
                    ->numeric()
                    ->prefix('R$'),
                \Filament\Forms\Components\Select::make('status')
                    ->options([
                        'pendente' => 'Pendente',
                        'aprovado' => 'Aprovado',
                        'rejeitado' => 'Rejeitado',
                    ])
                    ->required()
                    ->default('pendente'),
                Textarea::make('descricao_pecas')
                    ->label('Descrição das Peças')
                    ->required()
                    ->columnSpanFull(),
            ])
            ->columns(2);
    }
}
