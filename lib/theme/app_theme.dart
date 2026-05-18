import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData light() {
    final cs = ColorScheme.fromSeed(
      seedColor: AppColors.aqua,
      primary: AppColors.aqua,
      secondary: AppColors.seaGrass,
      surface: AppColors.white,
      onSurface: AppColors.ink,
      surfaceContainerLowest: AppColors.mint,
      surfaceContainer: AppColors.lightBlue,
    );

    final theme = _baseTheme(
      cs: cs,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: cs.onSurface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.teal,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 26,
            color: states.contains(WidgetState.selected)
                ? AppColors.white
                : AppColors.teal,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? AppColors.white
                : AppColors.teal,
          ),
        ),
      ),
      dividerColor: AppColors.aqua.withValues(alpha: .2),
    );

    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.aqua.withValues(alpha: .35)),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final cs = ColorScheme.fromSeed(
      seedColor: AppColors.deepBlue,
      brightness: Brightness.dark,
      primary: AppColors.aqua,
      secondary: AppColors.seaGrass,
      surface: const Color(0xFF0F1B2D),
      onSurface: AppColors.white,
    );

    return _baseTheme(
      cs: cs,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: cs.onSurface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF0F1B2D),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
        indicatorColor: Color(0x3300AEEF),
      ),
      dividerColor: Colors.white24,
    );
  }

  static ThemeData _baseTheme({
    required ColorScheme cs,
    required AppBarTheme appBarTheme,
    required CardThemeData cardTheme,
    required NavigationBarThemeData navigationBarTheme,
    required Color dividerColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      textTheme: AppTypography.textTheme(cs),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.teal,
      ),

      scaffoldBackgroundColor: Colors.transparent,

      appBarTheme: appBarTheme,

      cardTheme: cardTheme,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.aqua,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      navigationBarTheme: navigationBarTheme,

      dividerColor: dividerColor,
    );
  }
}