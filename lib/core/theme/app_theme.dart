import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary, secondary: AppColors.accent, surface: AppColors.surface, brightness: Brightness.light),
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Tajawal',
    textTheme: const TextTheme(headlineSmall: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700, color: AppColors.text), titleLarge: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700, color: AppColors.text)),
    cardTheme: CardThemeData(color: AppColors.surface, elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
  );
}
