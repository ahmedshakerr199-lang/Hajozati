package com.hjozaty.app.presentation.search

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CalendarMonth
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.hjozaty.app.presentation.theme.*
import com.hjozaty.app.utils.InputValidator

@Composable
fun SearchScreen() {
    var query by rememberSaveable { mutableStateOf("") }
    val valid = InputValidator.isSearchQueryValid(query)
    Column(Modifier.fillMaxSize().background(AppBackground).padding(20.dp).padding(top = 34.dp)) {
        Text("ابحث عن إقامتك", style = MaterialTheme.typography.headlineSmall, color = Primary)
        Spacer(Modifier.height(22.dp))
        OutlinedTextField(value = query, onValueChange = { if (InputValidator.isSearchQueryValid(it)) query = it }, modifier = Modifier.fillMaxWidth(), placeholder = { Text("اسم الفندق أو المدينة") }, leadingIcon = { Icon(Icons.Default.Search, null) }, singleLine = true, isError = !valid)
        Spacer(Modifier.height(14.dp))
        Option(Icons.Default.LocationOn, "المحافظة", "اختر وجهتك")
        Spacer(Modifier.height(12.dp))
        Option(Icons.Default.CalendarMonth, "التواريخ", "تاريخ الوصول والمغادرة")
        Spacer(Modifier.height(24.dp))
        Button(onClick = { query = InputValidator.normalizedQuery(query) }, modifier = Modifier.fillMaxWidth().height(54.dp), enabled = valid, shape = RoundedCornerShape(16.dp)) { Text("ابحث الآن", fontWeight = FontWeight.Bold) }
    }
}

@Composable private fun Option(icon: androidx.compose.ui.graphics.vector.ImageVector, title: String, value: String) = OutlinedCard(Modifier.fillMaxWidth()) { Row(Modifier.padding(16.dp)) { Icon(icon, null, tint = Primary); Spacer(Modifier.width(12.dp)); Column { Text(title, fontWeight = FontWeight.Bold); Text(value, color = MutedText) } } }
