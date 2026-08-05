import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.danger,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.text,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Tajawal',
        textTheme: const TextTheme(
            displaySmall: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppColors.text),
            headlineSmall: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w700,
                color: AppColors.text),
            titleLarge: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w700,
                color: AppColors.text)),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.header,
          foregroundColor: AppColors.text,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: AppColors.text),
        ),
        cardTheme: CardThemeData(
            color: AppColors.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.card))),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.searchField,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.field),
              borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.field),
              borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.field),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
        filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.field)),
          textStyle: const TextStyle(
              fontFamily: 'Tajawal', fontWeight: FontWeight.w700),
        )),
      );
}
