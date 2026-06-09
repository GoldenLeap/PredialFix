import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../../wayfinder'
/**
* @see \App\Http\Controllers\Api\BudgetController::index
* @see app/Http/Controllers/Api/BudgetController.php:17
* @route '/api/orcamento'
*/
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/orcamento',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\Api\BudgetController::index
* @see app/Http/Controllers/Api/BudgetController.php:17
* @route '/api/orcamento'
*/
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\BudgetController::index
* @see app/Http/Controllers/Api/BudgetController.php:17
* @route '/api/orcamento'
*/
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\Api\BudgetController::index
* @see app/Http/Controllers/Api/BudgetController.php:17
* @route '/api/orcamento'
*/
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

/**
* @see \App\Http\Controllers\Api\BudgetController::index
* @see app/Http/Controllers/Api/BudgetController.php:17
* @route '/api/orcamento'
*/
const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: index.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\Api\BudgetController::index
* @see app/Http/Controllers/Api/BudgetController.php:17
* @route '/api/orcamento'
*/
indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: index.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\Api\BudgetController::index
* @see app/Http/Controllers/Api/BudgetController.php:17
* @route '/api/orcamento'
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

/**
* @see \App\Http\Controllers\Api\BudgetController::store
* @see app/Http/Controllers/Api/BudgetController.php:66
* @route '/api/orcamento'
*/
export const store = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

store.definition = {
    methods: ["post"],
    url: '/api/orcamento',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\Api\BudgetController::store
* @see app/Http/Controllers/Api/BudgetController.php:66
* @route '/api/orcamento'
*/
store.url = (options?: RouteQueryOptions) => {
    return store.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\BudgetController::store
* @see app/Http/Controllers/Api/BudgetController.php:66
* @route '/api/orcamento'
*/
store.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

/**
* @see \App\Http\Controllers\Api\BudgetController::store
* @see app/Http/Controllers/Api/BudgetController.php:66
* @route '/api/orcamento'
*/
const storeForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: store.url(options),
    method: 'post',
})

/**
* @see \App\Http\Controllers\Api\BudgetController::store
* @see app/Http/Controllers/Api/BudgetController.php:66
* @route '/api/orcamento'
*/
storeForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: store.url(options),
    method: 'post',
})

store.form = storeForm

const BudgetController = { index, store }

export default BudgetController