package com.hjozaty.app.data.repository

import com.hjozaty.app.core.error.AppResult
import com.hjozaty.app.core.error.UnknownError
import com.hjozaty.app.data.mock.MockHotelData
import com.hjozaty.app.domain.model.Hotel
import com.hjozaty.app.domain.model.Province
import com.hjozaty.app.domain.repository.HotelRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton

/** In-memory single source of truth for rich fictional accommodation data. */
@Singleton
class MockHotelRepository @Inject constructor() : HotelRepository {
    private val hotels = MutableStateFlow(MockHotelData.hotels)
    override fun observeProvinces(): Flow<List<Province>> = kotlinx.coroutines.flow.flowOf(MockHotelData.provinces)
    override fun observeHotels(): Flow<List<Hotel>> = hotels
    override fun observeFeaturedHotels(): Flow<List<Hotel>> = hotels.map { list -> list.filter(Hotel::isFeatured) }
    override fun observeRecommendedHotels(): Flow<List<Hotel>> = hotels.map { list -> list.filter(Hotel::isRecommended) }
    override fun observeHotelsByProvince(provinceId: String): Flow<List<Hotel>> = hotels.map { list -> list.filter { it.provinceId == provinceId } }
    override fun observeHotelById(hotelId: String): Flow<Hotel?> = hotels.map { list -> list.firstOrNull { it.id == hotelId } }
    override suspend fun setFavorite(hotelId: String, isFavorite: Boolean): AppResult<Unit> {
        val current = hotels.value
        if (current.none { it.id == hotelId }) return AppResult.Failure(UnknownError)
        hotels.value = current.map { if (it.id == hotelId) it.copy(isFavorite = isFavorite) else it }
        return AppResult.Success(Unit)
    }
}
