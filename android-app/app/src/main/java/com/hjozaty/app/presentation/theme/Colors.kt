package com.hjozaty.app.presentation.theme

import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.ui.graphics.Color

/** حجوزاتي brand colors, named by semantic role rather than individual screens. */
val Primary = Color(0xFF0F4C5C)
val Accent = Color(0xFFE36414)
val AppBackground = Color(0xFFF4F7F6)
val AppSurface = Color(0xFFFFFFFF)
val AppText = Color(0xFF1D2D44)
val Success = Color(0xFF2E9E5B)
val Warning = Color(0xFFD99A0B)
val Danger = Color(0xFFD63B3B)
val PrimaryContainer = Color(0xFFD4EEF2)
val MutedText = Color(0xFF64748B)
val Outline = Color(0xFFD8E1E2)

internal val LightColors = lightColorScheme(
    primary = Primary, onPrimary = Color.White, primaryContainer = PrimaryContainer, onPrimaryContainer = AppText,
    secondary = Accent, onSecondary = Color.White, background = AppBackground, onBackground = AppText,
    surface = AppSurface, onSurface = AppText, surfaceVariant = Color(0xFFEAF0F0), onSurfaceVariant = MutedText,
    outline = Outline, error = Danger, onError = Color.White
)

internal val DarkColors = darkColorScheme(
    primary = Color(0xFF8FD4DF), onPrimary = Color(0xFF003640), secondary = Color(0xFFFFB68A), onSecondary = Color(0xFF4A1B00),
    background = Color(0xFF101719), onBackground = Color(0xFFE2E9EA), surface = Color(0xFF182022), onSurface = Color(0xFFE2E9EA),
    surfaceVariant = Color(0xFF314649), onSurfaceVariant = Color(0xFFC0CFD1), error = Color(0xFFFFB4AB), onError = Color(0xFF690005)
)
