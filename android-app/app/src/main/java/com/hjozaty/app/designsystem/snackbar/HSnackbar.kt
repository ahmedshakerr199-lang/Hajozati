package com.hjozaty.app.designsystem.snackbar

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.material3.Snackbar
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier

/** Animated transient message that does not expose exception details. */
@Composable fun HSnackbar(message: String, modifier: Modifier = Modifier, onDismiss: (() -> Unit)? = null) = AnimatedVisibility(message.isNotBlank(), enter = fadeIn() + slideInVertically { it }, exit = fadeOut()) { Snackbar(modifier, action = onDismiss?.let { { TextButton(onClick = it) { Text("إغلاق") } } }) { Text(message) } }
