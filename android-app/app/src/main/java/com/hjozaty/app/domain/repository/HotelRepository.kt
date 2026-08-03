package com.hjozaty.app.domain.repository

import com.hjozaty.app.core.error.AppResult
import com.hjozaty.app.domain.model.Hotel
import com.hjozaty.app.domain.model.Province
import kotlinx.coroutines.flow.Flow

/** Contract for observing accommodation data independently from its source. */
interface HotelRepository {
    fun observeProvinces(): Flow<List<Province>>
    fun observeHotels(): Flow<List<Hotel>>
    fun observeFeaturedHotels(): Flow<List<Hotel>>
    fun observeRecommendedHotels(): Flow<List<Hotel>>
    fun observeHotelsByProvince(provinceId: String): Flow<List<Hotel>>
    fun observeHotelById(hotelId: String): Flow<Hotel?>
    suspend fun setFavorite(hotelId: String, isFavorite: Boolean): AppResult<Unit>
}
