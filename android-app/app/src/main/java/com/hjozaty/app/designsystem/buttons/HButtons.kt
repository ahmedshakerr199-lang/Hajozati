package com.hjozaty.app.designsystem.buttons

import androidx.compose.foundation.layout.heightIn
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import com.hjozaty.app.presentation.theme.HDimensions

/** Primary action button with the application's minimum touch target. */
@Composable fun HButton(text: String, onClick: () -> Unit, modifier: Modifier = Modifier, enabled: Boolean = true) = Button(onClick, modifier.heightIn(min = HDimensions.buttonHeight), enabled = enabled, shape = MaterialTheme.shapes.medium) { Text(text, style = MaterialTheme.typography.labelLarge) }

/** Secondary outlined action button. */
@Composable fun HOutlinedButton(text: String, onClick: () -> Unit, modifier: Modifier = Modifier, enabled: Boolean = true) = OutlinedButton(onClick, modifier.heightIn(min = HDimensions.buttonHeight), enabled = enabled, shape = MaterialTheme.shapes.medium) { Text(text, style = MaterialTheme.typography.labelLarge) }
