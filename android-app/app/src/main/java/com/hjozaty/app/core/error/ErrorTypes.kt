package com.hjozaty.app.core.error

/** Connectivity, timeout, or unavailable-service failure. */ data object NetworkError : AppError
/** Validation failure represented without retaining raw input values. */ data class ValidationError(val field: String? = null) : AppError
/** Fallback error for failures that have no safe specific classification. */ data object UnknownError : AppError
