package com.hjozaty.app.designsystem.inputs

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector

/** Consistent validated single-line text input. */
@Composable fun HTextField(value: String, onValueChange: (String) -> Unit, placeholder: String, modifier: Modifier = Modifier, leadingIcon: ImageVector? = null, isError: Boolean = false) = OutlinedTextField(value, onValueChange, modifier, placeholder = { Text(placeholder) }, leadingIcon = leadingIcon?.let { { Icon(it, null) } }, isError = isError, singleLine = true, shape = MaterialTheme.shapes.medium)

/** Search specialization of [HTextField]. */
@Composable fun HSearchBar(query: String, onQueryChange: (String) -> Unit, modifier: Modifier = Modifier, placeholder: String = "ابحث عن فندق أو مدينة") = HTextField(query, onQueryChange, placeholder, modifier, Icons.Default.Search)
