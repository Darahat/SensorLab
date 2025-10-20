import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

/// Singleton instance to manage app localization.
///
/// Provided access to localization methods and current locale status.
final FlutterLocalization localization = FlutterLocalization.instance;

/// Contains locale identifiers and translation keys used across the application.
mixin AppLocale {
  /// Localization key for the app title
  static const String title = 'title';

  /// Locale identifier for English (United States)
  static const String enUS = 'en_US';

  /// Locale identifier for khmer(Cambodia)
  static const String kmKH = 'km_KH';

  /// Locale identifier for Japanese(Japan)
  static const String jaJP = 'ja_JP';

  /// Mapping from string keys to actual Locale objects
  static final Map<String, Locale> localeMap = {
    enUS: const Locale('en', 'US'),
    kmKH: const Locale('km', 'KH'),
    jaJP: const Locale('ja', 'JP'),
  };

  /// List of supported [Locale]s for use with materialApp or CupertinoApp.
  static List<Locale> get flutterSupportedLocales => localeMap.values.toList();
}

/// Extension for helper methods related to [FlutterLocalization]
extension LocalizationHelpers on FlutterLocalization {
  /// Returns the current locale as a formatted string (e.g. `'en_US'`)
  String get currentLocaleString => currentLocale.toString(); // e.g., 'en_US'
}
