package com.hjozaty.app.presentation.search

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CalendarMonth
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.hjozaty.app.designsystem.buttons.HButton
import com.hjozaty.app.designsystem.cards.HCard
import com.hjozaty.app.designsystem.inputs.HSearchBar
import com.hjozaty.app.designsystem.navigation.HTopAppBar
import com.hjozaty.app.presentation.theme.*
import com.hjozaty.app.utils.InputValidator

@Composable
fun SearchScreen() {
    var query by rememberSaveable { mutableStateOf("") }
    val valid = InputValidator.isSearchQueryValid(query)
    Column(Modifier.fillMaxSize().background(AppBackground).padding(20.dp).padding(top = 34.dp)) {
        HTopAppBar("ابحث عن إقامتك")
        Spacer(Modifier.height(22.dp))
        HSearchBar(query, { if (InputValidator.isSearchQueryValid(it)) query = it }, Modifier.fillMaxWidth(), "اسم الفندق أو المدينة")
        Spacer(Modifier.height(14.dp))
        Option(Icons.Default.LocationOn, "المحافظة", "اختر وجهتك")
        Spacer(Modifier.height(12.dp))
        Option(Icons.Default.CalendarMonth, "التواريخ", "تاريخ الوصول والمغادرة")
        Spacer(Modifier.height(24.dp))
        HButton("ابحث الآن", { query = InputValidator.normalizedQuery(query) }, Modifier.fillMaxWidth(), valid)
    }
}

@Composable private fun Option(icon: androidx.compose.ui.graphics.vector.ImageVector, title: String, value: String) = HCard(Modifier.fillMaxWidth()) { Row(Modifier.padding(16.dp)) { Icon(icon, null, tint = Primary); Spacer(Modifier.width(12.dp)); Column { Text(title, fontWeight = FontWeight.Bold); Text(value, color = MutedText) } } }
