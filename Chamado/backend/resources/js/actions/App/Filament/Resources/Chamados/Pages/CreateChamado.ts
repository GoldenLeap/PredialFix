import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../../../wayfinder'
/**
* @see \App\Filament\Resources\Chamados\Pages\CreateChamado::__invoke
 * @see app/Filament/Resources/Chamados/Pages/CreateChamado.php:7
 * @route '/admin/chamados/create'
 */
const CreateChamado = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: CreateChamado.url(options),
    method: 'get',
})

CreateChamado.definition = {
    methods: ["get","head"],
    url: '/admin/chamados/create',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Filament\Resources\Chamados\Pages\CreateChamado::__invoke
 * @see app/Filament/Resources/Chamados/Pages/CreateChamado.php:7
 * @route '/admin/chamados/create'
 */
CreateChamado.url = (options?: RouteQueryOptions) => {
    return CreateChamado.definition.url + queryParams(options)
}

/**
* @see \App\Filament\Resources\Chamados\Pages\CreateChamado::__invoke
 * @see app/Filament/Resources/Chamados/Pages/CreateChamado.php:7
 * @route '/admin/chamados/create'
 */
CreateChamado.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: CreateChamado.url(options),
    method: 'get',
})
/**
* @see \App\Filament\Resources\Chamados\Pages\CreateChamado::__invoke
 * @see app/Filament/Resources/Chamados/Pages/CreateChamado.php:7
 * @route '/admin/chamados/create'
 */
CreateChamado.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: CreateChamado.url(options),
    method: 'head',
})

    /**
* @see \App\Filament\Resources\Chamados\Pages\CreateChamado::__invoke
 * @see app/Filament/Resources/Chamados/Pages/CreateChamado.php:7
 * @route '/admin/chamados/create'
 */
    const CreateChamadoForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: CreateChamado.url(options),
        method: 'get',
    })

            /**
* @see \App\Filament\Resources\Chamados\Pages\CreateChamado::__invoke
 * @see app/Filament/Resources/Chamados/Pages/CreateChamado.php:7
 * @route '/admin/chamados/create'
 */
        CreateChamadoForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: CreateChamado.url(options),
            method: 'get',
        })
            /**
* @see \App\Filament\Resources\Chamados\Pages\CreateChamado::__invoke
 * @see app/Filament/Resources/Chamados/Pages/CreateChamado.php:7
 * @route '/admin/chamados/create'
 */
        CreateChamadoForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: CreateChamado.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    CreateChamado.form = CreateChamadoForm
export default CreateChamado