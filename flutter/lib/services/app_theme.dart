import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1348D4);
  static const primaryDark = Color(0xFF0D3AAA);
  static const primaryLight = Color(0xFFE8EEFF);
  static const green = Color(0xFF00875A);
  static const greenLight = Color(0xFFE3FCF5);
  static const orange = Color(0xFFFF5630);
  static const orangeLight = Color(0xFFFFF0EB);
  static const amber = Color(0xFFFF991F);
  static const amberLight = Color(0xFFFFF7E6);
  static const bg = Color(0xFFF4F6FB);
  static const textPrimary = Color(0xFF0A1628);
  static const textSecondary = Color(0xFF6B7A99);
  static const border = Color(0xFFE4E9F2);
  static const whatsapp = Color(0xFF25D366);
  static const whatsappDark = Color(0xFF075E54);
}

ThemeData buildAppTheme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hintStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
      ),
    ),
    // FIX: Use CardThemeData instead of CardTheme (Flutter 3.22+)
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
  );
}