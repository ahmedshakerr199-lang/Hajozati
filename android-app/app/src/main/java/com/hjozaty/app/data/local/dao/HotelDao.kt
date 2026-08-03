package com.hjozaty.app.data.local.dao

import androidx.room.Dao
import androidx.room.Query
import com.hjozaty.app.data.local.entity.HotelEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface HotelDao {
    @Query("SELECT * FROM hotels") fun observeAll(): Flow<List<HotelEntity>>
}
