package com.hjozaty.app.presentation.bookings

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.hjozaty.app.designsystem.HEmptyState
import com.hjozaty.app.designsystem.HTopAppBar
import com.hjozaty.app.presentation.theme.*

@Composable fun BookingsScreen() = Column(Modifier.fillMaxSize().background(AppBackground).padding(20.dp).padding(top = 34.dp)) {
    HTopAppBar("حجوزاتي")
    Spacer(Modifier.height(28.dp))
    HEmptyState("لا توجد حجوزات حالية", "ستظهر تفاصيل حجوزاتك القادمة هنا فور تأكيدها.")
}
