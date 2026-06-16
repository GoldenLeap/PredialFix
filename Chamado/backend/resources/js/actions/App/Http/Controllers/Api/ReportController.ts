import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../../wayfinder'
/**
* @see \App\Http\Controllers\Api\ReportController::index
* @see app/Http/Controllers/Api/ReportController.php:24
* @route '/api/relatorios'
*/
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/relatorios',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\Api\ReportController::index
* @see app/Http/Controllers/Api/ReportController.php:24
* @route '/api/relatorios'
*/
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\ReportController::index
* @see app/Http/Controllers/Api/ReportController.php:24
* @route '/api/relatorios'
*/
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\Api\ReportController::index
* @see app/Http/Controllers/Api/ReportController.php:24
* @route '/api/relatorios'
*/
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

/**
* @see \App\Http\Controllers\Api\ReportController::index
* @see app/Http/Controllers/Api/ReportController.php:24
* @route '/api/relatorios'
*/
const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: index.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\Api\ReportController::index
* @see app/Http/Controllers/Api/ReportController.php:24
* @route '/api/relatorios'
*/
indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: index.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\Api\ReportController::index
* @see app/Http/Controllers/Api/ReportController.php:24
* @route '/api/relatorios'
*/
indexForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: index.url({
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'HEAD',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'get',
})

index.form = indexForm

const ReportController = { index }

export default ReportController