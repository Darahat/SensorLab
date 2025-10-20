import 'package:flutter/material.dart';
import 'package:sensorlab/src/app/theme/app_colors.dart';

/// The light theme configuration used throughout the application.
///
/// This theme includes color and style definitions optimized for light mode UI.
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,

  // Primary colors
  primaryColor: AppColor.primary,
  scaffoldBackgroundColor: AppColor.background,

  // App Bar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColor.primary,
    foregroundColor: AppColor.onPrimaryColor,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColor.buttonText,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(color: AppColor.onPrimaryColor),
    actionsIconTheme: IconThemeData(color: AppColor.onPrimaryColor),
  ),

  // Color scheme for Material 3
  colorScheme: const ColorScheme.light(
    primary: AppColor.primary,
    secondary: AppColor.accent,
    onSecondary: AppColor.buttonText,
    surface: AppColor.background,
    onSurface: AppColor.textPrimary,
    error: AppColor.error,
    surfaceTint: AppColor.surface, // Changed from Colors.transparent
  ),

  // Card Theme
  cardTheme: const CardThemeData(
    color: AppColor.surface,
    elevation: 2,
    margin: EdgeInsets.all(8),
    surfaceTintColor: AppColor.surface, // Changed from Colors.transparent
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),

  // Drawer Theme
  drawerTheme: const DrawerThemeData(
    backgroundColor: AppColor.background,
    elevation: 16,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
    ),
    surfaceTintColor: AppColor.surface, // Changed from Colors.transparent
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColor.surface,
    selectedItemColor: AppColor.primary,
    unselectedItemColor: AppColor.textSecondary,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    unselectedLabelStyle: TextStyle(fontSize: 12),
  ),

  // Tab Bar Theme
  tabBarTheme: const TabBarThemeData(
    labelColor: AppColor.primary,
    unselectedLabelColor: AppColor.textSecondary,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(width: 2, color: AppColor.primary),
    ),
    labelStyle: TextStyle(fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    dividerColor: AppColor.surface, // Changed from Colors.transparent
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColor.accent,
    foregroundColor: AppColor.buttonText,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  // Button themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColor.accent,
      foregroundColor: AppColor.buttonText,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColor.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColor.primary,
      side: const BorderSide(color: AppColor.primary),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  // SnackBar Theme
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColor.surface,
    contentTextStyle: const TextStyle(color: AppColor.textPrimary),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: AppColor.textSecondary.withValues(alpha: .2)),
    ),
    elevation: 4,
    actionTextColor: AppColor.accent,
    showCloseIcon: true, // Added for Flutter 3.22.1
    closeIconColor: AppColor.textSecondary,
  ),

  // Divider Theme
  dividerTheme: DividerThemeData(
    color: AppColor.textSecondary.withValues(alpha: 0.2),
    thickness: 1,
    space: 1,
  ),

  // Popup Menu Theme
  popupMenuTheme: PopupMenuThemeData(
    color: AppColor.surface,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: AppColor.textSecondary.withValues(alpha: .1)),
    ),
    labelTextStyle: WidgetStateProperty.all<TextStyle>(
      // Updated for Flutter 3.22.1
      const TextStyle(color: AppColor.textPrimary, fontSize: 14),
    ),
    surfaceTintColor: AppColor.surface, // Changed from Colors.transparent
  ),

  // Text theme
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      // Updated from headlineLarge
      color: AppColor.textPrimary,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      // Updated from headlineMedium
      color: AppColor.textPrimary,
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      // Updated from titleLarge
      color: AppColor.textPrimary,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      // Updated from titleMedium
      color: AppColor.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(color: AppColor.textPrimary, fontSize: 16),
    bodyMedium: TextStyle(color: AppColor.textSecondary, fontSize: 14),
    labelLarge: TextStyle(
      color: AppColor.buttonText,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),

  // Input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColor.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.textSecondary),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.textSecondary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.accent, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.error, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    labelStyle: const TextStyle(color: AppColor.textSecondary),
    hintStyle: const TextStyle(color: AppColor.textSecondary),
    errorStyle: const TextStyle(color: AppColor.error),
    floatingLabelStyle: WidgetStateTextStyle.resolveWith(
      // Added for Flutter 3.22.1
      (states) {
        if (states.contains(WidgetState.focused)) {
          return const TextStyle(color: AppColor.accent);
        }
        return const TextStyle(color: AppColor.textSecondary);
      },
    ),
  ),

  // Progress Indicator Theme
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColor.primary,
    linearTrackColor: AppColor.textSecondary,
    circularTrackColor: AppColor.textSecondary,
    linearMinHeight: 3, // Added for Flutter 3.22.1
  ),
);

