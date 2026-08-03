package com.hjozaty.app.navigation

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.core.tween
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.hjozaty.app.presentation.account.AccountScreen
import com.hjozaty.app.presentation.bookings.BookingsScreen
import com.hjozaty.app.presentation.home.HomeScreen
import com.hjozaty.app.presentation.search.SearchScreen
import com.hjozaty.app.presentation.splash.SplashScreen
import com.hjozaty.app.designsystem.HBottomNavigation

@Composable
fun HjozatyNavGraph() {
    val navController = rememberNavController()
    val route = navController.currentBackStackEntryAsState().value?.destination?.route
    Scaffold(
        bottomBar = {
            if (route != Destination.Splash.route) HBottomNavigation(bottomDestinations, route) { destination -> navController.navigate(destination.route) { launchSingleTop = true; restoreState = true; popUpTo(Destination.Home.route) { saveState = true } } }
        }
    ) { padding ->
        NavHost(navController, Destination.Splash.route, Modifier.padding(padding), enterTransition = { fadeIn(tween(220)) + slideInHorizontally(tween(220)) { it / 12 } }, exitTransition = { fadeOut(tween(160)) + slideOutHorizontally(tween(160)) { -it / 12 } }, popEnterTransition = { fadeIn(tween(220)) }, popExitTransition = { fadeOut(tween(160)) }) {
            composable(Destination.Splash.route) { SplashScreen { navController.navigate(Destination.Home.route) { popUpTo(Destination.Splash.route) { inclusive = true } } } }
            composable(Destination.Home.route) { HomeScreen(onSearchClick = { navController.navigate(Destination.Search.route) }) }
            composable(Destination.Search.route) { SearchScreen() }
            composable(Destination.Bookings.route) { BookingsScreen() }
            composable(Destination.Account.route) { AccountScreen() }
        }
    }
}
