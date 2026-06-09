import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../../../wayfinder'
/**
* @see \App\Filament\Resources\Chamados\Pages\EditChamado::__invoke
* @see app/Filament/Resources/Chamados/Pages/EditChamado.php:7
* @route '/admin/chamados/{record}/edit'
*/
const EditChamado = (args: { record: string | number } | [record: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: EditChamado.url(args, options),
    method: 'get',
})

EditChamado.definition = {
    methods: ["get","head"],
    url: '/admin/chamados/{record}/edit',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Filament\Resources\Chamados\Pages\EditChamado::__invoke
* @see app/Filament/Resources/Chamados/Pages/EditChamado.php:7
* @route '/admin/chamados/{record}/edit'
*/
EditChamado.url = (args: { record: string | number } | [record: string | number ] | string | number, options?: RouteQueryOptions) => {
    if (typeof args === 'string' || typeof args === 'number') {
        args = { record: args }
    }

    if (Array.isArray(args)) {
        args = {
            record: args[0],
        }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
        record: args.record,
    }

    return EditChamado.definition.url
            .replace('{record}', parsedArgs.record.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Filament\Resources\Chamados\Pages\EditChamado::__invoke
* @see app/Filament/Resources/Chamados/Pages/EditChamado.php:7
* @route '/admin/chamados/{record}/edit'
*/
EditChamado.get = (args: { record: string | number } | [record: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: EditChamado.url(args, options),
    method: 'get',
})

/**
* @see \App\Filament\Resources\Chamados\Pages\EditChamado::__invoke
* @see app/Filament/Resources/Chamados/Pages/EditChamado.php:7
* @route '/admin/chamados/{record}/edit'
*/
EditChamado.head = (args: { record: string | number } | [record: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: EditChamado.url(args, options),
    method: 'head',
})

/**
* @see \App\Filament\Resources\Chamados\Pages\EditChamado::__invoke
* @see app/Filament/Resources/Chamados/Pages/EditChamado.php:7
* @route '/admin/chamados/{record}/edit'
*/
const EditChamadoForm = (args: { record: string | number } | [record: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: EditChamado.url(args, options),
    method: 'get',
})

/**
* @see \App\Filament\Resources\Chamados\Pages\EditChamado::__invoke
* @see app/Filament/Resources/Chamados/Pages/EditChamado.php:7
* @route '/admin/chamados/{record}/edit'
*/
EditChamadoForm.get = (args: { record: string | number } | [record: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: EditChamado.url(args, options),
    method: 'get',
})

/**
* @see \App\Filament\Resources\Chamados\Pages\EditChamado::__invoke
* @see app/Filament/Resources/Chamados/Pages/EditChamado.php:7
* @route '/admin/chamados/{record}/edit'
*/
EditChamadoForm.head = (args: { record: string | number } | [record: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: EditChamado.url(args, {
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'HEAD',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'get',
})

EditChamado.form = EditChamadoForm

export default EditChamado