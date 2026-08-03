package com.hjozaty.app.domain.model

/** Iraqi province used as a stable accommodation discovery key. */
data class Province(val id: String, val nameAr: String, val nameEn: String, val imageUrl: String?, val hotelsCount: Int, val isFeatured: Boolean)
