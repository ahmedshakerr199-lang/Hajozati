package com.hjozaty.app.data.cache

import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock

/** Thread-safe in-memory cache; repositories can combine this with Room for offline-first reads. */
class RepositoryCache<K : Any, V : Any> {
    private val mutex = Mutex()
    private val values = mutableMapOf<K, V>()

    suspend fun get(key: K): V? = mutex.withLock { values[key] }
    suspend fun put(key: K, value: V) = mutex.withLock { values[key] = value }
    suspend fun clear() = mutex.withLock { values.clear() }
}
