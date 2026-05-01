<x-filament-widgets::widget>
    <x-filament::section>
        <div class="flex items-center gap-x-3">
            <h2 class="text-xl font-bold tracking-tight">Visão geral financeira - Março</h2>
        </div>

        <div class="mt-6 grid grid-cols-1 gap-6 sm:grid-cols-3">
            <div>
                <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Orçamento total</p>
                <p class="text-2xl font-bold">R$ 50.000</p>
            </div>
            <div>
                <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Quantidade gasta</p>
                <p class="text-2xl font-bold text-red-600">R$ 33.000</p>
            </div>
            <div>
                <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Orçamento restante</p>
                <p class="text-2xl font-bold text-green-600">R$ 17.000</p>
            </div>
        </div>

        <div class="mt-8">
            <div class="flex items-center justify-between">
                <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Uso do orçamento</p>
                <p class="text-sm font-medium text-gray-500 dark:text-gray-400">66.0%</p>
            </div>
            <div class="mt-2 h-4 w-full overflow-hidden rounded-full bg-gray-200 dark:bg-gray-700">
                <div class="h-full bg-red-400" style="width: 66%"></div>
            </div>
        </div>
    </x-filament::section>
</x-filament-widgets::widget>
