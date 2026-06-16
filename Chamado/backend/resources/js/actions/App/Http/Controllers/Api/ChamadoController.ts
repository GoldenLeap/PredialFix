import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../../wayfinder'
/**
* @see \App\Http\Controllers\Api\ChamadoController::index
 * @see app/Http/Controllers/Api/ChamadoController.php:33
 * @route '/api/chamados'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/chamados',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\Api\ChamadoController::index
 * @see app/Http/Controllers/Api/ChamadoController.php:33
 * @route '/api/chamados'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\ChamadoController::index
 * @see app/Http/Controllers/Api/ChamadoController.php:33
 * @route '/api/chamados'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\Api\ChamadoController::index
 * @see app/Http/Controllers/Api/ChamadoController.php:33
 * @route '/api/chamados'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\Api\ChamadoController::index
 * @see app/Http/Controllers/Api/ChamadoController.php:33
 * @route '/api/chamados'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\Api\ChamadoController::index
 * @see app/Http/Controllers/Api/ChamadoController.php:33
 * @route '/api/chamados'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\Api\ChamadoController::index
 * @see app/Http/Controllers/Api/ChamadoController.php:33
 * @route '/api/chamados'
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
* @see \App\Http\Controllers\Api\ChamadoController::store
 * @see app/Http/Controllers/Api/ChamadoController.php:99
 * @route '/api/chamados'
 */
export const store = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

store.definition = {
    methods: ["post"],
    url: '/api/chamados',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\Api\ChamadoController::store
 * @see app/Http/Controllers/Api/ChamadoController.php:99
 * @route '/api/chamados'
 */
store.url = (options?: RouteQueryOptions) => {
    return store.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\ChamadoController::store
 * @see app/Http/Controllers/Api/ChamadoController.php:99
 * @route '/api/chamados'
 */
store.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\Api\ChamadoController::store
 * @see app/Http/Controllers/Api/ChamadoController.php:99
 * @route '/api/chamados'
 */
    const storeForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: store.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\Api\ChamadoController::store
 * @see app/Http/Controllers/Api/ChamadoController.php:99
 * @route '/api/chamados'
 */
        storeForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: store.url(options),
            method: 'post',
        })
    
    store.form = storeForm
/**
* @see \App\Http\Controllers\Api\ChamadoController::historicoUnidade
 * @see app/Http/Controllers/Api/ChamadoController.php:288
 * @route '/api/chamados/historico-unidade'
 */
export const historicoUnidade = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: historicoUnidade.url(options),
    method: 'get',
})

historicoUnidade.definition = {
    methods: ["get","head"],
    url: '/api/chamados/historico-unidade',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\Api\ChamadoController::historicoUnidade
 * @see app/Http/Controllers/Api/ChamadoController.php:288
 * @route '/api/chamados/historico-unidade'
 */
historicoUnidade.url = (options?: RouteQueryOptions) => {
    return historicoUnidade.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\ChamadoController::historicoUnidade
 * @see app/Http/Controllers/Api/ChamadoController.php:288
 * @route '/api/chamados/historico-unidade'
 */
historicoUnidade.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: historicoUnidade.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\Api\ChamadoController::historicoUnidade
 * @see app/Http/Controllers/Api/ChamadoController.php:288
 * @route '/api/chamados/historico-unidade'
 */
historicoUnidade.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: historicoUnidade.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\Api\ChamadoController::historicoUnidade
 * @see app/Http/Controllers/Api/ChamadoController.php:288
 * @route '/api/chamados/historico-unidade'
 */
    const historicoUnidadeForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: historicoUnidade.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\Api\ChamadoController::historicoUnidade
 * @see app/Http/Controllers/Api/ChamadoController.php:288
 * @route '/api/chamados/historico-unidade'
 */
        historicoUnidadeForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: historicoUnidade.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\Api\ChamadoController::historicoUnidade
 * @see app/Http/Controllers/Api/ChamadoController.php:288
 * @route '/api/chamados/historico-unidade'
 */
        historicoUnidadeForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: historicoUnidade.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    historicoUnidade.form = historicoUnidadeForm
/**
* @see \App\Http\Controllers\Api\ChamadoController::show
 * @see app/Http/Controllers/Api/ChamadoController.php:176
 * @route '/api/chamados/{id}'
 */
export const show = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})

