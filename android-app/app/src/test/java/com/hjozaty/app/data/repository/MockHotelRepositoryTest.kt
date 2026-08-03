package com.hjozaty.app.data.repository

import com.hjozaty.app.core.error.AppResult
import com.hjozaty.app.data.mock.MockHotelData
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class MockHotelRepositoryTest {
    private val repository = MockHotelRepository()
    @Test fun returnsAllNineteenProvinces() = runBlocking { assertEquals(19, repository.observeProvinces().first().size) }
    @Test fun returnsFeaturedAndProvinceFilteredHotels() = runBlocking { assertTrue(repository.observeFeaturedHotels().first().isNotEmpty()); assertTrue(repository.observeHotelsByProvince("baghdad").first().all { it.provinceId == "baghdad" }) }
    @Test fun updatesFavoriteInSession() = runBlocking { val id = MockHotelData.hotels.first().id; assertTrue(repository.setFavorite(id, true) is AppResult.Success); assertTrue(repository.observeHotelById(id).first()?.isFavorite == true) }
}
