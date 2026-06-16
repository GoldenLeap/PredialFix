import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\NotificationController::index
 * @see app/Http/Controllers/NotificationController.php:9
 * @route '/api/notifications'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/notifications',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\NotificationController::index
 * @see app/Http/Controllers/NotificationController.php:9
 * @route '/api/notifications'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\NotificationController::index
 * @see app/Http/Controllers/NotificationController.php:9
 * @route '/api/notifications'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\NotificationController::index
 * @see app/Http/Controllers/NotificationController.php:9
 * @route '/api/notifications'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\NotificationController::index
 * @see app/Http/Controllers/NotificationController.php:9
 * @route '/api/notifications'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\NotificationController::index
 * @see app/Http/Controllers/NotificationController.php:9
 * @route '/api/notifications'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\NotificationController::index
 * @see app/Http/Controllers/NotificationController.php:9
 * @route '/api/notifications'
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
* @see \App\Http\Controllers\NotificationController::markAsRead
 * @see app/Http/Controllers/NotificationController.php:17
 * @route '/api/notifications/{id}/read'
 */
const markAsRead4a7d6f40b8464960fd14764336786b53 = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: markAsRead4a7d6f40b8464960fd14764336786b53.url(args, options),
    method: 'post',
})

markAsRead4a7d6f40b8464960fd14764336786b53.definition = {
    methods: ["post"],
    url: '/api/notifications/{id}/read',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\NotificationController::markAsRead
 * @see app/Http/Controllers/NotificationController.php:17
 * @route '/api/notifications/{id}/read'
 */
markAsRead4a7d6f40b8464960fd14764336786b53.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return markAsRead4a7d6f40b8464960fd14764336786b53.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\NotificationController::markAsRead
 * @see app/Http/Controllers/NotificationController.php:17
 * @route '/api/notifications/{id}/read'
 */
markAsRead4a7d6f40b8464960fd14764336786b53.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: markAsRead4a7d6f40b8464960fd14764336786b53.url(args, options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\NotificationController::markAsRead
 * @see app/Http/Controllers/NotificationController.php:17
 * @route '/api/notifications/{id}/read'
 */
    const markAsRead4a7d6f40b8464960fd14764336786b53Form = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: markAsRead4a7d6f40b8464960fd14764336786b53.url(args, options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\NotificationController::markAsRead
 * @see app/Http/Controllers/NotificationController.php:17
 * @route '/api/notifications/{id}/read'
 */
        markAsRead4a7d6f40b8464960fd14764336786b53Form.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: markAsRead4a7d6f40b8464960fd14764336786b53.url(args, options),
            method: 'post',
        })
    
    markAsRead4a7d6f40b8464960fd14764336786b53.form = markAsRead4a7d6f40b8464960fd14764336786b53Form
    /**
* @see \App\Http\Controllers\NotificationController::markAsRead
 * @see app/Http/Controllers/NotificationController.php:17
 * @route '/notifications/{id}/read'
 */
const markAsReade5b1004d28d186a50192577f69686302 = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: markAsReade5b1004d28d186a50192577f69686302.url(args, options),
    method: 'post',
})

markAsReade5b1004d28d186a50192577f69686302.definition = {
    methods: ["post"],
    url: '/notifications/{id}/read',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\NotificationController::markAsRead
 * @see app/Http/Controllers/NotificationController.php:17
 * @route '/notifications/{id}/read'
 */
markAsReade5b1004d28d186a50192577f69686302.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return markAsReade5b1004d28d186a50192577f69686302.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\NotificationController::markAsRead
 * @see app/Http/Controllers/NotificationController.php:17
 * @route '/notifications/{id}/read'
 */
markAsReade5b1004d28d186a50192577f69686302.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: markAsReade5b1004d28d186a50192577f69686302.url(args, options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\NotificationController::markAsRead
 * @see app/Http/Controllers/NotificationController.php:17
 * @route '/notifications/{id}/read'
 */
    const markAsReade5b1004d28d186a50192577f69686302Form = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: markAsReade5b1004d28d186a50192577f69686302.url(args, options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\NotificationController::markAsRead
 * @see app/Http/Controllers/NotificationController.php:17
 * @route '/notifications/{id}/read'
 */
        markAsReade5b1004d28d186a50192577f69686302Form.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: markAsReade5b1004d28d186a50192577f69686302.url(args, options),
            method: 'post',
        })
    
    markAsReade5b1004d28d186a50192577f69686302.form = markAsReade5b1004d28d186a50192577f69686302Form

/**
* Multiple routes resolve to \App\Http\Controllers\NotificationController::markAsRead, so this export is a
* dictionary keyed by URI rather than a callable. Call a specific route with `markAsRead['<uri>'](...)`,
* or import the route by name from your generated `routes/` directory.
*/
export const markAsRead = {
    '/api/notifications/{id}/read': markAsRead4a7d6f40b8464960fd14764336786b53,
    '/notifications/{id}/read': markAsReade5b1004d28d186a50192577f69686302,
}

/**
* @see \App\Http\Controllers\NotificationController::markAllAsRead
 * @see app/Http/Controllers/NotificationController.php:28
 * @route '/api/notifications/read-all'
 */
const markAllAsRead11dbec618d513d6b543ef7b28a4b68e6 = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: markAllAsRead11dbec618d513d6b543ef7b28a4b68e6.url(options),
    method: 'post',
})

