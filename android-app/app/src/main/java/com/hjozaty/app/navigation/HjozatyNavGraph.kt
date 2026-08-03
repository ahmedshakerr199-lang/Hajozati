package com.hjozaty.app.navigation

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
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

@Composable
fun HjozatyNavGraph() {
    val navController = rememberNavController()
    val route = navController.currentBackStackEntryAsState().value?.destination?.route
    Scaffold(
        containerColor = MaterialTheme.colorScheme.background,
        bottomBar = {
            if (route != Destination.Splash.route) NavigationBar {
                bottomDestinations.forEach { destination ->
                    NavigationBarItem(
                        selected = route == destination.route,
                        onClick = { navController.navigate(destination.route) { launchSingleTop = true; restoreState = true; popUpTo(Destination.Home.route) { saveState = true } } },
                        icon = { Icon(destination.icon, contentDescription = destination.label) },
                        label = { Text(destination.label) }
                    )
                }
            }
        }
    ) { padding ->
        NavHost(navController, Destination.Splash.route, Modifier.padding(padding)) {
            composable(Destination.Splash.route) { SplashScreen { navController.navigate(Destination.Home.route) { popUpTo(Destination.Splash.route) { inclusive = true } } } }
            composable(Destination.Home.route) { HomeScreen(onSearchClick = { navController.navigate(Destination.Search.route) }) }
            composable(Destination.Search.route) { SearchScreen() }
            composable(Destination.Bookings.route) { BookingsScreen() }
            composable(Destination.Account.route) { AccountScreen() }
        }
    }
}
