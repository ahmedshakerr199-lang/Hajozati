package com.hjozaty.app.data.local

import androidx.room.Database
import androidx.room.RoomDatabase
import com.hjozaty.app.data.local.dao.HotelDao
import com.hjozaty.app.data.local.entity.HotelEntity

/** Local source of truth for the future offline-first repository. */
@Database(entities = [HotelEntity::class], version = 1, exportSchema = true)
abstract class HjozatyDatabase : RoomDatabase() {
    abstract fun hotelDao(): HotelDao
}
