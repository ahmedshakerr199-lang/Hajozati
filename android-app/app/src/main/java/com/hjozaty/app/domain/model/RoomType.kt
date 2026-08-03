package com.hjozaty.app.domain.model

/** A sellable room type. Monetary values use integer minor units (IQD). */
data class RoomType(val id: String, val hotelId: String, val nameAr: String, val nameEn: String, val descriptionAr: String, val descriptionEn: String, val capacityAdults: Int, val capacityChildren: Int, val bedsDescriptionAr: String, val bedsDescriptionEn: String, val sizeSquareMeters: Int?, val pricePerNight: Long, val availableRooms: Int, val imageUrls: List<String>, val amenities: List<RoomAmenity>, val refundable: Boolean, val breakfastIncluded: Boolean)
