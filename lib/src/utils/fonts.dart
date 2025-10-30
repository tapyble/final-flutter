import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Font Configuration
/// All font styles and text themes used throughout the Tapyble application
class AppFonts {
  // Private constructor to prevent instantiation
  AppFonts._();

  /// Primary app font family - Rubik
  static const String zAppFontFamily = "Rubik";

  /// Get Rubik font text style
  static TextStyle rubik({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.rubik(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }



  /// Get complete theme data with Rubik font
  static ThemeData getThemeData({
    ColorScheme? colorScheme,
    Brightness brightness = Brightness.light,
  }) {
    return ThemeData(
      fontFamily: zAppFontFamily,
      textTheme: GoogleFonts.rubikTextTheme(),
      colorScheme: colorScheme,
      brightness: brightness,
      useMaterial3: true,
    );
  }
}

/// Common text styles using Rubik font
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Headings
  static TextStyle get heading1 => AppFonts.rubik(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get heading2 => AppFonts.rubik(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get heading3 => AppFonts.rubik(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get heading4 => AppFonts.rubik(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  // Body text
  static TextStyle get bodyLarge => AppFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodyMedium => AppFonts.rubik(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodySmall => AppFonts.rubik(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  // Button text
  static TextStyle get buttonLarge => AppFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get buttonMedium => AppFonts.rubik(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get buttonSmall => AppFonts.rubik(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  // Caption and labels
  static TextStyle get caption => AppFonts.rubik(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get label => AppFonts.rubik(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );
} 