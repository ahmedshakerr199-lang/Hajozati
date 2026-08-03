package com.hjozaty.app.utils

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class InputValidatorTest {
    @Test fun `normalizes surrounding and repeated spaces`() {
        assertEquals("فندق بغداد", InputValidator.normalizedQuery("  فندق   بغداد "))
    }

    @Test fun `rejects excessively long search query`() {
        assertFalse(InputValidator.isSearchQueryValid("a".repeat(81)))
        assertTrue(InputValidator.isSearchQueryValid("فندق"))
    }
}
