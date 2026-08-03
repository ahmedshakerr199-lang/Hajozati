package com.hjozaty.app.designsystem.chips

import androidx.compose.material3.FilterChip
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier

/** Selectable filtering chip. */
@Composable fun HChip(label: String, selected: Boolean, onClick: () -> Unit, modifier: Modifier = Modifier) = FilterChip(selected, onClick, modifier, label = { Text(label) })
