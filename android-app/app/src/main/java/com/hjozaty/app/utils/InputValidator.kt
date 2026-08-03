package com.hjozaty.app.utils

/** Small pure validation helpers that can be unit tested without Android dependencies. */
object InputValidator {
    fun isSearchQueryValid(value: String): Boolean = value.trim().length <= 80
    fun normalizedQuery(value: String): String = value.trim().replace(Regex("\\s+"), " ")
}
