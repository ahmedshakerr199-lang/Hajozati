package com.hjozaty.app.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "hotels")
data class HotelEntity(
    @PrimaryKey val id: Int,
    val name: String,
    val governorate: String,
    val area: String,
    val rating: Double,
    val reviews: Int,
    val pricePerNight: Int,
    val imageEmoji: String,
    val tag: String?,
)
