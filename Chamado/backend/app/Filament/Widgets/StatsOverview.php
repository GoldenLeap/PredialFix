<?php

namespace App\Filament\Widgets;

use Filament\Widgets\StatsOverviewWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverview extends StatsOverviewWidget
{
    protected function getStats(): array
    {
        return [
            Stat::make('Chamados abertos', \App\Models\Chamado::where('status', 'Aberto')->count())
                ->description('Chamados aguardando início')
                ->color('danger'),
            Stat::make('Em andamento', \App\Models\Chamado::where('status', 'Em Execução')->count())
                ->description('Chamados sendo atendidos')
                ->color('info'),
            Stat::make('Esperando Materiais', \App\Models\Chamado::where('status', 'Em Análise')->count())
                ->description('Aguardando aprovação ou peças')
                ->color('warning'),
            Stat::make('Finalizados', \App\Models\Chamado::where('status', 'Concluído')->count())
                ->description('Chamados resolvidos')
                ->color('success'),
        ];
    }
}
