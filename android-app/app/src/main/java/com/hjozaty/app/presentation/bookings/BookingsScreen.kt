package com.hjozaty.app.presentation.bookings

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CalendarMonth
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.hjozaty.app.presentation.theme.*

@Composable fun BookingsScreen() = Column(Modifier.fillMaxSize().background(AppBackground).padding(20.dp).padding(top = 34.dp)) {
    Text("حجوزاتي", style = MaterialTheme.typography.headlineSmall, color = Primary)
    Spacer(Modifier.height(22.dp))
    Card(Modifier.fillMaxWidth(), shape = RoundedCornerShape(20.dp)) { Column(Modifier.padding(20.dp)) { Row(verticalAlignment = Alignment.CenterVertically) { Icon(Icons.Default.CalendarMonth, null, tint = Primary); Spacer(Modifier.width(9.dp)); Text("لا توجد حجوزات حالية", fontWeight = FontWeight.Bold) }; Spacer(Modifier.height(8.dp)); Text("ستظهر تفاصيل حجوزاتك القادمة هنا فور تأكيدها.", color = MutedText) } }
    Spacer(Modifier.height(32.dp)); Box(Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) { Text("🧳", fontSize = 70.sp) }
}
