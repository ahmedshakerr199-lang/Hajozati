package com.hjozaty.app.designsystem.dialogs

import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable

/** Shared confirmation dialog that keeps Arabic action labels consistent. */
@Composable fun HDialog(title: String, message: String, confirmText: String, onConfirm: () -> Unit, onDismiss: () -> Unit) = AlertDialog(onDismissRequest = onDismiss, title = { Text(title) }, text = { Text(message) }, confirmButton = { TextButton(onClick = onConfirm) { Text(confirmText) } }, dismissButton = { TextButton(onClick = onDismiss) { Text("إلغاء") } })
