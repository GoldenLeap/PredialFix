import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../../../wayfinder'
/**
* @see \App\Filament\Resources\Orcamentos\Pages\CreateOrcamento::__invoke
 * @see app/Filament/Resources/Orcamentos/Pages/CreateOrcamento.php:7
 * @route '/admin/orcamentos/create'
 */
const CreateOrcamento = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: CreateOrcamento.url(options),
    method: 'get',
})

CreateOrcamento.definition = {
    methods: ["get","head"],
    url: '/admin/orcamentos/create',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Filament\Resources\Orcamentos\Pages\CreateOrcamento::__invoke
 * @see app/Filament/Resources/Orcamentos/Pages/CreateOrcamento.php:7
 * @route '/admin/orcamentos/create'
 */
CreateOrcamento.url = (options?: RouteQueryOptions) => {
    return CreateOrcamento.definition.url + queryParams(options)
}

/**
* @see \App\Filament\Resources\Orcamentos\Pages\CreateOrcamento::__invoke
 * @see app/Filament/Resources/Orcamentos/Pages/CreateOrcamento.php:7
 * @route '/admin/orcamentos/create'
 */
CreateOrcamento.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: CreateOrcamento.url(options),
    method: 'get',
})
/**
* @see \App\Filament\Resources\Orcamentos\Pages\CreateOrcamento::__invoke
 * @see app/Filament/Resources/Orcamentos/Pages/CreateOrcamento.php:7
 * @route '/admin/orcamentos/create'
 */
CreateOrcamento.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: CreateOrcamento.url(options),
    method: 'head',
})

    /**
* @see \App\Filament\Resources\Orcamentos\Pages\CreateOrcamento::__invoke
 * @see app/Filament/Resources/Orcamentos/Pages/CreateOrcamento.php:7
 * @route '/admin/orcamentos/create'
 */
    const CreateOrcamentoForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: CreateOrcamento.url(options),
        method: 'get',
    })

            /**
* @see \App\Filament\Resources\Orcamentos\Pages\CreateOrcamento::__invoke
 * @see app/Filament/Resources/Orcamentos/Pages/CreateOrcamento.php:7
 * @route '/admin/orcamentos/create'
 */
        CreateOrcamentoForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: CreateOrcamento.url(options),
            method: 'get',
        })
            /**
* @see \App\Filament\Resources\Orcamentos\Pages\CreateOrcamento::__invoke
 * @see app/Filament/Resources/Orcamentos/Pages/CreateOrcamento.php:7
 * @route '/admin/orcamentos/create'
 */
        CreateOrcamentoForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: CreateOrcamento.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    CreateOrcamento.form = CreateOrcamentoForm
export default CreateOrcamento