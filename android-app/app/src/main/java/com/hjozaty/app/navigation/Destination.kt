package com.hjozaty.app.navigation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material.icons.filled.BookmarkBorder
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Search
import androidx.compose.ui.graphics.vector.ImageVector

sealed class Destination(val route: String, val label: String, val icon: ImageVector) {
    data object Splash : Destination("splash", "", Icons.Default.Home)
    data object Home : Destination("home", "الرئيسية", Icons.Default.Home)
    data object Search : Destination("search", "البحث", Icons.Default.Search)
    data object Bookings : Destination("bookings", "الحجوزات", Icons.Default.BookmarkBorder)
    data object Account : Destination("account", "حسابي", Icons.Default.AccountCircle)
}

val bottomDestinations = listOf(Destination.Home, Destination.Search, Destination.Bookings, Destination.Account)
