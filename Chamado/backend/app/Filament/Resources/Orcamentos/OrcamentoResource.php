<?php

namespace App\Filament\Resources\Orcamentos;

use App\Filament\Resources\Orcamentos\Pages\CreateOrcamento;
use App\Filament\Resources\Orcamentos\Pages\EditOrcamento;
use App\Filament\Resources\Orcamentos\Pages\ListOrcamentos;
use App\Filament\Resources\Orcamentos\Schemas\OrcamentoForm;
use App\Filament\Resources\Orcamentos\Tables\OrcamentosTable;
use App\Models\Orcamento;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class OrcamentoResource extends Resource
{
    protected static ?string $model = Orcamento::class;

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedRectangleStack;

    protected static ?string $recordTitleAttribute = 'id';

    public static function form(Schema $schema): Schema
    {
        return OrcamentoForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return OrcamentosTable::configure($table);
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
            'index' => ListOrcamentos::route('/'),
            'create' => CreateOrcamento::route('/create'),
            'edit' => EditOrcamento::route('/{record}/edit'),
        ];
    }
}
