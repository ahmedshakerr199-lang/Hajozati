package com.hjozaty.app.core.error

/** Unified result wrapper for repository and use-case boundaries. */
sealed interface AppResult<out T> {
    /** Successful operation result. */ data class Success<T>(val data: T) : AppResult<T>
    /** Failure represented by a user-safe [AppError]. */ data class Failure(val error: AppError) : AppResult<Nothing>
}

/** Converts unexpected throwables to a safe error category. */
fun Throwable.toAppError(): AppError = when (this) { is java.net.UnknownHostException, is java.net.SocketTimeoutException -> NetworkError; else -> UnknownError }
