package com.hjozaty.app.designsystem.navigation

import androidx.compose.foundation.layout.RowScope
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import com.hjozaty.app.navigation.Destination

/** Shared top app bar with optional back affordance and action slot. */
@Composable fun HTopAppBar(title: String, modifier: Modifier = Modifier, navigationIcon: (@Composable (() -> Unit))? = null, actions: @Composable RowScope.() -> Unit = {}) = TopAppBar(title = { Text(title, style = MaterialTheme.typography.titleLarge) }, modifier = modifier, navigationIcon = { navigationIcon?.invoke() }, actions = actions, colors = TopAppBarDefaults.topAppBarColors(containerColor = Color.Transparent))

/** Navigation shell for the application's root destinations. */
@Composable fun HBottomNavigation(destinations: List<Destination>, currentRoute: String?, onNavigate: (Destination) -> Unit) = NavigationBar { destinations.forEach { destination -> NavigationBarItem(selected = currentRoute == destination.route, onClick = { onNavigate(destination) }, icon = { Icon(destination.icon, destination.label) }, label = { Text(destination.label) }) } }
