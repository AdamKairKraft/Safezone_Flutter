import 'package:flutter/material.dart';

/// Mirrors the :root palette in `SafeZone Wireframe.html` and safezone-web's Tailwind
/// tokens, so the tablet app reads as the same product rather than a reskin.
class AppColors {
  AppColors._();

  static const navy = Color(0xFF1B2230);
  static const navyHover = Color(0xFF242C3D);
  static const blue = Color(0xFF2563EB);
  static const blueDark = Color(0xFF1D4ED8);
  static const green = Color(0xFF16A34A);
  static const greenBg = Color(0xFFDCFCE7);
  static const amber = Color(0xFFD97706);
  static const amberBg = Color(0xFFFEF3C7);
  static const red = Color(0xFFDC2626);
  static const redBg = Color(0xFFFEE2E2);
  static const greyBg = Color(0xFFF1F5F9);
  static const greyBg2 = Color(0xFFE2E8F0);
  static const border = Color(0xFFE5E7EB);
  static const text = Color(0xFF111827);
  static const sub = Color(0xFF6B7280);
  static const grey = Color(0xFF9CA3AF);
  static const warnBg = Color(0xFFFEF9C3);
  static const warnText = Color(0xFF713F12);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blue,
        primary: AppColors.blue,
        onPrimary: Colors.white,
        error: AppColors.red,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: AppColors.text, displayColor: AppColors.text),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.greyBg, thickness: 1, space: 1),
    );
  }
}