show.definition = {
    methods: ["get","head"],
    url: '/api/chamados/{id}',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\Api\ChamadoController::show
 * @see app/Http/Controllers/Api/ChamadoController.php:176
 * @route '/api/chamados/{id}'
 */
show.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
    if (typeof args === 'string' || typeof args === 'number') {
        args = { id: args }
    }

    
    if (Array.isArray(args)) {
        args = {
                    id: args[0],
                }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
                        id: args.id,
                }

    return show.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\ChamadoController::show
 * @see app/Http/Controllers/Api/ChamadoController.php:176
 * @route '/api/chamados/{id}'
 */
show.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\Api\ChamadoController::show
 * @see app/Http/Controllers/Api/ChamadoController.php:176
 * @route '/api/chamados/{id}'
 */
show.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: show.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\Api\ChamadoController::show
 * @see app/Http/Controllers/Api/ChamadoController.php:176
 * @route '/api/chamados/{id}'
 */
    const showForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: show.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\Api\ChamadoController::show
 * @see app/Http/Controllers/Api/ChamadoController.php:176
 * @route '/api/chamados/{id}'
 */
        showForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: show.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\Api\ChamadoController::show
 * @see app/Http/Controllers/Api/ChamadoController.php:176
 * @route '/api/chamados/{id}'
 */
        showForm.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
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
* @see \App\Http\Controllers\Api\ChamadoController::adicionarMaterial
 * @see app/Http/Controllers/Api/ChamadoController.php:338
 * @route '/api/chamados/{id}/materiais'
 */
export const adicionarMaterial = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: adicionarMaterial.url(args, options),
    method: 'post',
})

adicionarMaterial.definition = {
    methods: ["post"],
    url: '/api/chamados/{id}/materiais',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\Api\ChamadoController::adicionarMaterial
 * @see app/Http/Controllers/Api/ChamadoController.php:338
 * @route '/api/chamados/{id}/materiais'
 */
adicionarMaterial.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
    if (typeof args === 'string' || typeof args === 'number') {
        args = { id: args }
    }

    
    if (Array.isArray(args)) {
        args = {
                    id: args[0],
                }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
                        id: args.id,
                }

    return adicionarMaterial.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\ChamadoController::adicionarMaterial
 * @see app/Http/Controllers/Api/ChamadoController.php:338
 * @route '/api/chamados/{id}/materiais'
 */
adicionarMaterial.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: adicionarMaterial.url(args, options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\Api\ChamadoController::adicionarMaterial
 * @see app/Http/Controllers/Api/ChamadoController.php:338
 * @route '/api/chamados/{id}/materiais'
 */
    const adicionarMaterialForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: adicionarMaterial.url(args, options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\Api\ChamadoController::adicionarMaterial
 * @see app/Http/Controllers/Api/ChamadoController.php:338
 * @route '/api/chamados/{id}/materiais'
 */
        adicionarMaterialForm.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: adicionarMaterial.url(args, options),
            method: 'post',
        })
    
    adicionarMaterial.form = adicionarMaterialForm
/**
* @see \App\Http\Controllers\Api\ChamadoController::solicitarMaterial
 * @see app/Http/Controllers/Api/ChamadoController.php:403
 * @route '/api/chamados/{id}/solicitar-material'
 */
export const solicitarMaterial = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: solicitarMaterial.url(args, options),
    method: 'post',
})

solicitarMaterial.definition = {
    methods: ["post"],
    url: '/api/chamados/{id}/solicitar-material',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\Api\ChamadoController::solicitarMaterial
 * @see app/Http/Controllers/Api/ChamadoController.php:403
 * @route '/api/chamados/{id}/solicitar-material'
 */
solicitarMaterial.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
    if (typeof args === 'string' || typeof args === 'number') {
        args = { id: args }
    }

    
    if (Array.isArray(args)) {
        args = {
                    id: args[0],
                }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
                        id: args.id,
                }

    return solicitarMaterial.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\ChamadoController::solicitarMaterial
 * @see app/Http/Controllers/Api/ChamadoController.php:403
 * @route '/api/chamados/{id}/solicitar-material'
 */
solicitarMaterial.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: solicitarMaterial.url(args, options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\Api\ChamadoController::solicitarMaterial
 * @see app/Http/Controllers/Api/ChamadoController.php:403
 * @route '/api/chamados/{id}/solicitar-material'
 */
    const solicitarMaterialForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: solicitarMaterial.url(args, options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\Api\ChamadoController::solicitarMaterial
 * @see app/Http/Controllers/Api/ChamadoController.php:403
 * @route '/api/chamados/{id}/solicitar-material'
 */
        solicitarMaterialForm.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: solicitarMaterial.url(args, options),
            method: 'post',
        })
    
    solicitarMaterial.form = solicitarMaterialForm
/**
* @see \App\Http\Controllers\Api\ChamadoController::adicionarEvidencias
 * @see app/Http/Controllers/Api/ChamadoController.php:455
 * @route '/api/chamados/{id}/evidencias'
 */
export const adicionarEvidencias = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: adicionarEvidencias.url(args, options),
    method: 'post',
})

