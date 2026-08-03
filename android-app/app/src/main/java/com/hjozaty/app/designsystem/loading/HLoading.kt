package com.hjozaty.app.designsystem.loading

import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.hjozaty.app.designsystem.buttons.HOutlinedButton
import com.hjozaty.app.presentation.theme.HSpacing
import com.hjozaty.app.presentation.theme.MutedText

/** Standard indeterminate loading indicator. */
@Composable fun HLoadingIndicator(modifier: Modifier = Modifier) = Box(modifier.fillMaxWidth().padding(HSpacing.xl), Alignment.Center) { CircularProgressIndicator() }

/** Lightweight animated placeholder for lazy content. */
@Composable fun HSkeletonLoader(modifier: Modifier = Modifier, height: Dp = 20.dp) { val transition = rememberInfiniteTransition(label = "skeleton"); val alpha by transition.animateFloat(0.35f, 0.8f, infiniteRepeatable(tween(850, easing = LinearEasing), RepeatMode.Reverse), label = "skeletonAlpha"); Box(modifier.fillMaxWidth().height(height).alpha(alpha).clip(RoundedCornerShape(8.dp)).background(MaterialTheme.colorScheme.surfaceVariant)) }

/** Neutral empty state used when a feature has no data to show. */
@Composable fun HEmptyState(title: String, description: String, modifier: Modifier = Modifier, icon: String = "🧳", actionLabel: String? = null, onAction: (() -> Unit)? = null) = Column(modifier.fillMaxWidth().padding(HSpacing.xxl), horizontalAlignment = Alignment.CenterHorizontally) { Text(icon, fontSize = 60.sp); Spacer(Modifier.height(HSpacing.sm)); Text(title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold); Spacer(Modifier.height(HSpacing.xs)); Text(description, color = MutedText); if (actionLabel != null && onAction != null) { Spacer(Modifier.height(HSpacing.md)); HOutlinedButton(actionLabel, onAction) } }

/** Pull-to-refresh host; feature state and refresh action stay in the ViewModel. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable fun HRefreshContainer(isRefreshing: Boolean, onRefresh: () -> Unit, modifier: Modifier = Modifier, content: @Composable BoxScope.() -> Unit) = PullToRefreshBox(isRefreshing, onRefresh, modifier, content = content)
