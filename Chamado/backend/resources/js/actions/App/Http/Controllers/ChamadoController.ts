import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\ChamadoController::index
 * @see app/Http/Controllers/ChamadoController.php:14
 * @route '/chamados'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/chamados',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\ChamadoController::index
 * @see app/Http/Controllers/ChamadoController.php:14
 * @route '/chamados'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\ChamadoController::index
 * @see app/Http/Controllers/ChamadoController.php:14
 * @route '/chamados'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\ChamadoController::index
 * @see app/Http/Controllers/ChamadoController.php:14
 * @route '/chamados'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\ChamadoController::index
 * @see app/Http/Controllers/ChamadoController.php:14
 * @route '/chamados'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\ChamadoController::index
 * @see app/Http/Controllers/ChamadoController.php:14
 * @route '/chamados'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\ChamadoController::index
 * @see app/Http/Controllers/ChamadoController.php:14
 * @route '/chamados'
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
* @see \App\Http\Controllers\ChamadoController::create
 * @see app/Http/Controllers/ChamadoController.php:29
 * @route '/chamados/create'
 */
export const create = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: create.url(options),
    method: 'get',
})

create.definition = {
    methods: ["get","head"],
    url: '/chamados/create',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\ChamadoController::create
 * @see app/Http/Controllers/ChamadoController.php:29
 * @route '/chamados/create'
 */
create.url = (options?: RouteQueryOptions) => {
    return create.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\ChamadoController::create
 * @see app/Http/Controllers/ChamadoController.php:29
 * @route '/chamados/create'
 */
create.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: create.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\ChamadoController::create
 * @see app/Http/Controllers/ChamadoController.php:29
 * @route '/chamados/create'
 */
create.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: create.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\ChamadoController::create
 * @see app/Http/Controllers/ChamadoController.php:29
 * @route '/chamados/create'
 */
    const createForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: create.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\ChamadoController::create
 * @see app/Http/Controllers/ChamadoController.php:29
 * @route '/chamados/create'
 */
        createForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: create.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\ChamadoController::create
 * @see app/Http/Controllers/ChamadoController.php:29
 * @route '/chamados/create'
 */
        createForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: create.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    create.form = createForm
/**
* @see \App\Http\Controllers\ChamadoController::store
 * @see app/Http/Controllers/ChamadoController.php:34
 * @route '/chamados'
 */
export const store = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

store.definition = {
    methods: ["post"],
    url: '/chamados',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\ChamadoController::store
 * @see app/Http/Controllers/ChamadoController.php:34
 * @route '/chamados'
 */
store.url = (options?: RouteQueryOptions) => {
    return store.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\ChamadoController::store
 * @see app/Http/Controllers/ChamadoController.php:34
 * @route '/chamados'
 */
store.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\ChamadoController::store
 * @see app/Http/Controllers/ChamadoController.php:34
 * @route '/chamados'
 */
    const storeForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: store.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\ChamadoController::store
 * @see app/Http/Controllers/ChamadoController.php:34
 * @route '/chamados'
 */
        storeForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: store.url(options),
            method: 'post',
        })
    
    store.form = storeForm
/**
* @see \App\Http\Controllers\ChamadoController::show
 * @see app/Http/Controllers/ChamadoController.php:49
 * @route '/chamados/{chamado}'
 */
export const show = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})

show.definition = {
    methods: ["get","head"],
    url: '/chamados/{chamado}',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\ChamadoController::show
 * @see app/Http/Controllers/ChamadoController.php:49
 * @route '/chamados/{chamado}'
 */
show.url = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions) => {
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

    return show.definition.url
            .replace('{chamado}', parsedArgs.chamado.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\ChamadoController::show
 * @see app/Http/Controllers/ChamadoController.php:49
 * @route '/chamados/{chamado}'
 */
show.get = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\ChamadoController::show
 * @see app/Http/Controllers/ChamadoController.php:49
 * @route '/chamados/{chamado}'
 */
show.head = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: show.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\ChamadoController::show
 * @see app/Http/Controllers/ChamadoController.php:49
 * @route '/chamados/{chamado}'
 */
    const showForm = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: show.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\ChamadoController::show
 * @see app/Http/Controllers/ChamadoController.php:49
 * @route '/chamados/{chamado}'
 */
        showForm.get = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: show.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\ChamadoController::show
 * @see app/Http/Controllers/ChamadoController.php:49
 * @route '/chamados/{chamado}'
 */
        showForm.head = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: show.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    show.form = showForm
/**
* @see \App\Http\Controllers\ChamadoController::edit
 * @see app/Http/Controllers/ChamadoController.php:58
 * @route '/chamados/{chamado}/edit'
 */
export const edit = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: edit.url(args, options),
    method: 'get',
})