adicionarEvidencias.definition = {
    methods: ["post"],
    url: '/api/chamados/{id}/evidencias',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\Api\ChamadoController::adicionarEvidencias
 * @see app/Http/Controllers/Api/ChamadoController.php:455
 * @route '/api/chamados/{id}/evidencias'
 */
adicionarEvidencias.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
    if (typeof args === 'string' || typeof args === 'number') {
        args = { id: args }
    }

    
    if (Array.isArray(args)) {
        args = {
                    id: args[0],
                }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
                        id: args.id,
                }

    return adicionarEvidencias.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\ChamadoController::adicionarEvidencias
 * @see app/Http/Controllers/Api/ChamadoController.php:455
 * @route '/api/chamados/{id}/evidencias'
 */
adicionarEvidencias.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: adicionarEvidencias.url(args, options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\Api\ChamadoController::adicionarEvidencias
 * @see app/Http/Controllers/Api/ChamadoController.php:455
 * @route '/api/chamados/{id}/evidencias'
 */
    const adicionarEvidenciasForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: adicionarEvidencias.url(args, options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\Api\ChamadoController::adicionarEvidencias
 * @see app/Http/Controllers/Api/ChamadoController.php:455
 * @route '/api/chamados/{id}/evidencias'
 */
        adicionarEvidenciasForm.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: adicionarEvidencias.url(args, options),
            method: 'post',
        })
    
    adicionarEvidencias.form = adicionarEvidenciasForm
/**
* @see \App\Http\Controllers\Api\ChamadoController::update
 * @see app/Http/Controllers/Api/ChamadoController.php:200
 * @route '/api/chamados/{id}'
 */
export const update = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(args, options),
    method: 'put',
})

update.definition = {
    methods: ["put"],
    url: '/api/chamados/{id}',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\Api\ChamadoController::update
 * @see app/Http/Controllers/Api/ChamadoController.php:200
 * @route '/api/chamados/{id}'
 */
update.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
    if (typeof args === 'string' || typeof args === 'number') {
        args = { id: args }
    }

    
    if (Array.isArray(args)) {
        args = {
                    id: args[0],
                }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
                        id: args.id,
                }

    return update.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\ChamadoController::update
 * @see app/Http/Controllers/Api/ChamadoController.php:200
 * @route '/api/chamados/{id}'
 */
update.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\Api\ChamadoController::update
 * @see app/Http/Controllers/Api/ChamadoController.php:200
 * @route '/api/chamados/{id}'
 */
    const updateForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: update.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'PUT',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\Api\ChamadoController::update
 * @see app/Http/Controllers/Api/ChamadoController.php:200
 * @route '/api/chamados/{id}'
 */
        updateForm.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: update.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PUT',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    update.form = updateForm
/**
* @see \App\Http\Controllers\Api\ChamadoController::destroy
 * @see app/Http/Controllers/Api/ChamadoController.php:316
 * @route '/api/chamados/{id}'
 */
export const destroy = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: destroy.url(args, options),
    method: 'delete',
})

destroy.definition = {
    methods: ["delete"],
    url: '/api/chamados/{id}',
} satisfies RouteDefinition<["delete"]>

/**
* @see \App\Http\Controllers\Api\ChamadoController::destroy
 * @see app/Http/Controllers/Api/ChamadoController.php:316
 * @route '/api/chamados/{id}'
 */
destroy.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
    if (typeof args === 'string' || typeof args === 'number') {
        args = { id: args }
    }

    
    if (Array.isArray(args)) {
        args = {
                    id: args[0],
                }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
                        id: args.id,
                }

    return destroy.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\ChamadoController::destroy
 * @see app/Http/Controllers/Api/ChamadoController.php:316
 * @route '/api/chamados/{id}'
 */
destroy.delete = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: destroy.url(args, options),
    method: 'delete',
})

    /**
* @see \App\Http\Controllers\Api\ChamadoController::destroy
 * @see app/Http/Controllers/Api/ChamadoController.php:316
 * @route '/api/chamados/{id}'
 */
    const destroyForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: destroy.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'DELETE',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\Api\ChamadoController::destroy
 * @see app/Http/Controllers/Api/ChamadoController.php:316
 * @route '/api/chamados/{id}'
 */
        destroyForm.delete = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: destroy.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'DELETE',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    destroy.form = destroyForm
const ChamadoController = { index, store, historicoUnidade, show, adicionarMaterial, solicitarMaterial, adicionarEvidencias, update, destroy }

export default ChamadoController