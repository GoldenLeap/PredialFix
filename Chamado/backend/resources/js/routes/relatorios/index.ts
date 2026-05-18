import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../wayfinder'
/**
* @see \App\Http\Controllers\ReportController::index
 * @see app/Http/Controllers/ReportController.php:12
 * @route '/relatorios'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/relatorios',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\ReportController::index
 * @see app/Http/Controllers/ReportController.php:12
 * @route '/relatorios'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\ReportController::index
 * @see app/Http/Controllers/ReportController.php:12
 * @route '/relatorios'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\ReportController::index
 * @see app/Http/Controllers/ReportController.php:12
 * @route '/relatorios'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\ReportController::index
 * @see app/Http/Controllers/ReportController.php:12
 * @route '/relatorios'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\ReportController::index
 * @see app/Http/Controllers/ReportController.php:12
 * @route '/relatorios'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\ReportController::index
 * @see app/Http/Controllers/ReportController.php:12
 * @route '/relatorios'
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
* @see \App\Http\Controllers\ReportController::pdf
 * @see app/Http/Controllers/ReportController.php:61
 * @route '/relatorios/pdf'
 */
export const pdf = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: pdf.url(options),
    method: 'get',
})

pdf.definition = {
    methods: ["get","head"],
    url: '/relatorios/pdf',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\ReportController::pdf
 * @see app/Http/Controllers/ReportController.php:61
 * @route '/relatorios/pdf'
 */
pdf.url = (options?: RouteQueryOptions) => {
    return pdf.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\ReportController::pdf
 * @see app/Http/Controllers/ReportController.php:61
 * @route '/relatorios/pdf'
 */
pdf.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: pdf.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\ReportController::pdf
 * @see app/Http/Controllers/ReportController.php:61
 * @route '/relatorios/pdf'
 */
pdf.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: pdf.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\ReportController::pdf
 * @see app/Http/Controllers/ReportController.php:61
 * @route '/relatorios/pdf'
 */
    const pdfForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: pdf.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\ReportController::pdf
 * @see app/Http/Controllers/ReportController.php:61
 * @route '/relatorios/pdf'
 */
        pdfForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: pdf.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\ReportController::pdf
 * @see app/Http/Controllers/ReportController.php:61
 * @route '/relatorios/pdf'
 */
        pdfForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: pdf.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    pdf.form = pdfForm
const relatorios = {
    index: Object.assign(index, index),
pdf: Object.assign(pdf, pdf),
}

export default relatorios