/// The dark theme configuration used throughout the application.
///
/// This theme includes color and style definitions optimized for dark mode UI.
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  // Primary colors
  primaryColor: AppColor.primaryDark,
  scaffoldBackgroundColor: AppColor.darkBackground,

  // App Bar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColor.darkAppBar,
    foregroundColor: AppColor.darkTextPrimary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColor.darkTextPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(color: AppColor.darkTextPrimary),
    actionsIconTheme: IconThemeData(color: AppColor.darkTextPrimary),
  ),

  // Color scheme for Material 3
  colorScheme: const ColorScheme.dark(
    primary: AppColor.accent,
    onPrimary: AppColor.buttonText,
    secondary: AppColor.accentLight,
    surface: AppColor.darkSurface,
    error: AppColor.error,
    surfaceTint: AppColor.darkSurface, // Changed from Colors.transparent
  ),

  // Card Theme
  cardTheme: const CardThemeData(
    color: AppColor.darkSurface,
    elevation: 2,
    margin: EdgeInsets.all(8),
    surfaceTintColor: AppColor.darkSurface, // Changed from Colors.transparent
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),

  // Drawer Theme
  drawerTheme: const DrawerThemeData(
    backgroundColor: AppColor.darkSurface,
    elevation: 16,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
    ),
    surfaceTintColor: AppColor.darkSurface, // Changed from Colors.transparent
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColor.darkSurface,
    selectedItemColor: AppColor.accent,
    unselectedItemColor: AppColor.darkTextSecondary,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    unselectedLabelStyle: TextStyle(fontSize: 12),
  ),

  // Tab Bar Theme
  tabBarTheme: const TabBarThemeData(
    labelColor: AppColor.accent,
    unselectedLabelColor: AppColor.darkTextSecondary,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(width: 2, color: AppColor.accent),
    ),
    labelStyle: TextStyle(fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    dividerColor: AppColor.darkSurface, // Changed from Colors.transparent
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColor.accent,
    foregroundColor: AppColor.buttonText,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  // Button themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColor.accent,
      foregroundColor: AppColor.buttonText,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColor.accent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColor.accent,
      side: const BorderSide(color: AppColor.accent),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  // SnackBar Theme
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColor.darkSurface,
    contentTextStyle: const TextStyle(color: AppColor.darkTextPrimary),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: AppColor.darkTextSecondary.withValues(alpha: .2)),
    ),
    elevation: 4,
    actionTextColor: AppColor.accent,
    showCloseIcon: true, // Added for Flutter 3.22.1
    closeIconColor: AppColor.darkTextSecondary,
  ),

  // Divider Theme
  dividerTheme: DividerThemeData(
    color: AppColor.darkTextSecondary.withValues(alpha: .2),
    thickness: 1,
    space: 1,
  ),

  // Popup Menu Theme
  popupMenuTheme: PopupMenuThemeData(
    color: AppColor.darkSurface,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: AppColor.darkTextSecondary.withValues(alpha: .1)),
    ),
    labelTextStyle: WidgetStateProperty.all<TextStyle>(
      // Updated for Flutter 3.22.1
      const TextStyle(color: AppColor.darkTextPrimary, fontSize: 14),
    ),
    surfaceTintColor: AppColor.darkSurface, // Changed from Colors.transparent
  ),

  // Text theme
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      // Updated from headlineLarge
      color: AppColor.darkTextPrimary,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      // Updated from headlineMedium
      color: AppColor.darkTextPrimary,
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      // Updated from titleLarge
      color: AppColor.darkTextPrimary,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      // Updated from titleMedium
      color: AppColor.darkTextPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(color: AppColor.darkTextPrimary, fontSize: 16),
    bodyMedium: TextStyle(color: AppColor.darkTextSecondary, fontSize: 14),
    labelLarge: TextStyle(
      color: AppColor.buttonText,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),

  // Input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColor.darkSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.darkTextSecondary),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.darkTextSecondary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.accent, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.error, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    labelStyle: const TextStyle(color: AppColor.darkTextSecondary),
    hintStyle: const TextStyle(color: AppColor.darkTextSecondary),
    errorStyle: const TextStyle(color: AppColor.error),
    floatingLabelStyle: WidgetStateTextStyle.resolveWith(
      // Added for Flutter 3.22.1
      (states) {
        if (states.contains(WidgetState.focused)) {
          return const TextStyle(color: AppColor.accent);
        }
        return const TextStyle(color: AppColor.darkTextSecondary);
      },
    ),
  ),

  // Progress Indicator Theme
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColor.accent,
    linearTrackColor: AppColor.darkTextSecondary,
    circularTrackColor: AppColor.darkTextSecondary,
    linearMinHeight: 3, // Added for Flutter 3.22.1
  ),
);
