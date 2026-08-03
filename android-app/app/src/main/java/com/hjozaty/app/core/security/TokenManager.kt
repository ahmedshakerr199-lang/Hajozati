package com.hjozaty.app.core.security

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flowOf

/** Contract only: production implementations must use encrypted storage, never plain preferences. */
interface TokenManager {
    val accessToken: Flow<String?>
    suspend fun save(token: String)
    suspend fun clear()
}

/** Safe no-op implementation until authentication is explicitly introduced. */
class NoOpTokenManager : TokenManager {
    override val accessToken: Flow<String?> = flowOf(null)
    override suspend fun save(token: String) = Unit
    override suspend fun clear() = Unit
}
