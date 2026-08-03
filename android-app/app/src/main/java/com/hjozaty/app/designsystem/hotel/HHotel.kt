package com.hjozaty.app.designsystem.hotel

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.sp
import com.hjozaty.app.designsystem.badges.HBadge
import com.hjozaty.app.designsystem.cards.HCard
import com.hjozaty.app.domain.model.Hotel
import com.hjozaty.app.presentation.theme.HDimensions
import com.hjozaty.app.presentation.theme.HSpacing
import com.hjozaty.app.presentation.theme.MutedText
import com.hjozaty.app.presentation.theme.PrimaryContainer
import com.hjozaty.app.presentation.theme.Warning

/** Reusable hotel summary card backed by the domain [Hotel] model. */
@Composable fun HHotelCard(hotel: Hotel, modifier: Modifier = Modifier, onClick: (() -> Unit)? = null) = HCard(modifier, onClick) { Row(Modifier.padding(HSpacing.sm), verticalAlignment = Alignment.CenterVertically) { Box(Modifier.size(HDimensions.hotelThumbnail).clip(MaterialTheme.shapes.medium).background(PrimaryContainer), Alignment.Center) { Text("🏨", fontSize = 38.sp) }; Spacer(Modifier.width(HSpacing.sm)); Column(Modifier.weight(1f)) { hotel.discountPercentage?.let { HBadge("خصم $it%") }; Text(hotel.nameAr, fontWeight = FontWeight.Bold, maxLines = 1, overflow = TextOverflow.Ellipsis); Row(verticalAlignment = Alignment.CenterVertically) { Icon(Icons.Default.LocationOn, null, tint = MutedText, modifier = Modifier.size(HSpacing.sm)); Text("${hotel.cityAr}، ${hotel.addressAr}", color = MutedText, style = MaterialTheme.typography.bodyMedium, maxLines = 1, overflow = TextOverflow.Ellipsis) }; HRatingBar(hotel.rating, hotel.reviewsCount) }; HPriceTag(hotel.minimumPricePerNight) } }

/** Compact rating display with optional review count. */
@Composable fun HRatingBar(rating: Double, reviews: Int? = null) = Text("★ ${String.format("%.1f", rating)}${reviews?.let { " ($it)" } ?: ""}", color = Warning, style = MaterialTheme.typography.bodyMedium)

/** Consistent Iraqi-dinar price treatment. */
@Composable fun HPriceTag(price: Long, modifier: Modifier = Modifier) = Column(modifier, horizontalAlignment = Alignment.End) { Text("${price / 1000} ألف", color = MaterialTheme.colorScheme.primary, fontWeight = FontWeight.Bold); Text("د.ع / ليلة", color = MutedText, style = MaterialTheme.typography.bodyMedium) }

/** Consistent section heading with optional actionable label. */
@Composable fun HSectionTitle(title: String, action: String? = null, onActionClick: (() -> Unit)? = null) = Row(Modifier.fillMaxWidth().padding(horizontal = HSpacing.lg, vertical = HSpacing.xs), verticalAlignment = Alignment.CenterVertically) { Text(title, style = MaterialTheme.typography.titleMedium, modifier = Modifier.weight(1f)); action?.let { Text(it, color = MaterialTheme.colorScheme.primary, fontWeight = FontWeight.Bold) } }
