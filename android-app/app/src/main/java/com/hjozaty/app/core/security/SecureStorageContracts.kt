package com.hjozaty.app.core.security

import kotlinx.coroutines.flow.Flow

/** Defines host-specific pins before they are attached to OkHttp's CertificatePinner. */
interface CertificatePinningConfiguration { fun pinsFor(host: String): Set<String> }
/** Contract for encrypted DataStore-backed values; implementations must encrypt at rest. */
interface EncryptedDataStore { suspend fun put(key: String, value: String); fun observe(key: String): Flow<String?>; suspend fun remove(key: String) }
/** Contract for secure session-token persistence. Raw tokens must never be logged. */
interface SecureTokenStorage { val accessToken: Flow<String?>; suspend fun save(token: String); suspend fun clear() }
