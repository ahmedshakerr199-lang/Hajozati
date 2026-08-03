package com.hjozaty.app.presentation.home

import androidx.compose.foundation.background
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.hjozaty.app.designsystem.HCard
import com.hjozaty.app.designsystem.HChip
import com.hjozaty.app.designsystem.HHotelCard
import com.hjozaty.app.designsystem.HRefreshContainer
import com.hjozaty.app.designsystem.HSearchBar
import com.hjozaty.app.designsystem.HSectionTitle
import com.hjozaty.app.presentation.theme.Accent
import com.hjozaty.app.presentation.theme.AppBackground
import com.hjozaty.app.presentation.theme.Primary

@Composable
fun HomeScreen(onSearchClick: () -> Unit, viewModel: HomeViewModel = hiltViewModel()) {
    val hotels by viewModel.hotels.collectAsState(initial = emptyList())
    var selected by rememberSaveable { mutableStateOf("كل المحافظات") }
    val places = listOf("كل المحافظات", "بغداد", "أربيل", "النجف", "البصرة", "السليمانية")
    val visible = hotels.filter { selected == "كل المحافظات" || it.governorate == selected }
    HRefreshContainer(isRefreshing = false, onRefresh = {}) {
        LazyColumn(Modifier.fillMaxSize().background(AppBackground), contentPadding = PaddingValues(bottom = 24.dp)) {
            item { Header() }
            item { SearchCard(onSearchClick) }
            item {
                Text("اختر وجهتك", style = MaterialTheme.typography.titleMedium, modifier = Modifier.padding(horizontal = 20.dp, vertical = 10.dp))
                Row(Modifier.horizontalScroll(rememberScrollState()).padding(horizontal = 20.dp), horizontalArrangement = Arrangement.spacedBy(8.dp)) { places.forEach { place -> HChip(place, selected == place) { selected = place } } }
            }
            item { OfferCard() }
            item { HSectionTitle("إقامات مختارة لك", "عرض الكل") }
            items(visible, key = { it.id }) { HHotelCard(it, Modifier.fillMaxWidth().padding(horizontal = 20.dp, vertical = 7.dp)) }
        }
    }
}

@Composable private fun Header() = Box(Modifier.fillMaxWidth().background(Brush.verticalGradient(listOf(Primary, Color(0xFF166477)))).padding(20.dp, 58.dp, 20.dp, 32.dp)) { Column { Text("أهلاً بك 👋", color = Color.White.copy(alpha = .85f)); Spacer(Modifier.height(6.dp)); Text("إلى أين تريد أن تذهب؟", color = Color.White, style = MaterialTheme.typography.headlineSmall) } }

@Composable private fun SearchCard(onClick: () -> Unit) = HCard(Modifier.fillMaxWidth().padding(horizontal = 20.dp).offset(y = (-16).dp), onClick) { HSearchBar("", {}, Modifier.fillMaxWidth(), "ابحث عن فندق أو شقة") }

@Composable private fun OfferCard() = HCard(Modifier.fillMaxWidth().padding(20.dp)) { Row(Modifier.background(Accent).padding(18.dp), verticalAlignment = Alignment.CenterVertically) { Text("✈️", fontSize = 35.sp); Spacer(Modifier.width(12.dp)); Column(Modifier.weight(1f)) { Text("عروض الصيف", color = Color.White, fontWeight = FontWeight.Bold, style = MaterialTheme.typography.titleMedium); Text("وفّر حتى 25% على إقامتك القادمة", color = Color.White.copy(.88f)) }; Text("اكتشف", color = Color.White, fontWeight = FontWeight.Bold) } }
