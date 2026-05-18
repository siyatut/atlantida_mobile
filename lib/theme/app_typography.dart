import 'package:flutter/material.dart';

class AppTypography {
  static const _baseFamily = 'SF Pro Display';

  static TextTheme textTheme(ColorScheme cs) => TextTheme(

        headlineSmall: TextStyle(
          fontFamily: _baseFamily,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          height: 1.15,
          letterSpacing: 0.1,
          color: cs.onSurface,
        ),

        titleLarge: TextStyle(
          fontFamily: _baseFamily,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          height: 1.15,
          letterSpacing: 0.1,
          color: cs.onSurface,
        ),

        titleMedium: TextStyle(
          fontFamily: _baseFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          height: 1.20,
          letterSpacing: 0.05,
          color: cs.onSurface,
        ),

        titleSmall: TextStyle(
          fontFamily: _baseFamily,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          height: 1.22,
          letterSpacing: 0.03,
          color: cs.onSurface,
        ),

        bodyLarge: TextStyle(
          fontFamily: _baseFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.35,
          letterSpacing: 0.0,
          color: cs.onSurface,
        ),

        bodyMedium: TextStyle(
          fontFamily: _baseFamily,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.35,
          letterSpacing: 0.0,
          color: cs.onSurface,
        ),

        labelLarge: TextStyle(
          fontFamily: _baseFamily,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          height: 1.15,
          letterSpacing: 0.1,
          color: cs.onSurface,
        ),

        labelMedium: TextStyle(
          fontFamily: _baseFamily,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          height: 1.15,
          letterSpacing: 0.1,
          color: cs.onSurface.withValues(alpha: .72),
        ),

        labelSmall: TextStyle(
          fontFamily: _baseFamily,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          height: 1.15,
          letterSpacing: 0.1,
          color: cs.onSurface.withValues(alpha: .55),
        ),

        bodySmall: TextStyle(
          fontFamily: _baseFamily,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.35,
          letterSpacing: 0.0,
          color: cs.onSurface.withValues(alpha: .72),
        ),
      );
}