<?php

namespace App\Filament\Widgets;

use Filament\Widgets\ChartWidget;

class CategoryCosts extends ChartWidget
{
    protected ?string $heading = 'Category Costs';

    protected function getData(): array
    {
        return [
            'datasets' => [
                [
                    'label' => 'Gastos por categoria',
                    'data' => [8500, 6200, 7800, 4500, 3200, 2800],
                    'backgroundColor' => '#f87171',
                ],
            ],
            'labels' => ['Elétrica', 'Hidráulica', 'Climatização', 'Geral', 'Pintura', 'Carpintaria'],
        ];
    }

    protected function getType(): string
    {
        return 'bar';
    }
}
