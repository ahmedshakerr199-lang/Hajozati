package com.hjozaty.app.domain.model

/** Property rules displayed during future booking flow. */
data class HotelPolicies(val checkInFrom: String, val checkInUntil: String?, val checkOutFrom: String?, val checkOutUntil: String, val childrenAllowed: Boolean, val petsAllowed: Boolean, val smokingAllowed: Boolean, val partiesAllowed: Boolean, val cancellationSummaryAr: String, val cancellationSummaryEn: String)
