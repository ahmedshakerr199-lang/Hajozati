package com.hjozaty.app.core.error

/** Stable, user-safe error types. Never expose server payloads or exceptions to the UI. */
sealed interface AppError {
    data object Network : AppError
    data object Unauthorized : AppError
    data object NotFound : AppError
    data object Unknown : AppError
}

fun Throwable.toAppError(): AppError = when (this) {
    is java.net.UnknownHostException, is java.net.SocketTimeoutException -> AppError.Network
    else -> AppError.Unknown
}
