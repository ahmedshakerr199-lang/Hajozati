package com.hjozaty.app.domain.model

/** Accommodation categories with domain-owned localized labels. */
enum class HotelCategory(val nameAr: String, val nameEn: String) {
    HOTEL("فندق", "Hotel"), RESORT("منتجع", "Resort"), APARTMENT("شقة", "Apartment"), HOTEL_APARTMENT("شقق فندقية", "Hotel apartment"), GUEST_HOUSE("بيت ضيافة", "Guest house"), CHALET("شاليه", "Chalet"), MOTEL("موتيل", "Motel"), HOSTEL("نُزل", "Hostel")
}
