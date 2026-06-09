import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../../wayfinder'
/**
* @see \App\Http\Controllers\Api\ProfileController::update
* @see app/Http/Controllers/Api/ProfileController.php:16
* @route '/api/profile'
*/
export const update = (options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(options),
    method: 'put',
})

update.definition = {
    methods: ["put"],
    url: '/api/profile',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\Api\ProfileController::update
* @see app/Http/Controllers/Api/ProfileController.php:16
* @route '/api/profile'
*/
update.url = (options?: RouteQueryOptions) => {
    return update.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\ProfileController::update
* @see app/Http/Controllers/Api/ProfileController.php:16
* @route '/api/profile'
*/
update.put = (options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(options),
    method: 'put',
})

/**
* @see \App\Http\Controllers\Api\ProfileController::update
* @see app/Http/Controllers/Api/ProfileController.php:16
* @route '/api/profile'
*/
const updateForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: update.url({
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'PUT',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'post',
})

/**
* @see \App\Http\Controllers\Api\ProfileController::update
* @see app/Http/Controllers/Api/ProfileController.php:16
* @route '/api/profile'
*/
updateForm.put = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: update.url({
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'PUT',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'post',
})

update.form = updateForm

/**
* @see \App\Http\Controllers\Api\ProfileController::updatePassword
* @see app/Http/Controllers/Api/ProfileController.php:42
* @route '/api/profile/password'
*/
export const updatePassword = (options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: updatePassword.url(options),
    method: 'put',
})

updatePassword.definition = {
    methods: ["put"],
    url: '/api/profile/password',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\Api\ProfileController::updatePassword
* @see app/Http/Controllers/Api/ProfileController.php:42
* @route '/api/profile/password'
*/
updatePassword.url = (options?: RouteQueryOptions) => {
    return updatePassword.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\Api\ProfileController::updatePassword
* @see app/Http/Controllers/Api/ProfileController.php:42
* @route '/api/profile/password'
*/
updatePassword.put = (options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: updatePassword.url(options),
    method: 'put',
})

/**
* @see \App\Http\Controllers\Api\ProfileController::updatePassword
* @see app/Http/Controllers/Api/ProfileController.php:42
* @route '/api/profile/password'
*/
const updatePasswordForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: updatePassword.url({
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'PUT',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'post',
})

/**
* @see \App\Http\Controllers\Api\ProfileController::updatePassword
* @see app/Http/Controllers/Api/ProfileController.php:42
* @route '/api/profile/password'
*/
updatePasswordForm.put = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
    action: updatePassword.url({
        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
            _method: 'PUT',
            ...(options?.query ?? options?.mergeQuery ?? {}),
        }
    }),
    method: 'post',
})

updatePassword.form = updatePasswordForm

const ProfileController = { update, updatePassword }

export default ProfileController