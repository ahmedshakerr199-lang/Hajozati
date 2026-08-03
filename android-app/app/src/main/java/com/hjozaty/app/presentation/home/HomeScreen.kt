package com.hjozaty.app.presentation.home

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.Crossfade
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CalendarMonth
import androidx.compose.material.icons.filled.FavoriteBorder
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.NotificationsNone
import androidx.compose.material.icons.filled.PeopleOutline
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import coil.compose.AsyncImage
import com.hjozaty.app.designsystem.cards.HCard
import com.hjozaty.app.designsystem.hotel.HPriceTag
import com.hjozaty.app.designsystem.hotel.HRatingBar
import com.hjozaty.app.designsystem.hotel.HSectionTitle
import com.hjozaty.app.designsystem.loading.HEmptyState
import com.hjozaty.app.designsystem.loading.HSkeletonLoader
import com.hjozaty.app.domain.model.Hotel
import com.hjozaty.app.domain.model.Province
import com.hjozaty.app.presentation.theme.*
import kotlinx.coroutines.delay

/** Premium, responsive discovery home. All content is provided by [HomeViewModel]. */
@Composable
fun HomeScreen(onSearchClick: () -> Unit, viewModel: HomeViewModel = hiltViewModel()) {
    val state by viewModel.uiState.collectAsState()
    AnimatedContent(state, label = "homeContent") { current -> when (current) {
        HomeUiState.Loading -> HomeSkeleton()
        is HomeUiState.Error -> HomeError(current.message)
        is HomeUiState.Content -> HomeContent(current, onSearchClick)
    } }
}

@Composable private fun HomeContent(state: HomeUiState.Content, onSearchClick: () -> Unit) = LazyColumn(Modifier.fillMaxSize().background(AppBackground), contentPadding = PaddingValues(bottom = 28.dp)) {
    item { HomeTopBar() }
    item { WelcomeSection() }
    item { SearchCard(onSearchClick) }
    item { PromoCarousel() }
    item { HSectionTitle("استكشف المحافظات") }
    item { ProvinceRow(state.provinces) }
    item { HSectionTitle("إقامات مميزة", "عرض الكل") }
    item { FeaturedRow(state.featured) }
    item { HSectionTitle("الأكثر رواجاً") }
    item { PopularRow(state.popular) }
    item { HSectionTitle("مقترحة لك") }
    item { RecommendedGrid(state.recommended) }
}

@Composable private fun HomeTopBar() = Row(Modifier.fillMaxWidth().padding(horizontal = 20.dp, vertical = 14.dp), verticalAlignment = Alignment.CenterVertically) {
    Text("حجوزاتي", color = Primary, style = MaterialTheme.typography.titleLarge, modifier = Modifier.weight(1f))
    IconButton(onClick = {}) { Icon(Icons.Default.NotificationsNone, "الإشعارات", tint = AppText) }
    Box(Modifier.size(36.dp).clip(CircleShape).background(Primary), Alignment.Center) { Text("أ", color = Color.White, fontWeight = FontWeight.Bold) }
}

@Composable private fun WelcomeSection() = Column(Modifier.fillMaxWidth().padding(horizontal = 20.dp, vertical = 10.dp)) { Text("مرحباً أحمد", style = MaterialTheme.typography.titleLarge); Text("إلى أين ستكون رحلتك القادمة؟", color = MutedText, style = MaterialTheme.typography.bodyLarge) }

@Composable private fun SearchCard(onClick: () -> Unit) = HCard(Modifier.fillMaxWidth().padding(20.dp), onClick) { Column(Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) { SearchRow(Icons.Default.Search,"ابحث باسم الفندق"); SearchRow(Icons.Default.LocationOn,"اختر المحافظة"); Row { SearchRow(Icons.Default.CalendarMonth,"الدخول",Modifier.weight(1f)); Spacer(Modifier.width(8.dp)); SearchRow(Icons.Default.CalendarMonth,"المغادرة",Modifier.weight(1f)) }; SearchRow(Icons.Default.PeopleOutline,"الضيوف",Modifier.fillMaxWidth()) } }
@Composable private fun SearchRow(icon: androidx.compose.ui.graphics.vector.ImageVector, label: String, modifier: Modifier = Modifier) = Row(modifier.semantics { contentDescription = label }.background(MaterialTheme.colorScheme.surfaceVariant, MaterialTheme.shapes.small).padding(12.dp), verticalAlignment = Alignment.CenterVertically) { Icon(icon,null,tint=Primary); Spacer(Modifier.width(8.dp)); Text(label, color=MutedText) }

@Composable private fun PromoCarousel() { val banners = listOf("وفر حتى 25% على إقامتك القادمة", "عروض خاصة لعطلة نهاية الأسبوع", "اكتشف أجمل وجهات العراق"); var page by remember { mutableIntStateOf(0) }; LaunchedEffect(Unit) { while(true) { delay(4_000); page=(page+1)%banners.size } }; Column(Modifier.padding(horizontal=20.dp, vertical=6.dp)) { HCard(Modifier.fillMaxWidth()) { Box(Modifier.background(Brush.horizontalGradient(listOf(Primary,Accent))).padding(20.dp)) { Crossfade(banners[page], label="banner") { Text(it,color=Color.White,style=MaterialTheme.typography.titleMedium) } } }; Row(Modifier.fillMaxWidth(), horizontalArrangement=Arrangement.Center) { banners.indices.forEach { index -> Box(Modifier.padding(4.dp).size(if(index==page) 18.dp else 7.dp,7.dp).clip(CircleShape).background(if(index==page) Accent else Outline)) } } } }

