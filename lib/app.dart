import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/app/router.dart';
import 'package:sensorlab/src/app/theme/app_theme.dart';
import 'package:sensorlab/src/features/app_settings/provider/settings_provider.dart';

/// App is Main material app which called to main and assigned themes router configuration and debug show checked mode value
class App extends ConsumerWidget {
  /// Creates an instance of [App]
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsControllerProvider);
    debugPrint(
      'App widget rebuilt. Language code: ${settings.value?.languageCode}',
    );
    return MaterialApp.router(
      // Provide the delegates from the generated code
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      // Provide the supported locales from the generated code
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appName,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: settings.value?.themeModeEnum ?? ThemeMode.system,
      locale: settings.value != null
          ? Locale(settings.value!.languageCode)
          : null,

      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
