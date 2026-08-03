package com.hjozaty.app.core.network

import retrofit2.http.GET

/** API contract placeholder. Authentication is added through an OkHttp interceptor later. */
/** Retrofit endpoint contract, intentionally minimal until a backend is introduced. */
interface HjozatyApiService {
    @GET("v1/health")
    suspend fun healthCheck(): Unit
}
