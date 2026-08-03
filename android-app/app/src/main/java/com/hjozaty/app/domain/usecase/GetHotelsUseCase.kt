package com.hjozaty.app.domain.usecase

import com.hjozaty.app.domain.repository.HotelRepository
import javax.inject.Inject

/** Exposes hotel data to presentation without leaking repository implementation details. */
class GetHotelsUseCase @Inject constructor(private val repository: HotelRepository) {
    operator fun invoke() = repository.observeHotels()
}
