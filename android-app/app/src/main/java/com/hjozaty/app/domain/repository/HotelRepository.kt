package com.hjozaty.app.domain.repository

import com.hjozaty.app.domain.model.Hotel
import kotlinx.coroutines.flow.Flow

interface HotelRepository {
    fun observeHotels(): Flow<List<Hotel>>
    fun observeGovernorates(): Flow<List<String>>
}
