package com.hjozaty.app.domain.repository

import com.hjozaty.app.domain.model.Hotel
import kotlinx.coroutines.flow.Flow

/** Contract for observing accommodation data independently from its source. */
interface HotelRepository {
    fun observeHotels(): Flow<List<Hotel>>
    fun observeGovernorates(): Flow<List<String>>
}
