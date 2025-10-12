import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/services/hive_service.dart';
import 'package:sensorlab/src/features/app_settings/application/settings_controller.dart';
import 'package:sensorlab/src/features/app_settings/domain/models/app_settings.dart';
import 'package:sensorlab/src/features/app_settings/infrastructure/settings_repository.dart';

/// Provide [SettingsRepository] instance
///
/// The Repository is responsible for the low-level work of persisting and
/// retrieving user settings from local storage(Hive). It should not be
/// accessed directly by the UI
final settingsRepositoryProvider = Provider((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return SettingsRepository(hiveService);
});

///  Provides the [SettingsController] and its state [AppSettings]
///
/// this is the main entry point for the UI to interact with the settings feature
/// widgets should watch this provider to get the current [AppSettings] and
/// to call methods on the [SettingsController] to update the settings
final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, AppSettings>(() {
      return SettingsController();
    });
