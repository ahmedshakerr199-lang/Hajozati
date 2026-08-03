package com.hjozaty.app.domain.model

/** Amenity values remain Android-free so icons can be supplied by presentation later. */
enum class HotelAmenityType(val nameAr: String, val nameEn: String) {
    FREE_WIFI("واي فاي مجاني", "Free Wi-Fi"), PARKING("موقف سيارات", "Parking"), POOL("مسبح", "Pool"), RESTAURANT("مطعم", "Restaurant"), CAFE("مقهى", "Cafe"), GYM("صالة رياضية", "Gym"), SPA("سبا", "Spa"), ROOM_SERVICE("خدمة غرف", "Room service"), RECEPTION_24H("استقبال 24 ساعة", "24-hour reception"), AIR_CONDITIONING("تكييف", "Air conditioning"), ELEVATOR("مصعد", "Elevator"), AIRPORT_SHUTTLE("نقل من وإلى المطار", "Airport shuttle"), FAMILY_FRIENDLY("مناسب للعائلات", "Family friendly"), NON_SMOKING_ROOMS("غرف لغير المدخنين", "Non-smoking rooms"), MEETING_ROOMS("قاعة اجتماعات", "Meeting rooms"), VIEW("إطلالة", "View"), GENERATOR("مولد كهرباء", "Generator"), BACKUP_POWER("منظومة كهرباء احتياطية", "Backup power"), HOUSEKEEPING("خدمة تنظيف", "Housekeeping"), ACCESSIBLE("مرافق لذوي الإعاقة", "Accessible facilities")
}

/** A facility available at a hotel. */
data class HotelAmenity(val id: String, val type: HotelAmenityType)

/** In-room facilities; visual representation belongs to presentation. */
enum class RoomAmenity { PRIVATE_BATHROOM, WIFI, TV, AIR_CONDITIONING, MINI_BAR, BALCONY, SAFE }