edit.definition = {
    methods: ["get","head"],
    url: '/chamados/{chamado}/edit',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\ChamadoController::edit
 * @see app/Http/Controllers/ChamadoController.php:58
 * @route '/chamados/{chamado}/edit'
 */
edit.url = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions) => {
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

    return edit.definition.url
            .replace('{chamado}', parsedArgs.chamado.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\ChamadoController::edit
 * @see app/Http/Controllers/ChamadoController.php:58
 * @route '/chamados/{chamado}/edit'
 */
edit.get = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: edit.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\ChamadoController::edit
 * @see app/Http/Controllers/ChamadoController.php:58
 * @route '/chamados/{chamado}/edit'
 */
edit.head = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: edit.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\ChamadoController::edit
 * @see app/Http/Controllers/ChamadoController.php:58
 * @route '/chamados/{chamado}/edit'
 */
    const editForm = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: edit.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\ChamadoController::edit
 * @see app/Http/Controllers/ChamadoController.php:58
 * @route '/chamados/{chamado}/edit'
 */
        editForm.get = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: edit.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\ChamadoController::edit
 * @see app/Http/Controllers/ChamadoController.php:58
 * @route '/chamados/{chamado}/edit'
 */
        editForm.head = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: edit.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    edit.form = editForm
/**
* @see \App\Http\Controllers\ChamadoController::update
 * @see app/Http/Controllers/ChamadoController.php:66
 * @route '/chamados/{chamado}'
 */
export const update = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(args, options),
    method: 'put',
})

update.definition = {
    methods: ["put","patch"],
    url: '/chamados/{chamado}',
} satisfies RouteDefinition<["put","patch"]>

/**
* @see \App\Http\Controllers\ChamadoController::update
 * @see app/Http/Controllers/ChamadoController.php:66
 * @route '/chamados/{chamado}'
 */
update.url = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions) => {
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

    return update.definition.url
            .replace('{chamado}', parsedArgs.chamado.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\ChamadoController::update
 * @see app/Http/Controllers/ChamadoController.php:66
 * @route '/chamados/{chamado}'
 */
update.put = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(args, options),
    method: 'put',
})
/**
* @see \App\Http\Controllers\ChamadoController::update
 * @see app/Http/Controllers/ChamadoController.php:66
 * @route '/chamados/{chamado}'
 */
update.patch = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteDefinition<'patch'> => ({
    url: update.url(args, options),
    method: 'patch',
})

    /**
* @see \App\Http\Controllers\ChamadoController::update
 * @see app/Http/Controllers/ChamadoController.php:66
 * @route '/chamados/{chamado}'
 */
    const updateForm = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: update.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'PUT',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\ChamadoController::update
 * @see app/Http/Controllers/ChamadoController.php:66
 * @route '/chamados/{chamado}'
 */
        updateForm.put = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: update.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PUT',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
            /**
* @see \App\Http\Controllers\ChamadoController::update
 * @see app/Http/Controllers/ChamadoController.php:66
 * @route '/chamados/{chamado}'
 */
        updateForm.patch = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: update.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PATCH',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    update.form = updateForm
/**
* @see \App\Http\Controllers\ChamadoController::destroy
 * @see app/Http/Controllers/ChamadoController.php:85
 * @route '/chamados/{chamado}'
 */
export const destroy = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: destroy.url(args, options),
    method: 'delete',
})

destroy.definition = {
    methods: ["delete"],
    url: '/chamados/{chamado}',
} satisfies RouteDefinition<["delete"]>

/**
* @see \App\Http\Controllers\ChamadoController::destroy
 * @see app/Http/Controllers/ChamadoController.php:85
 * @route '/chamados/{chamado}'
 */
destroy.url = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions) => {
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

    return destroy.definition.url
            .replace('{chamado}', parsedArgs.chamado.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\ChamadoController::destroy
 * @see app/Http/Controllers/ChamadoController.php:85
 * @route '/chamados/{chamado}'
 */
destroy.delete = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: destroy.url(args, options),
    method: 'delete',
})

    /**
* @see \App\Http\Controllers\ChamadoController::destroy
 * @see app/Http/Controllers/ChamadoController.php:85
 * @route '/chamados/{chamado}'
 */
    const destroyForm = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: destroy.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'DELETE',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\ChamadoController::destroy
 * @see app/Http/Controllers/ChamadoController.php:85
 * @route '/chamados/{chamado}'
 */
        destroyForm.delete = (args: { chamado: number | { id: number } } | [chamado: number | { id: number } ] | number | { id: number }, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: destroy.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'DELETE',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    destroy.form = destroyForm
const ChamadoController = { index, create, store, show, edit, update, destroy }

export default ChamadoController