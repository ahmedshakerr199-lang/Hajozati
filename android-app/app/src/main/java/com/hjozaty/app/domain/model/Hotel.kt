package com.hjozaty.app.domain.model

data class Hotel(
    val id: Int,
    val name: String,
    val governorate: String,
    val area: String,
    val rating: Double,
    val reviews: Int,
    val pricePerNight: Int,
    val imageEmoji: String,
    val tag: String? = null,
)
