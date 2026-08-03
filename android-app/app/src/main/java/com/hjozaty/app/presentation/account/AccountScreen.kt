package com.hjozaty.app.presentation.account

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.FavoriteBorder
import androidx.compose.material.icons.filled.HelpOutline
import androidx.compose.material.icons.filled.PersonOutline
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.hjozaty.app.designsystem.cards.HCard
import com.hjozaty.app.designsystem.navigation.HTopAppBar
import com.hjozaty.app.presentation.theme.*

@Composable fun AccountScreen() = Column(Modifier.fillMaxSize().background(AppBackground).padding(20.dp).padding(top = 34.dp)) {
    HTopAppBar("حسابي"); Spacer(Modifier.height(24.dp))
    Row(verticalAlignment = Alignment.CenterVertically) { Box(Modifier.size(62.dp).clip(CircleShape).background(Primary), Alignment.Center) { Text("ض", color = Color.White, fontSize = 25.sp, fontWeight = FontWeight.Bold) }; Spacer(Modifier.width(14.dp)); Column { Text("مرحباً بك في حجوزاتي", fontWeight = FontWeight.Bold); Text("سجّل الدخول لمتابعة حجوزاتك", color = MutedText) } }
    Spacer(Modifier.height(24.dp)); Item(Icons.Default.PersonOutline, "تسجيل الدخول أو إنشاء حساب"); Item(Icons.Default.FavoriteBorder, "المفضلة"); Item(Icons.Default.HelpOutline, "الدعم والمساعدة")
}
@Composable private fun Item(icon: androidx.compose.ui.graphics.vector.ImageVector, title: String) = HCard(Modifier.fillMaxWidth().padding(vertical = 5.dp)) { Row(Modifier.padding(16.dp), verticalAlignment = Alignment.CenterVertically) { Icon(icon, null, tint = Primary); Spacer(Modifier.width(14.dp)); Text(title, Modifier.weight(1f), fontWeight = FontWeight.SemiBold); Text("‹", color = MutedText, fontSize = 26.sp) } }
