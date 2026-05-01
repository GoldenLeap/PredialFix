<?php

namespace App\Filament\Resources\Chamados;

use App\Filament\Resources\Chamados\Pages\CreateChamado;
use App\Filament\Resources\Chamados\Pages\EditChamado;
use App\Filament\Resources\Chamados\Pages\ListChamados;
use App\Filament\Resources\Chamados\Schemas\ChamadoForm;
use App\Filament\Resources\Chamados\Tables\ChamadosTable;
use App\Models\Chamado;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class ChamadoResource extends Resource
{
    protected static ?string $model = Chamado::class;

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedRectangleStack;

    protected static ?string $recordTitleAttribute = 'id';

    public static function form(Schema $schema): Schema
    {
        return ChamadoForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return ChamadosTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListChamados::route('/'),
            'create' => CreateChamado::route('/create'),
            'edit' => EditChamado::route('/{record}/edit'),
        ];
    }
}
