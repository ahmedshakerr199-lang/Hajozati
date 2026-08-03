package com.hjozaty.app.presentation.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable

/** Application Material theme. Dark mode remains opt-in until product enables it. */
@Composable
fun HjozatyTheme(useDarkTheme: Boolean = false, content: @Composable () -> Unit) {
    MaterialTheme(colorScheme = if (useDarkTheme) DarkColors else LightColors, typography = HjozatyTypography, shapes = HjozatyShapes, content = content)
}
