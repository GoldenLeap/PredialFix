import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../wayfinder'
/**
* @see \App\Http\Controllers\MaterialController::index
* @see app/Http/Controllers/MaterialController.php:11
* @route '/materiais'
*/
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/materiais',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\MaterialController::index
* @see app/Http/Controllers/MaterialController.php:11
* @route '/materiais'
*/
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\MaterialController::index
* @see app/Http/Controllers/MaterialController.php:11
* @route '/materiais'
*/
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\MaterialController::index
* @see app/Http/Controllers/MaterialController.php:11
* @route '/materiais'
*/
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

/**
* @see \App\Http\Controllers\MaterialController::index
* @see app/Http/Controllers/MaterialController.php:11
* @route '/materiais'
*/
const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: index.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\MaterialController::index
* @see app/Http/Controllers/MaterialController.php:11
* @route '/materiais'
*/
indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: index.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\MaterialController::index
* @see app/Http/Controllers/MaterialController.php:11
* @route '/materiais'
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
* @see \App\Http\Controllers\MaterialController::create
* @see app/Http/Controllers/MaterialController.php:19
* @route '/materiais/create'
*/
export const create = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: create.url(options),
    method: 'get',
})

create.definition = {
    methods: ["get","head"],
    url: '/materiais/create',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\MaterialController::create
* @see app/Http/Controllers/MaterialController.php:19
* @route '/materiais/create'
*/
create.url = (options?: RouteQueryOptions) => {
    return create.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\MaterialController::create
* @see app/Http/Controllers/MaterialController.php:19
* @route '/materiais/create'
*/
create.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: create.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\MaterialController::create
* @see app/Http/Controllers/MaterialController.php:19
* @route '/materiais/create'
*/
create.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: create.url(options),
    method: 'head',
})

/**
* @see \App\Http\Controllers\MaterialController::create
* @see app/Http/Controllers/MaterialController.php:19
* @route '/materiais/create'
*/
const createForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: create.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\MaterialController::create
* @see app/Http/Controllers/MaterialController.php:19
* @route '/materiais/create'
*/
createForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: create.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\MaterialController::create
* @see app/Http/Controllers/MaterialController.php:19
* @route '/materiais/create'
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
* @see \App\Http\Controllers\MaterialController::store
* @see app/Http/Controllers/MaterialController.php:24
* @route '/materiais'
*/
export const store = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

store.definition = {
    methods: ["post"],
    url: '/materiais',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\MaterialController::store
* @see app/Http/Controllers/MaterialController.php:24
* @route '/materiais'
*/
store.url = (options?: RouteQueryOptions) => {
    return store.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\MaterialController::store
* @see app/Http/Controllers/MaterialController.php:24
* @route '/materiais'
*/
store.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

/**
* @see \App\Http\Controllers\MaterialController::store
* @see app/Http/Controllers/MaterialController.php:24
* @route '/materiais'
*/
const storeForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: store.url(options),
    method: 'post',
})

/**
* @see \App\Http\Controllers\MaterialController::store
* @see app/Http/Controllers/MaterialController.php:24
* @route '/materiais'
*/
storeForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: store.url(options),
    method: 'post',
})

store.form = storeForm

/**
* @see \App\Http\Controllers\MaterialController::show
* @see app/Http/Controllers/MaterialController.php:0
* @route '/materiais/{materiai}'
*/
export const show = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})

show.definition = {
    methods: ["get","head"],
    url: '/materiais/{materiai}',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\MaterialController::show
* @see app/Http/Controllers/MaterialController.php:0
* @route '/materiais/{materiai}'
*/
show.url = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions) => {
    if (typeof args === 'string' || typeof args === 'number') {
        args = { materiai: args }
    }

    if (Array.isArray(args)) {
        args = {
            materiai: args[0],
        }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
        materiai: args.materiai,
    }

    return show.definition.url
            .replace('{materiai}', parsedArgs.materiai.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\MaterialController::show
* @see app/Http/Controllers/MaterialController.php:0
* @route '/materiais/{materiai}'
*/
show.get = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\MaterialController::show
* @see app/Http/Controllers/MaterialController.php:0
* @route '/materiais/{materiai}'
*/
show.head = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: show.url(args, options),
    method: 'head',
})

/**
* @see \App\Http\Controllers\MaterialController::show
* @see app/Http/Controllers/MaterialController.php:0
* @route '/materiais/{materiai}'
*/
const showForm = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: show.url(args, options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\MaterialController::show
* @see app/Http/Controllers/MaterialController.php:0
* @route '/materiais/{materiai}'
*/
showForm.get = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: show.url(args, options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\MaterialController::show
* @see app/Http/Controllers/MaterialController.php:0
* @route '/materiais/{materiai}'
*/
showForm.head = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
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
* @see \App\Http\Controllers\MaterialController::edit
* @see app/Http/Controllers/MaterialController.php:41
* @route '/materiais/{materiai}/edit'
*/
export const edit = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: edit.url(args, options),
    method: 'get',
})