markAllAsRead11dbec618d513d6b543ef7b28a4b68e6.definition = {
    methods: ["post"],
    url: '/api/notifications/read-all',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\NotificationController::markAllAsRead
 * @see app/Http/Controllers/NotificationController.php:28
 * @route '/api/notifications/read-all'
 */
markAllAsRead11dbec618d513d6b543ef7b28a4b68e6.url = (options?: RouteQueryOptions) => {
    return markAllAsRead11dbec618d513d6b543ef7b28a4b68e6.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\NotificationController::markAllAsRead
 * @see app/Http/Controllers/NotificationController.php:28
 * @route '/api/notifications/read-all'
 */
markAllAsRead11dbec618d513d6b543ef7b28a4b68e6.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: markAllAsRead11dbec618d513d6b543ef7b28a4b68e6.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\NotificationController::markAllAsRead
 * @see app/Http/Controllers/NotificationController.php:28
 * @route '/api/notifications/read-all'
 */
    const markAllAsRead11dbec618d513d6b543ef7b28a4b68e6Form = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: markAllAsRead11dbec618d513d6b543ef7b28a4b68e6.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\NotificationController::markAllAsRead
 * @see app/Http/Controllers/NotificationController.php:28
 * @route '/api/notifications/read-all'
 */
        markAllAsRead11dbec618d513d6b543ef7b28a4b68e6Form.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: markAllAsRead11dbec618d513d6b543ef7b28a4b68e6.url(options),
            method: 'post',
        })
    
    markAllAsRead11dbec618d513d6b543ef7b28a4b68e6.form = markAllAsRead11dbec618d513d6b543ef7b28a4b68e6Form
    /**
* @see \App\Http\Controllers\NotificationController::markAllAsRead
 * @see app/Http/Controllers/NotificationController.php:28
 * @route '/notifications/read-all'
 */
const markAllAsRead6dbc5967894d9145703b6cae8ccd396b = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: markAllAsRead6dbc5967894d9145703b6cae8ccd396b.url(options),
    method: 'post',
})

markAllAsRead6dbc5967894d9145703b6cae8ccd396b.definition = {
    methods: ["post"],
    url: '/notifications/read-all',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\NotificationController::markAllAsRead
 * @see app/Http/Controllers/NotificationController.php:28
 * @route '/notifications/read-all'
 */
markAllAsRead6dbc5967894d9145703b6cae8ccd396b.url = (options?: RouteQueryOptions) => {
    return markAllAsRead6dbc5967894d9145703b6cae8ccd396b.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\NotificationController::markAllAsRead
 * @see app/Http/Controllers/NotificationController.php:28
 * @route '/notifications/read-all'
 */
markAllAsRead6dbc5967894d9145703b6cae8ccd396b.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: markAllAsRead6dbc5967894d9145703b6cae8ccd396b.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\NotificationController::markAllAsRead
 * @see app/Http/Controllers/NotificationController.php:28
 * @route '/notifications/read-all'
 */
    const markAllAsRead6dbc5967894d9145703b6cae8ccd396bForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: markAllAsRead6dbc5967894d9145703b6cae8ccd396b.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\NotificationController::markAllAsRead
 * @see app/Http/Controllers/NotificationController.php:28
 * @route '/notifications/read-all'
 */
        markAllAsRead6dbc5967894d9145703b6cae8ccd396bForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: markAllAsRead6dbc5967894d9145703b6cae8ccd396b.url(options),
            method: 'post',
        })
    
    markAllAsRead6dbc5967894d9145703b6cae8ccd396b.form = markAllAsRead6dbc5967894d9145703b6cae8ccd396bForm

/**
* Multiple routes resolve to \App\Http\Controllers\NotificationController::markAllAsRead, so this export is a
* dictionary keyed by URI rather than a callable. Call a specific route with `markAllAsRead['<uri>'](...)`,
* or import the route by name from your generated `routes/` directory.
*/
export const markAllAsRead = {
    '/api/notifications/read-all': markAllAsRead11dbec618d513d6b543ef7b28a4b68e6,
    '/notifications/read-all': markAllAsRead6dbc5967894d9145703b6cae8ccd396b,
}

const NotificationController = { index, markAsRead, markAllAsRead }

export default NotificationController