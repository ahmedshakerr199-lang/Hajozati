package com.hjozaty.app.data.repository

import com.hjozaty.app.data.mock.MockHotelData
import com.hjozaty.app.domain.model.Hotel
import com.hjozaty.app.domain.repository.HotelRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flowOf
import javax.inject.Inject

/** Mock implementation. Replace the sources with Room/API as the product grows. */
class HotelRepositoryImpl @Inject constructor() : HotelRepository {
    override fun observeHotels(): Flow<List<Hotel>> = flowOf(MockHotelData.hotels)
    override fun observeGovernorates(): Flow<List<String>> = flowOf(MockHotelData.governorates)
}
