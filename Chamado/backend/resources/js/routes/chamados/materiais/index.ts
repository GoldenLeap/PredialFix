import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../wayfinder'
/**
* @see \App\Http\Controllers\ChamadoController::add
* @see app/Http/Controllers/ChamadoController.php:126
* @route '/chamados/{chamado}/materiais'
*/
export const add = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: add.url(args, options),
    method: 'post',
})

add.definition = {
    methods: ["post"],
    url: '/chamados/{chamado}/materiais',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\ChamadoController::add
* @see app/Http/Controllers/ChamadoController.php:126
* @route '/chamados/{chamado}/materiais'
*/
add.url = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions) => {
    if (typeof args === 'string' || typeof args === 'number') {
        args = { chamado: args }
    }

    if (typeof args === 'object' && !Array.isArray(args) && 'id' in args) {
        args = { chamado: args.id }
    }

    if (Array.isArray(args)) {
        args = {
            chamado: args[0],
        }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
        chamado: typeof args.chamado === 'object'
        ? args.chamado.id
        : args.chamado,
    }

    return add.definition.url
            .replace('{chamado}', parsedArgs.chamado.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\ChamadoController::add
* @see app/Http/Controllers/ChamadoController.php:126
* @route '/chamados/{chamado}/materiais'
*/
add.post = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: add.url(args, options),
    method: 'post',
})

/**
* @see \App\Http\Controllers\ChamadoController::add
* @see app/Http/Controllers/ChamadoController.php:126
* @route '/chamados/{chamado}/materiais'
*/
const addForm = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: add.url(args, options),
    method: 'post',
})

/**
* @see \App\Http\Controllers\ChamadoController::add
* @see app/Http/Controllers/ChamadoController.php:126
* @route '/chamados/{chamado}/materiais'
*/
addForm.post = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: add.url(args, options),
    method: 'post',
})

add.form = addForm

/**
* @see \App\Http\Controllers\ChamadoController::remove
* @see app/Http/Controllers/ChamadoController.php:160
* @route '/chamados/{chamado}/materiais/{material}'
*/
export const remove = (args: { chamado: number | { id: number }, material: number | { id: number } } | [chamado: number | { id: number }, material: number | { id: number } ], options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: remove.url(args, options),
    method: 'delete',
})

remove.definition = {
    methods: ["delete"],
    url: '/chamados/{chamado}/materiais/{material}',
} satisfies RouteDefinition<["delete"]>

/**
* @see \App\Http\Controllers\ChamadoController::remove
* @see app/Http/Controllers/ChamadoController.php:160
* @route '/chamados/{chamado}/materiais/{material}'
*/
remove.url = (args: { chamado: number | { id: number }, material: number | { id: number } } | [chamado: number | { id: number }, material: number | { id: number } ], options?: RouteQueryOptions) => {
    if (Array.isArray(args)) {
        args = {
            chamado: args[0],
            material: args[1],
        }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
        chamado: typeof args.chamado === 'object'
        ? args.chamado.id
        : args.chamado,
        material: typeof args.material === 'object'
        ? args.material.id
        : args.material,
    }

    return remove.definition.url
            .replace('{chamado}', parsedArgs.chamado.toString())
            .replace('{material}', parsedArgs.material.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\ChamadoController::remove
* @see app/Http/Controllers/ChamadoController.php:160
* @route '/chamados/{chamado}/materiais/{material}'
*/
remove.delete = (args: { chamado: number | { id: number }, material: number | { id: number } } | [chamado: number | { id: number }, material: number | { id: number } ], options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: remove.url(args, options),
    method: 'delete',
})

/**
* @see \App\Http\Controllers\ChamadoController::remove
* @see app/Http/Controllers/ChamadoController.php:160
* @route '/chamados/{chamado}/materiais/{material}'
*/
const removeForm = (args: { chamado: number | { id: number }, material: number | { id: number } } | [chamado: number | { id: number }, material: number | { id: number } ], options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: remove.url(args, {
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'DELETE',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'post',
})

/**
* @see \App\Http\Controllers\ChamadoController::remove
* @see app/Http/Controllers/ChamadoController.php:160
* @route '/chamados/{chamado}/materiais/{material}'
*/
removeForm.delete = (args: { chamado: number | { id: number }, material: number | { id: number } } | [chamado: number | { id: number }, material: number | { id: number } ], options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: remove.url(args, {
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'DELETE',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'post',
})

remove.form = removeForm

const materiais = {
    add: Object.assign(add, add),
    remove: Object.assign(remove, remove),
}

export default materiais