edit.definition = {
    methods: ["get","head"],
    url: '/materiais/{materiai}/edit',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\MaterialController::edit
* @see app/Http/Controllers/MaterialController.php:41
* @route '/materiais/{materiai}/edit'
*/
edit.url = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions) => {
    if (typeof args === 'string' || typeof args === 'number') {
        args = { materiai: args }
    }

    if (Array.isArray(args)) {
        args = {
            materiai: args[0],
        }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
        materiai: args.materiai,
    }

    return edit.definition.url
            .replace('{materiai}', parsedArgs.materiai.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\MaterialController::edit
* @see app/Http/Controllers/MaterialController.php:41
* @route '/materiais/{materiai}/edit'
*/
edit.get = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: edit.url(args, options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\MaterialController::edit
* @see app/Http/Controllers/MaterialController.php:41
* @route '/materiais/{materiai}/edit'
*/
edit.head = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: edit.url(args, options),
    method: 'head',
})

/**
* @see \App\Http\Controllers\MaterialController::edit
* @see app/Http/Controllers/MaterialController.php:41
* @route '/materiais/{materiai}/edit'
*/
const editForm = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: edit.url(args, options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\MaterialController::edit
* @see app/Http/Controllers/MaterialController.php:41
* @route '/materiais/{materiai}/edit'
*/
editForm.get = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: edit.url(args, options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\MaterialController::edit
* @see app/Http/Controllers/MaterialController.php:41
* @route '/materiais/{materiai}/edit'
*/
editForm.head = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
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
* @see \App\Http\Controllers\MaterialController::update
* @see app/Http/Controllers/MaterialController.php:48
* @route '/materiais/{materiai}'
*/
export const update = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(args, options),
    method: 'put',
})

update.definition = {
    methods: ["put","patch"],
    url: '/materiais/{materiai}',
} satisfies RouteDefinition<["put","patch"]>

/**
* @see \App\Http\Controllers\MaterialController::update
* @see app/Http/Controllers/MaterialController.php:48
* @route '/materiais/{materiai}'
*/
update.url = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions) => {
    if (typeof args === 'string' || typeof args === 'number') {
        args = { materiai: args }
    }

    if (Array.isArray(args)) {
        args = {
            materiai: args[0],
        }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
        materiai: args.materiai,
    }

    return update.definition.url
            .replace('{materiai}', parsedArgs.materiai.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\MaterialController::update
* @see app/Http/Controllers/MaterialController.php:48
* @route '/materiais/{materiai}'
*/
update.put = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(args, options),
    method: 'put',
})

/**
* @see \App\Http\Controllers\MaterialController::update
* @see app/Http/Controllers/MaterialController.php:48
* @route '/materiais/{materiai}'
*/
update.patch = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'patch'> => ({
    url: update.url(args, options),
    method: 'patch',
})

/**
* @see \App\Http\Controllers\MaterialController::update
* @see app/Http/Controllers/MaterialController.php:48
* @route '/materiais/{materiai}'
*/
const updateForm = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: update.url(args, {
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'PUT',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'post',
})

/**
* @see \App\Http\Controllers\MaterialController::update
* @see app/Http/Controllers/MaterialController.php:48
* @route '/materiais/{materiai}'
*/
updateForm.put = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: update.url(args, {
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'PUT',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'post',
})

/**
* @see \App\Http\Controllers\MaterialController::update
* @see app/Http/Controllers/MaterialController.php:48
* @route '/materiais/{materiai}'
*/
updateForm.patch = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
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
* @see \App\Http\Controllers\MaterialController::destroy
* @see app/Http/Controllers/MaterialController.php:0
* @route '/materiais/{materiai}'
*/
export const destroy = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: destroy.url(args, options),
    method: 'delete',
})

destroy.definition = {
    methods: ["delete"],
    url: '/materiais/{materiai}',
} satisfies RouteDefinition<["delete"]>

/**
* @see \App\Http\Controllers\MaterialController::destroy
* @see app/Http/Controllers/MaterialController.php:0
* @route '/materiais/{materiai}'
*/
destroy.url = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions) => {
    if (typeof args === 'string' || typeof args === 'number') {
        args = { materiai: args }
    }

    if (Array.isArray(args)) {
        args = {
            materiai: args[0],
        }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
        materiai: args.materiai,
    }

    return destroy.definition.url
            .replace('{materiai}', parsedArgs.materiai.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\MaterialController::destroy
* @see app/Http/Controllers/MaterialController.php:0
* @route '/materiais/{materiai}'
*/
destroy.delete = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: destroy.url(args, options),
    method: 'delete',
})

/**
* @see \App\Http\Controllers\MaterialController::destroy
* @see app/Http/Controllers/MaterialController.php:0
* @route '/materiais/{materiai}'
*/
const destroyForm = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: destroy.url(args, {
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'DELETE',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'post',
})

/**
* @see \App\Http\Controllers\MaterialController::destroy
* @see app/Http/Controllers/MaterialController.php:0
* @route '/materiais/{materiai}'
*/
destroyForm.delete = (args: { materiai: string | number } | [materiai: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: destroy.url(args, {
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'DELETE',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'post',
})

destroy.form = destroyForm

const materiais = {
    index: Object.assign(index, index),
    create: Object.assign(create, create),
    store: Object.assign(store, store),
    show: Object.assign(show, show),
    edit: Object.assign(edit, edit),
    update: Object.assign(update, update),
    destroy: Object.assign(destroy, destroy),
}

export default materiais