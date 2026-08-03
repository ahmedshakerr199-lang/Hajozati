package com.hjozaty.app.designsystem.badges

import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import com.hjozaty.app.presentation.theme.HSpacing

/** Compact metadata label for hotel promotions and status. */
@Composable fun HBadge(text: String, modifier: Modifier = Modifier) = Surface(modifier, color = MaterialTheme.colorScheme.secondaryContainer, contentColor = MaterialTheme.colorScheme.onSecondaryContainer, shape = CircleShape) { Text(text, Modifier.padding(horizontal = HSpacing.xs, vertical = HSpacing.xxs), style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.Bold) }
