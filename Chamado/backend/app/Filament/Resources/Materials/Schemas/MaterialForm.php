<?php

namespace App\Filament\Resources\Materials\Schemas;

use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class MaterialForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('nome')
                    ->required()
                    ->columnSpanFull(),
                TextInput::make('categoria')
                    ->required(),
                TextInput::make('localizacao')
                    ->required(),
                TextInput::make('quantidade_atual')
                    ->required()
                    ->numeric()
                    ->default(0),
                TextInput::make('quantidade_minima')
                    ->required()
                    ->numeric()
                    ->default(0),
                TextInput::make('unidade')
                    ->required(),
            ])
            ->columns(2);
    }
}
