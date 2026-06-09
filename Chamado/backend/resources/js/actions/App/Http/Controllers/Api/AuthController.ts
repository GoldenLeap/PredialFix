import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../../wayfinder'
/**
* @see \App\Http\Controllers\Api\AuthController::login
* @see app/Http/Controllers/Api/AuthController.php:13
* @route '/api/login'
*/
export const login = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: login.url(options),
    method: 'post',
})

login.definition = {
    methods: ["post"],
    url: '/api/login',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\Api\AuthController::login
* @see app/Http/Controllers/Api/AuthController.php:13
* @route '/api/login'
*/
login.url = (options?: RouteQueryOptions) => {
    return login.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\AuthController::login
* @see app/Http/Controllers/Api/AuthController.php:13
* @route '/api/login'
*/
login.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: login.url(options),
    method: 'post',
})

/**
* @see \App\Http\Controllers\Api\AuthController::login
* @see app/Http/Controllers/Api/AuthController.php:13
* @route '/api/login'
*/
const loginForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: login.url(options),
    method: 'post',
})

/**
* @see \App\Http\Controllers\Api\AuthController::login
* @see app/Http/Controllers/Api/AuthController.php:13
* @route '/api/login'
*/
loginForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: login.url(options),
    method: 'post',
})

login.form = loginForm

/**
* @see \App\Http\Controllers\Api\AuthController::logout
* @see app/Http/Controllers/Api/AuthController.php:42
* @route '/api/logout'
*/
export const logout = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: logout.url(options),
    method: 'post',
})

logout.definition = {
    methods: ["post"],
    url: '/api/logout',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\Api\AuthController::logout
* @see app/Http/Controllers/Api/AuthController.php:42
* @route '/api/logout'
*/
logout.url = (options?: RouteQueryOptions) => {
    return logout.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\AuthController::logout
* @see app/Http/Controllers/Api/AuthController.php:42
* @route '/api/logout'
*/
logout.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: logout.url(options),
    method: 'post',
})

/**
* @see \App\Http\Controllers\Api\AuthController::logout
* @see app/Http/Controllers/Api/AuthController.php:42
* @route '/api/logout'
*/
const logoutForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: logout.url(options),
    method: 'post',
})

/**
* @see \App\Http\Controllers\Api\AuthController::logout
* @see app/Http/Controllers/Api/AuthController.php:42
* @route '/api/logout'
*/
logoutForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: logout.url(options),
    method: 'post',
})

logout.form = logoutForm

/**
* @see \App\Http\Controllers\Api\AuthController::me
* @see app/Http/Controllers/Api/AuthController.php:56
* @route '/api/me'
*/
export const me = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: me.url(options),
    method: 'get',
})

me.definition = {
    methods: ["get","head"],
    url: '/api/me',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\Api\AuthController::me
* @see app/Http/Controllers/Api/AuthController.php:56
* @route '/api/me'
*/
me.url = (options?: RouteQueryOptions) => {
    return me.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\AuthController::me
* @see app/Http/Controllers/Api/AuthController.php:56
* @route '/api/me'
*/
me.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: me.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\Api\AuthController::me
* @see app/Http/Controllers/Api/AuthController.php:56
* @route '/api/me'
*/
me.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: me.url(options),
    method: 'head',
})

/**
* @see \App\Http\Controllers\Api\AuthController::me
* @see app/Http/Controllers/Api/AuthController.php:56
* @route '/api/me'
*/
const meForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: me.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\Api\AuthController::me
* @see app/Http/Controllers/Api/AuthController.php:56
* @route '/api/me'
*/
meForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: me.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\Api\AuthController::me
* @see app/Http/Controllers/Api/AuthController.php:56
* @route '/api/me'
*/
meForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: me.url({
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'HEAD',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'get',
})

me.form = meForm

/**
* @see \App\Http\Controllers\Api\AuthController::getTecnicos
* @see app/Http/Controllers/Api/AuthController.php:68
* @route '/api/tecnicos'
*/
export const getTecnicos = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: getTecnicos.url(options),
    method: 'get',
})

getTecnicos.definition = {
    methods: ["get","head"],
    url: '/api/tecnicos',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\Api\AuthController::getTecnicos
* @see app/Http/Controllers/Api/AuthController.php:68
* @route '/api/tecnicos'
*/
getTecnicos.url = (options?: RouteQueryOptions) => {
    return getTecnicos.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\AuthController::getTecnicos
* @see app/Http/Controllers/Api/AuthController.php:68
* @route '/api/tecnicos'
*/
getTecnicos.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: getTecnicos.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\Api\AuthController::getTecnicos
* @see app/Http/Controllers/Api/AuthController.php:68
* @route '/api/tecnicos'
*/
getTecnicos.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: getTecnicos.url(options),
    method: 'head',
})

/**
* @see \App\Http\Controllers\Api\AuthController::getTecnicos
* @see app/Http/Controllers/Api/AuthController.php:68
* @route '/api/tecnicos'
*/
const getTecnicosForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: getTecnicos.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\Api\AuthController::getTecnicos
* @see app/Http/Controllers/Api/AuthController.php:68
* @route '/api/tecnicos'
*/
getTecnicosForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: getTecnicos.url(options),
    method: 'get',
})

/**
* @see \App\Http\Controllers\Api\AuthController::getTecnicos
* @see app/Http/Controllers/Api/AuthController.php:68
* @route '/api/tecnicos'
*/
getTecnicosForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
    action: getTecnicos.url({
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'HEAD',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'get',
})

getTecnicos.form = getTecnicosForm

const AuthController = { login, logout, me, getTecnicos }

export default AuthController