@file:Suppress("LongMethod")

package com.hjozaty.app.designsystem

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.sp
import com.hjozaty.app.domain.model.Hotel
import com.hjozaty.app.navigation.Destination
import com.hjozaty.app.presentation.theme.MutedText
import com.hjozaty.app.presentation.theme.Warning

@Composable
fun HButton(text: String, onClick: () -> Unit, modifier: Modifier = Modifier, enabled: Boolean = true) =
    Button(onClick = onClick, modifier = modifier.heightIn(min = 52.dp), enabled = enabled, shape = MaterialTheme.shapes.medium) { Text(text, style = MaterialTheme.typography.labelLarge) }

@Composable
fun HOutlinedButton(text: String, onClick: () -> Unit, modifier: Modifier = Modifier, enabled: Boolean = true) =
    OutlinedButton(onClick = onClick, modifier = modifier.heightIn(min = 52.dp), enabled = enabled, shape = MaterialTheme.shapes.medium) { Text(text, style = MaterialTheme.typography.labelLarge) }

@Composable
fun HTextField(value: String, onValueChange: (String) -> Unit, placeholder: String, modifier: Modifier = Modifier, leadingIcon: ImageVector? = null, isError: Boolean = false) {
    OutlinedTextField(value = value, onValueChange = onValueChange, modifier = modifier, placeholder = { Text(placeholder) }, leadingIcon = leadingIcon?.let { { Icon(it, null) } }, isError = isError, singleLine = true, shape = MaterialTheme.shapes.medium)
}

@Composable
fun HSearchBar(query: String, onQueryChange: (String) -> Unit, modifier: Modifier = Modifier, placeholder: String = "ابحث عن فندق أو مدينة") =
    HTextField(query, onQueryChange, placeholder, modifier, Icons.Default.Search)

@Composable
fun HCard(modifier: Modifier = Modifier, onClick: (() -> Unit)? = null, content: @Composable ColumnScope.() -> Unit) {
    Card(modifier = modifier.then(if (onClick != null) Modifier.clickable(onClick = onClick) else Modifier), shape = MaterialTheme.shapes.large, colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface), elevation = CardDefaults.cardElevation(defaultElevation = HElevation.card), content = content)
}

@Composable
fun HHotelCard(hotel: Hotel, modifier: Modifier = Modifier, onClick: (() -> Unit)? = null) = HCard(modifier, onClick) {
    Row(Modifier.padding(HSpacing.sm), verticalAlignment = Alignment.CenterVertically) {
        Box(Modifier.size(86.dp).clip(MaterialTheme.shapes.medium).background(MaterialTheme.colorScheme.primaryContainer), Alignment.Center) { Text(hotel.imageEmoji, fontSize = 38.sp) }
        Spacer(Modifier.width(HSpacing.sm))
        Column(Modifier.weight(1f)) {
            hotel.tag?.let { HBadge(it) }
            Text(hotel.name, fontWeight = FontWeight.Bold, maxLines = 1, overflow = TextOverflow.Ellipsis)
            Row(verticalAlignment = Alignment.CenterVertically) { Icon(Icons.Default.LocationOn, null, tint = MutedText, modifier = Modifier.size(14.dp)); Text("${hotel.area}، ${hotel.governorate}", color = MutedText, style = MaterialTheme.typography.bodyMedium, maxLines = 1, overflow = TextOverflow.Ellipsis) }
            HRatingBar(hotel.rating, hotel.reviews)
        }
        HPriceTag(hotel.pricePerNight)
    }
}

@Composable
fun HSectionTitle(title: String, action: String? = null, onActionClick: (() -> Unit)? = null) {
    Row(Modifier.fillMaxWidth().padding(horizontal = HSpacing.lg, vertical = HSpacing.xs), verticalAlignment = Alignment.CenterVertically) {
        Text(title, style = MaterialTheme.typography.titleMedium, modifier = Modifier.weight(1f))
        action?.let { Text(it, color = MaterialTheme.colorScheme.primary, fontWeight = FontWeight.Bold, modifier = Modifier.clickable(enabled = onActionClick != null) { onActionClick?.invoke() }) }
    }
}

@Composable
fun HTopAppBar(title: String, modifier: Modifier = Modifier, navigationIcon: (@Composable (() -> Unit))? = null, actions: @Composable RowScope.() -> Unit = {}) =
    TopAppBar(title = { Text(title, style = MaterialTheme.typography.titleLarge) }, modifier = modifier, navigationIcon = { navigationIcon?.invoke() }, actions = actions, colors = TopAppBarDefaults.topAppBarColors(containerColor = Color.Transparent))

