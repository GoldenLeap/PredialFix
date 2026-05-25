import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\BudgetController::index
 * @see app/Http/Controllers/BudgetController.php:13
 * @route '/orcamento'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/orcamento',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\BudgetController::index
 * @see app/Http/Controllers/BudgetController.php:13
 * @route '/orcamento'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\BudgetController::index
 * @see app/Http/Controllers/BudgetController.php:13
 * @route '/orcamento'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\BudgetController::index
 * @see app/Http/Controllers/BudgetController.php:13
 * @route '/orcamento'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\BudgetController::index
 * @see app/Http/Controllers/BudgetController.php:13
 * @route '/orcamento'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\BudgetController::index
 * @see app/Http/Controllers/BudgetController.php:13
 * @route '/orcamento'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\BudgetController::index
 * @see app/Http/Controllers/BudgetController.php:13
 * @route '/orcamento'
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
* @see \App\Http\Controllers\BudgetController::update
 * @see app/Http/Controllers/BudgetController.php:53
 * @route '/orcamento'
 */
export const update = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: update.url(options),
    method: 'post',
})

update.definition = {
    methods: ["post"],
    url: '/orcamento',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\BudgetController::update
 * @see app/Http/Controllers/BudgetController.php:53
 * @route '/orcamento'
 */
update.url = (options?: RouteQueryOptions) => {
    return update.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\BudgetController::update
 * @see app/Http/Controllers/BudgetController.php:53
 * @route '/orcamento'
 */
update.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: update.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\BudgetController::update
 * @see app/Http/Controllers/BudgetController.php:53
 * @route '/orcamento'
 */
    const updateForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: update.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\BudgetController::update
 * @see app/Http/Controllers/BudgetController.php:53
 * @route '/orcamento'
 */
        updateForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: update.url(options),
            method: 'post',
        })
    
    update.form = updateForm
const BudgetController = { index, update }

export default BudgetController