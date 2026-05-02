import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../../../wayfinder'
/**
* @see \App\Filament\Resources\Orcamentos\Pages\ListOrcamentos::__invoke
* @see app/Filament/Resources/Orcamentos/Pages/ListOrcamentos.php:7
* @route '/admin/orcamentos'
*/
const ListOrcamentos = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: ListOrcamentos.url(options),
    method: 'get',
})

ListOrcamentos.definition = {
    methods: ["get","head"],
    url: '/admin/orcamentos',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Filament\Resources\Orcamentos\Pages\ListOrcamentos::__invoke
* @see app/Filament/Resources/Orcamentos/Pages/ListOrcamentos.php:7
* @route '/admin/orcamentos'
*/
ListOrcamentos.url = (options?: RouteQueryOptions) => {
    return ListOrcamentos.definition.url + queryParams(options)
}

/**
* @see \App\Filament\Resources\Orcamentos\Pages\ListOrcamentos::__invoke
* @see app/Filament/Resources/Orcamentos/Pages/ListOrcamentos.php:7
* @route '/admin/orcamentos'
*/
ListOrcamentos.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: ListOrcamentos.url(options),
    method: 'get',
})

/**
* @see \App\Filament\Resources\Orcamentos\Pages\ListOrcamentos::__invoke
* @see app/Filament/Resources/Orcamentos/Pages/ListOrcamentos.php:7
* @route '/admin/orcamentos'
*/
ListOrcamentos.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: ListOrcamentos.url(options),
    method: 'head',
})

/**
* @see \App\Filament\Resources\Orcamentos\Pages\ListOrcamentos::__invoke
* @see app/Filament/Resources/Orcamentos/Pages/ListOrcamentos.php:7
* @route '/admin/orcamentos'
*/
const ListOrcamentosForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: ListOrcamentos.url(options),
    method: 'get',
})

/**
* @see \App\Filament\Resources\Orcamentos\Pages\ListOrcamentos::__invoke
* @see app/Filament/Resources/Orcamentos/Pages/ListOrcamentos.php:7
* @route '/admin/orcamentos'
*/
ListOrcamentosForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: ListOrcamentos.url(options),
    method: 'get',
})

/**
* @see \App\Filament\Resources\Orcamentos\Pages\ListOrcamentos::__invoke
* @see app/Filament/Resources/Orcamentos/Pages/ListOrcamentos.php:7
* @route '/admin/orcamentos'
*/
ListOrcamentosForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: ListOrcamentos.url({
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'HEAD',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'get',
})

ListOrcamentos.form = ListOrcamentosForm

export default ListOrcamentos