package com.hjozaty.app.domain.model

/** Full hotel aggregate, independent from Android and network DTOs. */
data class Hotel(val id: String, val nameAr: String, val nameEn: String, val descriptionAr: String, val descriptionEn: String, val provinceId: String, val cityAr: String, val cityEn: String, val addressAr: String, val addressEn: String, val latitude: Double, val longitude: Double, val category: HotelCategory, val stars: Int, val rating: Double, val reviewsCount: Int, val minimumPricePerNight: Long, val currencyCode: String, val coverImageUrl: String, val imageUrls: List<String>, val amenities: List<HotelAmenity>, val roomTypes: List<RoomType>, val policies: HotelPolicies, val isFeatured: Boolean, val isRecommended: Boolean, val isPopular: Boolean, val isFavorite: Boolean, val discountPercentage: Int?, val createdAt: String)

/** Non-throwing validation for network or mock data before it reaches presentation. */
fun Hotel.validationErrors(): List<String> = buildList { if (stars !in 1..5) add("stars"); if (rating !in 0.0..5.0) add("rating"); if (minimumPricePerNight < 0) add("minimumPricePerNight"); roomTypes.forEach { room -> if (room.pricePerNight < 0 || room.capacityAdults < 0 || room.capacityChildren < 0 || room.availableRooms < 0) add("room:${room.id}") } }
