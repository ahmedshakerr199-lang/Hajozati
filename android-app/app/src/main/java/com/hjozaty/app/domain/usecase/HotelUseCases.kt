package com.hjozaty.app.domain.usecase

import com.hjozaty.app.domain.repository.HotelRepository
import javax.inject.Inject

/** Observes all Iraqi provinces. */ class GetProvincesUseCase @Inject constructor(private val repository: HotelRepository) { operator fun invoke() = repository.observeProvinces() }
/** Observes featured properties. */ class GetFeaturedHotelsUseCase @Inject constructor(private val repository: HotelRepository) { operator fun invoke() = repository.observeFeaturedHotels() }
/** Observes recommended properties. */ class GetRecommendedHotelsUseCase @Inject constructor(private val repository: HotelRepository) { operator fun invoke() = repository.observeRecommendedHotels() }
/** Observes properties in a stable province id. */ class GetHotelsByProvinceUseCase @Inject constructor(private val repository: HotelRepository) { operator fun invoke(provinceId: String) = repository.observeHotelsByProvince(provinceId) }
/** Observes a single hotel aggregate. */ class GetHotelDetailsUseCase @Inject constructor(private val repository: HotelRepository) { operator fun invoke(hotelId: String) = repository.observeHotelById(hotelId) }
/** Changes favorite state for the current in-memory session. */ class ToggleHotelFavoriteUseCase @Inject constructor(private val repository: HotelRepository) { suspend operator fun invoke(hotelId: String, isFavorite: Boolean) = repository.setFavorite(hotelId, isFavorite) }
