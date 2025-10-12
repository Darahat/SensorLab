import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/app/router.dart';
import 'package:sensorlab/src/app/theme/app_theme.dart';
import 'package:sensorlab/src/features/app_settings/provider/settings_provider.dart';
import 'package:sensorlab/src/l10n/app_localizations.dart';

/// App is Main material app which called to main and assigned themes router configuration and debug show checked mode value
class App extends ConsumerWidget {
  /// Creates an instance of [App]
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp.router(
      /// if you use only title and AppLocalizations it would get the value
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appName,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: settings.value?.themeModeEnum ?? ThemeMode.system,
      locale: Locale(settings.value?.languageCode ?? 'en'),
      supportedLocales: const [
        Locale('en'),
        Locale('km'),
        Locale('ja'),
        Locale('es'),
      ],
      // supportedLocales: AppLocale.flutterSupportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return const Locale('en', 'US');
      },
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
