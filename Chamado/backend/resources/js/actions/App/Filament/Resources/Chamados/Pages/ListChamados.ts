import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../../../wayfinder'
/**
* @see \App\Filament\Resources\Chamados\Pages\ListChamados::__invoke
* @see app/Filament/Resources/Chamados/Pages/ListChamados.php:7
* @route '/admin/chamados'
*/
const ListChamados = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: ListChamados.url(options),
    method: 'get',
})

ListChamados.definition = {
    methods: ["get","head"],
    url: '/admin/chamados',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Filament\Resources\Chamados\Pages\ListChamados::__invoke
* @see app/Filament/Resources/Chamados/Pages/ListChamados.php:7
* @route '/admin/chamados'
*/
ListChamados.url = (options?: RouteQueryOptions) => {
    return ListChamados.definition.url + queryParams(options)
}

/**
* @see \App\Filament\Resources\Chamados\Pages\ListChamados::__invoke
* @see app/Filament/Resources/Chamados/Pages/ListChamados.php:7
* @route '/admin/chamados'
*/
ListChamados.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: ListChamados.url(options),
    method: 'get',
})

/**
* @see \App\Filament\Resources\Chamados\Pages\ListChamados::__invoke
* @see app/Filament/Resources/Chamados/Pages/ListChamados.php:7
* @route '/admin/chamados'
*/
ListChamados.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: ListChamados.url(options),
    method: 'head',
})

/**
* @see \App\Filament\Resources\Chamados\Pages\ListChamados::__invoke
* @see app/Filament/Resources/Chamados/Pages/ListChamados.php:7
* @route '/admin/chamados'
*/
const ListChamadosForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: ListChamados.url(options),
    method: 'get',
})

/**
* @see \App\Filament\Resources\Chamados\Pages\ListChamados::__invoke
* @see app/Filament/Resources/Chamados/Pages/ListChamados.php:7
* @route '/admin/chamados'
*/
ListChamadosForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: ListChamados.url(options),
    method: 'get',
})

/**
* @see \App\Filament\Resources\Chamados\Pages\ListChamados::__invoke
* @see app/Filament/Resources/Chamados/Pages/ListChamados.php:7
* @route '/admin/chamados'
*/
ListChamadosForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: ListChamados.url({
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'HEAD',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'get',
})

ListChamados.form = ListChamadosForm

export default ListChamados