@Composable
fun HBottomNavigation(destinations: List<Destination>, currentRoute: String?, onNavigate: (Destination) -> Unit) = NavigationBar {
    destinations.forEach { destination -> NavigationBarItem(selected = currentRoute == destination.route, onClick = { onNavigate(destination) }, icon = { Icon(destination.icon, destination.label) }, label = { Text(destination.label) }) }
}

@Composable fun HLoadingIndicator(modifier: Modifier = Modifier) = Box(modifier.fillMaxWidth().padding(HSpacing.xl), Alignment.Center) { CircularProgressIndicator() }

/** Standard pull-to-refresh shell; feature screens supply the refresh state and action. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HRefreshContainer(isRefreshing: Boolean, onRefresh: () -> Unit, modifier: Modifier = Modifier, content: @Composable BoxScope.() -> Unit) {
    PullToRefreshBox(isRefreshing = isRefreshing, onRefresh = onRefresh, modifier = modifier, content = content)
}

@Composable
fun HSkeletonLoader(modifier: Modifier = Modifier, height: Dp = 20.dp) {
    val transition = rememberInfiniteTransition(label = "skeleton")
    val alpha by transition.animateFloat(0.35f, 0.8f, infiniteRepeatable(tween(850, easing = LinearEasing), RepeatMode.Reverse), label = "skeletonAlpha")
    Box(modifier.fillMaxWidth().height(height).alpha(alpha).clip(RoundedCornerShape(8.dp)).background(MaterialTheme.colorScheme.surfaceVariant))
}

@Composable
fun HEmptyState(title: String, description: String, modifier: Modifier = Modifier, icon: String = "🧳", actionLabel: String? = null, onAction: (() -> Unit)? = null) {
    Column(modifier.fillMaxWidth().padding(HSpacing.xxl), horizontalAlignment = Alignment.CenterHorizontally) { Text(icon, fontSize = 60.sp); Spacer(Modifier.height(HSpacing.sm)); Text(title, style = MaterialTheme.typography.titleMedium); Spacer(Modifier.height(HSpacing.xs)); Text(description, color = MutedText); if (actionLabel != null && onAction != null) { Spacer(Modifier.height(HSpacing.md)); HOutlinedButton(actionLabel, onAction) } }
}

@Composable
fun HSnackbar(message: String, modifier: Modifier = Modifier, onDismiss: (() -> Unit)? = null) = AnimatedVisibility(message.isNotBlank(), enter = fadeIn() + slideInVertically { it }, exit = fadeOut()) {
    Snackbar(modifier, action = onDismiss?.let { { TextButton(onClick = it) { Text("إغلاق") } } }) { Text(message) }
}

@Composable
fun HDialog(title: String, message: String, confirmText: String, onConfirm: () -> Unit, onDismiss: () -> Unit) = AlertDialog(onDismissRequest = onDismiss, title = { Text(title) }, text = { Text(message) }, confirmButton = { TextButton(onClick = onConfirm) { Text(confirmText) } }, dismissButton = { TextButton(onClick = onDismiss) { Text("إلغاء") } })

@Composable fun HRatingBar(rating: Double, reviews: Int? = null) = Text("★ ${String.format("%.1f", rating)}${reviews?.let { " ($it)" } ?: ""}", color = Warning, style = MaterialTheme.typography.bodyMedium)

@Composable fun HPriceTag(price: Int, modifier: Modifier = Modifier) = Column(modifier, horizontalAlignment = Alignment.End) { Text("${price / 1000} ألف", color = MaterialTheme.colorScheme.primary, fontWeight = FontWeight.Bold); Text("د.ع / ليلة", color = MutedText, style = MaterialTheme.typography.bodyMedium) }

@Composable fun HChip(label: String, selected: Boolean, onClick: () -> Unit, modifier: Modifier = Modifier) = FilterChip(selected = selected, onClick = onClick, modifier = modifier, label = { Text(label) })

@Composable fun HBadge(text: String, modifier: Modifier = Modifier) = Surface(modifier, color = MaterialTheme.colorScheme.secondaryContainer, contentColor = MaterialTheme.colorScheme.onSecondaryContainer, shape = CircleShape) { Text(text, modifier = Modifier.padding(horizontal = HSpacing.xs, vertical = HSpacing.xxs), style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.Bold) }
