import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../../../wayfinder'
/**
* @see \App\Filament\Resources\Materials\Pages\ListMaterials::__invoke
 * @see app/Filament/Resources/Materials/Pages/ListMaterials.php:7
 * @route '/admin/materials'
 */
const ListMaterials = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: ListMaterials.url(options),
    method: 'get',
})

ListMaterials.definition = {
    methods: ["get","head"],
    url: '/admin/materials',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Filament\Resources\Materials\Pages\ListMaterials::__invoke
 * @see app/Filament/Resources/Materials/Pages/ListMaterials.php:7
 * @route '/admin/materials'
 */
ListMaterials.url = (options?: RouteQueryOptions) => {
    return ListMaterials.definition.url + queryParams(options)
}

/**
* @see \App\Filament\Resources\Materials\Pages\ListMaterials::__invoke
 * @see app/Filament/Resources/Materials/Pages/ListMaterials.php:7
 * @route '/admin/materials'
 */
ListMaterials.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: ListMaterials.url(options),
    method: 'get',
})
/**
* @see \App\Filament\Resources\Materials\Pages\ListMaterials::__invoke
 * @see app/Filament/Resources/Materials/Pages/ListMaterials.php:7
 * @route '/admin/materials'
 */
ListMaterials.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: ListMaterials.url(options),
    method: 'head',
})

    /**
* @see \App\Filament\Resources\Materials\Pages\ListMaterials::__invoke
 * @see app/Filament/Resources/Materials/Pages/ListMaterials.php:7
 * @route '/admin/materials'
 */
    const ListMaterialsForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: ListMaterials.url(options),
        method: 'get',
    })

            /**
* @see \App\Filament\Resources\Materials\Pages\ListMaterials::__invoke
 * @see app/Filament/Resources/Materials/Pages/ListMaterials.php:7
 * @route '/admin/materials'
 */
        ListMaterialsForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: ListMaterials.url(options),
            method: 'get',
        })
            /**
* @see \App\Filament\Resources\Materials\Pages\ListMaterials::__invoke
 * @see app/Filament/Resources/Materials/Pages/ListMaterials.php:7
 * @route '/admin/materials'
 */
        ListMaterialsForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: ListMaterials.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    ListMaterials.form = ListMaterialsForm
export default ListMaterials