import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClayColors {
  static const Color background = Color(0xFFF6FAFE);
  static const Color canvasBase = Color(0xFFF0F4F8);
  static const Color surfaceContainer = Color(0xFFEAEEF2);
  static const Color surfaceElevated = Color(0xFFEAF0F7);
  static const Color surfaceContainerLow = Color(0xFFF0F4F8);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);

  static const Color primary = Color(0xFF4457B3);
  static const Color primaryContainer = Color(0xFF8C9EFF);
  static const Color primaryGradientEnd = Color(0xFF7B8EF8);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF35445B);
  static const Color textSecondary = Color(0xFF7B8798);
  static const Color textMuted = Color(0xFFA0AAB8);
  static const Color outline = Color(0xFF757683);
  static const Color outlineVariant = Color(0xFFC5C5D4);

  // Mint / Success / Done
  static const Color mintSurface = Color(0xFFDDF5E8);
  static const Color mintButton = Color(0xFFC8EBDA);
  static const Color mintText = Color(0xFF48A384);
  static const Color mintShadow = Color(0xFFCBE4D6);

  // Peach / High priority / Alert
  static const Color peachSurface = Color(0xFFFFE7D9);
  static const Color peachText = Color(0xFFD97E52);
  static const Color peachShadow = Color(0xFFE6CEBF);

  // Lavender / Category / Overview
  static const Color lavenderSurface = Color(0xFFE8E0FF);
  static const Color lavenderText = Color(0xFF685DB8);
  static const Color lavenderShadow = Color(0xFFD4CDE6);

  // Soft Blue / Work Category
  static const Color blueSurface = Color(0xFFDCEBFF);
  static const Color blueText = Color(0xFF35445B);
  static const Color blueShadow = Color(0xFFCCD7E5);

  // Error container
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFFBA1A1A);

  // Shadow colors
  static const Color shadowDark = Color(0xFFD3DCE6);
  static const Color shadowLight = Color(0xFFFFFFFF);
  static const Color shadowPrimaryDark = Color(0xFFC4D0E5);
}

class ClayShadows {
  static List<BoxShadow> extruded({double offset = 7, double blur = 16}) => [
        BoxShadow(
          color: ClayColors.shadowDark.withValues(alpha: 0.9),
          offset: Offset(offset, offset),
          blurRadius: blur,
        ),
        BoxShadow(
          color: ClayColors.shadowLight,
          offset: Offset(-offset, -offset),
          blurRadius: blur,
        ),
      ];

  static List<BoxShadow> subtle({double offset = 4, double blur = 10}) => [
        BoxShadow(
          color: ClayColors.shadowDark.withValues(alpha: 0.85),
          offset: Offset(offset, offset),
          blurRadius: blur,
        ),
        BoxShadow(
          color: ClayColors.shadowLight,
          offset: Offset(-offset, -offset),
          blurRadius: blur,
        ),
      ];

  static List<BoxShadow> buttonPrimary = [
    BoxShadow(
      color: ClayColors.shadowPrimaryDark.withValues(alpha: 0.9),
      offset: const Offset(5, 5),
      blurRadius: 12,
    ),
    const BoxShadow(
      color: ClayColors.shadowLight,
      offset: Offset(-5, -5),
      blurRadius: 12,
    ),
  ];

  static List<BoxShadow> fab = [
    BoxShadow(
      color: const Color(0xFFB8C7E0).withValues(alpha: 0.9),
      offset: const Offset(8, 8),
      blurRadius: 18,
    ),
    const BoxShadow(
      color: ClayColors.shadowLight,
      offset: Offset(-6, -6),
      blurRadius: 16,
    ),
  ];

  static List<BoxShadow> recessed = [
    BoxShadow(
      color: ClayColors.shadowDark.withValues(alpha: 0.8),
      offset: const Offset(3, 3),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    const BoxShadow(
      color: ClayColors.shadowLight,
      offset: Offset(-3, -3),
      blurRadius: 6,
      spreadRadius: -1,
    ),
  ];
}

class ClayTheme {
  static ThemeData get themeData {
    final fontFam = GoogleFonts.plusJakartaSans().fontFamily;

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFam,
      scaffoldBackgroundColor: ClayColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ClayColors.primary,
        surface: ClayColors.background,
        primary: ClayColors.primary,
        secondary: ClayColors.textSecondary,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontFam,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: ClayColors.textPrimary,
          letterSpacing: -0.6,
        ),
        headlineLarge: TextStyle(
          fontFamily: fontFam,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: ClayColors.textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFam,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: ClayColors.textPrimary,
          letterSpacing: -0.3,
        ),
        headlineSmall: TextStyle(
          fontFamily: fontFam,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ClayColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFam,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ClayColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontFam,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: ClayColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFam,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ClayColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontFamily: fontFam,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: ClayColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontFamily: fontFam,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: ClayColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontFamily: fontFam,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: ClayColors.textSecondary,
        ),
      ),
    );
  }
}
