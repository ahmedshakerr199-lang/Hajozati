package com.hjozaty.app.presentation.home

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.hjozaty.app.designsystem.HjozatySectionTitle
import com.hjozaty.app.domain.model.Hotel
import com.hjozaty.app.presentation.theme.*

@Composable
fun HomeScreen(onSearchClick: () -> Unit, viewModel: HomeViewModel = hiltViewModel()) {
    val hotels by viewModel.hotels.collectAsState(initial = emptyList())
    var selected by rememberSaveable { mutableStateOf("كل المحافظات") }
    val places = listOf("كل المحافظات", "بغداد", "أربيل", "النجف", "البصرة", "السليمانية")
    val visible = hotels.filter { selected == "كل المحافظات" || it.governorate == selected }
    LazyColumn(Modifier.fillMaxSize().background(AppBackground), contentPadding = PaddingValues(bottom = 24.dp)) {
        item { Header() }
        item { SearchCard(onSearchClick) }
        item {
            Text("اختر وجهتك", style = MaterialTheme.typography.titleMedium, modifier = Modifier.padding(horizontal = 20.dp, vertical = 10.dp))
            Row(Modifier.horizontalScroll(rememberScrollState()).padding(horizontal = 20.dp), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                places.forEach { place -> FilterChip(selected = selected == place, onClick = { selected = place }, label = { Text(place) }) }
            }
        }
        item { OfferCard() }
        item { HjozatySectionTitle("إقامات مختارة لك", "عرض الكل") }
        items(visible, key = { it.id }) { HotelCard(it) }
    }
}

@Composable private fun Header() = Box(Modifier.fillMaxWidth().background(Brush.verticalGradient(listOf(Primary, Color(0xFF166477)))).padding(20.dp, 58.dp, 20.dp, 32.dp)) {
    Column { Text("أهلاً بك 👋", color = Color.White.copy(alpha = .85f)); Spacer(Modifier.height(6.dp)); Text("إلى أين تريد أن تذهب؟", color = Color.White, style = MaterialTheme.typography.headlineSmall) }
}

@Composable private fun SearchCard(onClick: () -> Unit) = Card(Modifier.fillMaxWidth().padding(horizontal = 20.dp).offset(y = (-16).dp).clickable(onClick = onClick), shape = RoundedCornerShape(18.dp), elevation = CardDefaults.cardElevation(6.dp)) {
    Row(Modifier.padding(16.dp), verticalAlignment = Alignment.CenterVertically) { Icon(Icons.Default.Search, null, tint = Primary, modifier = Modifier.size(26.dp)); Spacer(Modifier.width(12.dp)); Column { Text("ابحث عن فندق أو شقة", fontWeight = FontWeight.Bold); Text("المدينة، التواريخ والضيوف", color = MutedText, style = MaterialTheme.typography.bodyMedium) } }
}

@Composable private fun OfferCard() = Card(Modifier.fillMaxWidth().padding(20.dp), colors = CardDefaults.cardColors(containerColor = Accent), shape = RoundedCornerShape(20.dp)) {
    Row(Modifier.padding(18.dp), verticalAlignment = Alignment.CenterVertically) { Text("✈️", fontSize = 35.sp); Spacer(Modifier.width(12.dp)); Column(Modifier.weight(1f)) { Text("عروض الصيف", color = Color.White, fontWeight = FontWeight.Bold, style = MaterialTheme.typography.titleMedium); Text("وفّر حتى 25% على إقامتك القادمة", color = Color.White.copy(.88f)) }; Text("اكتشف", color = Color.White, fontWeight = FontWeight.Bold) }
}

@Composable private fun HotelCard(hotel: Hotel) = Card(Modifier.fillMaxWidth().padding(horizontal = 20.dp, vertical = 7.dp), shape = RoundedCornerShape(18.dp)) {
    Row(Modifier.padding(12.dp), verticalAlignment = Alignment.CenterVertically) { Box(Modifier.size(86.dp).clip(RoundedCornerShape(14.dp)).background(PrimaryContainer), Alignment.Center) { Text(hotel.imageEmoji, fontSize = 38.sp) }; Spacer(Modifier.width(13.dp)); Column(Modifier.weight(1f)) { hotel.tag?.let { Text(it, color = Accent, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.Bold) }; Text(hotel.name, fontWeight = FontWeight.Bold, maxLines = 1, overflow = TextOverflow.Ellipsis); Row(verticalAlignment = Alignment.CenterVertically) { Icon(Icons.Default.LocationOn, null, tint = MutedText, modifier = Modifier.size(14.dp)); Text("${hotel.area}، ${hotel.governorate}", color = MutedText, style = MaterialTheme.typography.bodyMedium) }; Text("★ ${hotel.rating} (${hotel.reviews})", color = Warning, style = MaterialTheme.typography.bodyMedium) }; Column(horizontalAlignment = Alignment.End) { Text("${hotel.pricePerNight / 1000} ألف", fontWeight = FontWeight.Bold, color = Primary); Text("د.ع / ليلة", color = MutedText, style = MaterialTheme.typography.bodyMedium) } }
}
