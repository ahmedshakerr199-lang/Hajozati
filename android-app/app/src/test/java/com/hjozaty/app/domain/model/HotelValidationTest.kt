package com.hjozaty.app.domain.model

import com.hjozaty.app.data.mock.MockHotelData
import org.junit.Assert.assertTrue
import org.junit.Test

class HotelValidationTest {
    @Test fun mockHotelsHaveValidStarsRatingsAndPrices() { assertTrue(MockHotelData.hotels.all { it.validationErrors().isEmpty() }) }
}
