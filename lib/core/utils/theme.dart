import 'package:flutter/material.dart';

class AppColors {
  // Primary (بنفسجي داكن)
  static const Color primary = Color(0xFF5B2EFF);

  // درجات مساعدة
  static const Color primaryDark = Color(0xFF3F1ECF);
  static const Color primaryLight = Color(0xFF7C5CFF);

  // Accent (للتمييز فقط)
  static const Color accent = Color(0xFFFFC857); // ذهبي هادئ

  // Neutral
  static const Color backgroundLight = Color(0xFFF6F7FB);
  static const Color backgroundDark = Color(0xFF0F1021);

  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1A1B2E);

  static const Color textPrimaryLight = Color(0xFF1C1C1E);
  static const Color textPrimaryDark = Color(0xFFEDEDED);

  static const Color textSecondaryLight = Color(0xFF6E6E73);
  static const Color textSecondaryDark = Color(0xFF9E9EA7);

  static const Color error = Color(0xFFE5484D);
}

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  primaryColor: AppColors.primary,

  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    surface: AppColors.surfaceLight,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textPrimaryLight,
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.surfaceLight,
    elevation: 0,
    centerTitle: false,
    iconTheme: IconThemeData(color: AppColors.primary),
    titleTextStyle: TextStyle(
      color: AppColors.textPrimaryLight,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),

  cardTheme: CardThemeData(
    color: AppColors.surfaceLight,
    elevation: 2,
    shadowColor: AppColors.primary.withOpacity(0.08),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceLight,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
    ),
    hintStyle: TextStyle(color: AppColors.textSecondaryLight),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),

  textTheme: TextTheme(
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryLight,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: AppColors.textPrimaryLight),
    bodySmall: TextStyle(fontSize: 14, color: AppColors.textSecondaryLight),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.surfaceLight,
    contentTextStyle: TextStyle(color: AppColors.textPrimaryLight),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),

  dividerTheme: DividerThemeData(color: AppColors.primary.withOpacity(0.08), thickness: 1),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  primaryColor: AppColors.primaryLight,

  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryLight,
    secondary: AppColors.accent,
    surface: AppColors.surfaceDark,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textPrimaryDark,
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.surfaceDark,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.primaryLight),
    titleTextStyle: TextStyle(
      color: AppColors.textPrimaryDark,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryLight,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),

  cardTheme: CardThemeData(
    color: AppColors.surfaceDark,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
    ),
    hintStyle: TextStyle(color: AppColors.textSecondaryDark),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),

  textTheme: TextTheme(
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryDark,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: AppColors.textPrimaryDark),
    bodySmall: TextStyle(fontSize: 14, color: AppColors.textSecondaryDark),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.surfaceDark,
    contentTextStyle: TextStyle(color: AppColors.textPrimaryDark),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);
