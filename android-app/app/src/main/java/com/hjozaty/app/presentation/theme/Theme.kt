package com.hjozaty.app.presentation.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.sp
import com.hjozaty.app.R
import com.hjozaty.app.designsystem.HShapes

private val LightColors = lightColorScheme(
    primary = Primary, onPrimary = Color.White, primaryContainer = PrimaryContainer,
    onPrimaryContainer = AppText, secondary = Accent, onSecondary = Color.White,
    background = AppBackground, onBackground = AppText, surface = AppSurface,
    onSurface = AppText, surfaceVariant = Color(0xFFEAF0F0), onSurfaceVariant = MutedText,
    outline = Outline, error = Danger, onError = Color.White
)

private val DarkColors = androidx.compose.material3.darkColorScheme(
    primary = Color(0xFF8FD4DF), onPrimary = Color(0xFF003640),
    secondary = Color(0xFFFFB68A), onSecondary = Color(0xFF4A1B00),
    background = Color(0xFF101719), onBackground = Color(0xFFE2E9EA),
    surface = Color(0xFF182022), onSurface = Color(0xFFE2E9EA),
    surfaceVariant = Color(0xFF314649), onSurfaceVariant = Color(0xFFC0CFD1),
    error = Color(0xFFFFB4AB), onError = Color(0xFF690005)
)

private val Cairo = FontFamily(Font(R.font.cairo_variable))
private val Tajawal = FontFamily(Font(R.font.tajawal_regular, FontWeight.Normal), Font(R.font.tajawal_bold, FontWeight.Bold))

private val HjozatyTypography = androidx.compose.material3.Typography(
    headlineSmall = TextStyle(fontFamily = Cairo, fontWeight = FontWeight.Bold, fontSize = 26.sp),
    titleLarge = TextStyle(fontFamily = Cairo, fontWeight = FontWeight.Bold, fontSize = 21.sp),
    titleMedium = TextStyle(fontFamily = Cairo, fontWeight = FontWeight.SemiBold, fontSize = 17.sp),
    bodyLarge = TextStyle(fontFamily = Tajawal, fontSize = 16.sp),
    bodyMedium = TextStyle(fontFamily = Tajawal, fontSize = 14.sp),
    labelLarge = TextStyle(fontFamily = Tajawal, fontWeight = FontWeight.Bold, fontSize = 14.sp)
)

/** The default remains light while dark mode can be enabled without feature changes. */
@Composable
fun HjozatyTheme(useDarkTheme: Boolean = false, content: @Composable () -> Unit) {
    MaterialTheme(colorScheme = if (useDarkTheme) DarkColors else LightColors, typography = HjozatyTypography, shapes = HShapes, content = content)
}
