import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sensorlab/src/core/errors/exceptions.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/app_settings/domain/models/app_settings.dart';

import '../constants/hive_constants.dart';

/// HiveService managing hive initial and hive box close function
///
/// I can be call in main.dart file but we separated it so we can easily test and debug it
///
final hiveServiceProvider = Provider<HiveService>((ref) {
  final logger = ref.watch(appLoggerProvider);
  return HiveService(logger);
});

/// HiveService manages Hive initialization and box access.
class HiveService {
  final AppLogger _appLogger;
  bool _initialized = false;

  /// Constructor receives dependencies.
  HiveService(this._appLogger);

  /// [authBox] Instance
  // static const String authBoxName = HiveConstants.authBox;

  /// [taskBox] Instance
  // static const String taskBoxName = HiveConstants.taskBox;

  /// [aiChatBox] Instance
  // static const String aiChatBoxName = HiveConstants.aiChatBox;

  /// [uTouChatBox] Instance
  // static const String uTouChatBoxName = HiveConstants.uTouChatBox;

  /// [settingsBoxName] Instance
  static const String settingsBoxName = HiveConstants.settingsBoxName;

  /// Hive Service Initialization
  Future<void> init() async {
    /// If all-ready initialized return nothing
    if (_initialized) return;
    try {
      /// Teach Hive about [UToUChatModelAdapter] data model
      // if (!Hive.isAdapterRegistered(2)) {
      //   Hive.registerAdapter(UserModelAdapter());
      // }

      /// Teach Hive about [AppSettings] data model
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(AppSettingsAdapter());
      }

      /// Open The Database drawers to read/write data
      await Hive.openBox<AppSettings>(settingsBoxName);

      /// Set _initialized value true
      _initialized = true;

      _appLogger.info(
        '🚀 ~This is an info message from my HiveService init so that Hive service is initialized',
      );
    } catch (e) {
      /// Set  _initialized value false
      _initialized = false;
      throw ServerException('🚀 ~Server error occurred (hive.service.dart) $e');
    }
  }

  /// Auth box initialized
  // Box<UserModel> get authBox {
  //   _checkInitialized();
  //   return Hive.box<UserModel>(authBoxName);
  // }

  ///aiChatBox initialized
  // Box<AiChatModel> get aiChatBoxInit {
  //   _checkInitialized();
  //   return Hive.box<AiChatModel>(aiChatBoxName);
  // }

  ///uTouBox initialized
  // Box<UToUChatModel> get uTouChatBoxInit {
  //   _checkInitialized();
  //   return Hive.box<UToUChatModel>(uTouChatBoxName);
  // }

  ///settingsBox initialized
  Box<AppSettings> get settingsBox {
    _checkInitialized();
    return Hive.box<AppSettings>(settingsBoxName);
  }

  /// check are they initialized or not
  void _checkInitialized() {
    if (!_initialized) throw Exception('HiveService not initialized');
  }

  /// Clear all boxes
  // Future<void> clear() async {
  //   await aiChatBoxInit.clear();
  //   await uTouChatBoxInit.clear();
  // }
}
