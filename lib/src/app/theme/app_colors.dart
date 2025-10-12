import 'package:flutter/material.dart';

/// A centralized class for defining application-wide color constants.
///
/// This class includes both light and dark theme color values, such as primary,
/// accent, background, surface, and text colors. Use these constants to ensure
/// consistent theming across the application.
class AppColor {
  /// My base color
  static const Color primary = Color(0xFF243363);

  /// Foreground color (e.g., text or icon) used on top of primary backgrounds to ensure readability.
  static const Color onPrimaryColor = Colors.white;

  /// Button background
  static const Color accent = Color(0xFF5164FC);

  /// Light background
  static const Color background = Color(0xFFF8F9FD);

  /// Kept same for readability
  static const Color textPrimary = Color(0xFF1C1C1C);

  /// Slightly darker for better contrast
  static const Color textSecondary = Color(0xFF5A5A5A);

  /// Button text color
  static const Color buttonText = Colors.white;

  /// For cards/surfaces
  static const Color surface = Color(0xFFF1F3F9);

  /// Primary brand color used in dark theme backgrounds and elements.
  static const Color primaryDark = Color(0xFF1A254D);

  /// Lighter variant of the primary color, for hover states or lighter UI elements.
  static const Color primaryLight = Color(0xFF3D4B82);

  /// Bright accent color used to highlight interactive elements in light theme.
  static const Color accentLight = Color(0xFF7D89FD);

  /// Accent color used in dark theme to highlight important elements or call-to-actions.
  static const Color accentDark = Color(0xFF3A4EF2);

  /// Background color used throughout the dark theme UI.
  static const Color darkBackground = Color(0xFF121212);

  /// Surface color for dark theme cards, sheets, and modal backgrounds.
  static const Color darkSurface = Color(0xFF1E1E1E);

  /// Color used for the AppBar background in dark theme.
  static const Color darkAppBar = Color(0xFF1A1A1A);

  /// Primary text color used on dark backgrounds.
  static const Color darkTextPrimary = Color(0xFFFFFFFF);

  /// Secondary text color used for subtitles, hints, and disabled text on dark backgrounds.
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // ==================== SEMANTIC COLORS ====================
  /// Success state color
  static const Color success = Color(0xFF4CAF50);

  /// Error state color
  static const Color error = Color(0xFFE53E3E);

  /// Warning state color
  static const Color warning = Color(0xFFED8936);

  /// Info state color
  static const Color info = Color(0xFF3182CE);
  // For dark mode buttons
}