@Composable private fun ProvinceRow(provinces: List<Province>) = LazyRow(contentPadding=PaddingValues(horizontal=20.dp), horizontalArrangement=Arrangement.spacedBy(12.dp)) { items(provinces.filter(Province::isFeatured), key={it.id}) { ProvinceCard(it) } }
@Composable private fun ProvinceCard(province: Province) = Column(Modifier.width(88.dp).clickable { }.semantics { contentDescription = "محافظة ${province.nameAr}" }, horizontalAlignment=Alignment.CenterHorizontally) { Box(Modifier.size(64.dp).clip(CircleShape).background(PrimaryContainer),Alignment.Center) { Text(province.nameAr.take(1), color=Primary, fontWeight=FontWeight.Bold, fontSize=22.sp) }; Spacer(Modifier.height(5.dp)); Text(province.nameAr,maxLines=1,overflow=TextOverflow.Ellipsis); Text("${province.hotelsCount} فندق",style=MaterialTheme.typography.bodyMedium,color=MutedText) }

@Composable private fun FeaturedRow(hotels: List<Hotel>) = LazyRow(contentPadding=PaddingValues(horizontal=20.dp), horizontalArrangement=Arrangement.spacedBy(14.dp)) { items(hotels,key={it.id}) { PremiumHotelCard(it,Modifier.width(280.dp)) } }
@Composable private fun PopularRow(hotels: List<Hotel>) = LazyRow(contentPadding=PaddingValues(horizontal=20.dp), horizontalArrangement=Arrangement.spacedBy(12.dp)) { items(hotels,key={it.id}) { CompactHotelCard(it) } }
@Composable private fun RecommendedGrid(hotels: List<Hotel>) = LazyVerticalGrid(columns=GridCells.Adaptive(160.dp), modifier=Modifier.heightIn(max=600.dp).padding(horizontal=20.dp), userScrollEnabled=false, verticalArrangement=Arrangement.spacedBy(12.dp), horizontalArrangement=Arrangement.spacedBy(12.dp)) { items(hotels,key={it.id}) { CompactHotelCard(it,Modifier.fillMaxWidth()) } }

@Composable private fun PremiumHotelCard(hotel: Hotel, modifier: Modifier = Modifier) = HCard(modifier) { Box { AsyncImage(hotel.coverImageUrl,"صورة ${hotel.nameAr}",Modifier.fillMaxWidth().height(165.dp),contentScale=ContentScale.Crop); hotel.discountPercentage?.let { Surface(Modifier.padding(10.dp),color=Accent,shape=MaterialTheme.shapes.small) { Text("خصم $it%",Modifier.padding(horizontal=8.dp,vertical=4.dp),color=Color.White) } }; IconButton(onClick={},Modifier.align(Alignment.TopEnd).padding(4.dp).background(Color.White.copy(.9f),CircleShape)) { Icon(Icons.Default.FavoriteBorder,"إضافة للمفضلة",tint=Accent) } }; Column(Modifier.padding(12.dp)) { Text(hotel.nameAr,fontWeight=FontWeight.Bold,maxLines=1,overflow=TextOverflow.Ellipsis); Text(hotel.cityAr,color=MutedText); Row(verticalAlignment=Alignment.CenterVertically) { HRatingBar(hotel.rating,hotel.reviewsCount); Spacer(Modifier.weight(1f)); HPriceTag(hotel.minimumPricePerNight) }; Text("عرض التفاصيل",color=Primary,fontWeight=FontWeight.Bold,modifier=Modifier.padding(top=8.dp)) } }
@Composable private fun CompactHotelCard(hotel: Hotel, modifier: Modifier = Modifier) = HCard(modifier) { AsyncImage(hotel.coverImageUrl,"صورة ${hotel.nameAr}",Modifier.fillMaxWidth().height(105.dp),contentScale=ContentScale.Crop); Column(Modifier.padding(10.dp)) { Text(hotel.nameAr,fontWeight=FontWeight.Bold,maxLines=1,overflow=TextOverflow.Ellipsis); HRatingBar(hotel.rating); HPriceTag(hotel.minimumPricePerNight) } }

@Composable private fun HomeSkeleton() = LazyColumn(Modifier.fillMaxSize().background(AppBackground).padding(20.dp),verticalArrangement=Arrangement.spacedBy(16.dp)) { items(7) { HSkeletonLoader(height=if(it==0) 160.dp else 100.dp) } }
@Composable private fun HomeError(message: String) = Box(Modifier.fillMaxSize().background(AppBackground),Alignment.Center) { HEmptyState("تعذر تحميل الإقامات",message,actionLabel="إعادة المحاولة",onAction={}) }
