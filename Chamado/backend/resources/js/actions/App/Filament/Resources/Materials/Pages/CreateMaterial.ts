import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../../../wayfinder'
/**
* @see \App\Filament\Resources\Materials\Pages\CreateMaterial::__invoke
* @see app/Filament/Resources/Materials/Pages/CreateMaterial.php:7
* @route '/admin/materials/create'
*/
const CreateMaterial = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: CreateMaterial.url(options),
    method: 'get',
})

CreateMaterial.definition = {
    methods: ["get","head"],
    url: '/admin/materials/create',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Filament\Resources\Materials\Pages\CreateMaterial::__invoke
* @see app/Filament/Resources/Materials/Pages/CreateMaterial.php:7
* @route '/admin/materials/create'
*/
CreateMaterial.url = (options?: RouteQueryOptions) => {
    return CreateMaterial.definition.url + queryParams(options)
}

/**
* @see \App\Filament\Resources\Materials\Pages\CreateMaterial::__invoke
* @see app/Filament/Resources/Materials/Pages/CreateMaterial.php:7
* @route '/admin/materials/create'
*/
CreateMaterial.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: CreateMaterial.url(options),
    method: 'get',
})

/**
* @see \App\Filament\Resources\Materials\Pages\CreateMaterial::__invoke
* @see app/Filament/Resources/Materials/Pages/CreateMaterial.php:7
* @route '/admin/materials/create'
*/
CreateMaterial.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: CreateMaterial.url(options),
    method: 'head',
})

/**
* @see \App\Filament\Resources\Materials\Pages\CreateMaterial::__invoke
* @see app/Filament/Resources/Materials/Pages/CreateMaterial.php:7
* @route '/admin/materials/create'
*/
const CreateMaterialForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: CreateMaterial.url(options),
    method: 'get',
})

/**
* @see \App\Filament\Resources\Materials\Pages\CreateMaterial::__invoke
* @see app/Filament/Resources/Materials/Pages/CreateMaterial.php:7
* @route '/admin/materials/create'
*/
CreateMaterialForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: CreateMaterial.url(options),
    method: 'get',
})

/**
* @see \App\Filament\Resources\Materials\Pages\CreateMaterial::__invoke
* @see app/Filament/Resources/Materials/Pages/CreateMaterial.php:7
* @route '/admin/materials/create'
*/
CreateMaterialForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: CreateMaterial.url({
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'HEAD',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'get',
})

CreateMaterial.form = CreateMaterialForm

export default CreateMaterial