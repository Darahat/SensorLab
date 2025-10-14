import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sensorlab/src/core/errors/exceptions.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/app_settings/domain/models/app_settings.dart';
import 'package:sensorlab/src/features/health/domain/entities/activity_session.dart';
import 'package:sensorlab/src/features/health/domain/entities/activity_type.dart';
import 'package:sensorlab/src/features/health/domain/entities/user_profile.dart';
import 'package:sensorlab/src/features/noise_meter/models/acoustic_report.dart';

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

  /// [settingsBoxName] Instance
  static const String settingsBoxName = HiveConstants.settingsBoxName;

  /// [userProfileBoxName] Instance
  static const String userProfileBoxName = HiveConstants.userProfileBox;

  /// [activitySessionBoxName] Instance
  static const String activitySessionBoxName = HiveConstants.activitySessionBox;

  /// [acousticReportBoxName] Instance
  static const String acousticReportBoxName = HiveConstants.acousticReportBox;

  /// Hive Service Initialization
  Future<void> init() async {
    /// If all-ready initialized return nothing
    if (_initialized) return;
    try {
      /// Teach Hive about [AppSettings] data model
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(AppSettingsAdapter());
      }

      /// Teach Hive about [UserProfile] data model
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(UserProfileAdapter());
      }

      /// Teach Hive about [Gender] data model
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(GenderAdapter());
      }

      /// Teach Hive about [ActivitySession] data model
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(ActivitySessionAdapter());
      }

      /// Teach Hive about [SessionStatus] data model
      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(SessionStatusAdapter());
      }

      /// Teach Hive about [MovementData] data model
      if (!Hive.isAdapterRegistered(5)) {
        Hive.registerAdapter(MovementDataAdapter());
      }

      /// Teach Hive about [Goals] data model
      if (!Hive.isAdapterRegistered(6)) {
        Hive.registerAdapter(GoalsAdapter());
      }

      /// Teach Hive about [ActivityType] data model
      if (!Hive.isAdapterRegistered(7)) {
        Hive.registerAdapter(ActivityTypeAdapter());
      }

      /// Teach Hive about [AcousticEventHive] data model (typeId: 8)
      if (!Hive.isAdapterRegistered(8)) {
        Hive.registerAdapter(AcousticEventHiveAdapter());
      }

      /// Teach Hive about [AcousticReportHive] data model (typeId: 9)
      if (!Hive.isAdapterRegistered(9)) {
        Hive.registerAdapter(AcousticReportHiveAdapter());
      }

      /// Open The Database drawers to read/write data
      await Hive.openBox<AppSettings>(settingsBoxName);
      await Hive.openBox<UserProfile>(userProfileBoxName);
      await Hive.openBox<ActivitySession>(activitySessionBoxName);
      await Hive.openBox<AcousticReportHive>(acousticReportBoxName);

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

  ///settingsBox initialized
  Box<AppSettings> get settingsBox {
    _checkInitialized();
    return Hive.box<AppSettings>(settingsBoxName);
  }

  ///userProfileBox initialized
  Box<UserProfile> get userProfileBox {
    _checkInitialized();
    return Hive.box<UserProfile>(userProfileBoxName);
  }

  ///activitySessionBox initialized
  Box<ActivitySession> get activitySessionBox {
    _checkInitialized();
    return Hive.box<ActivitySession>(activitySessionBoxName);
  }

  ///acousticReportBox initialized
  Box<AcousticReportHive> get acousticReportBox {
    _checkInitialized();
    return Hive.box<AcousticReportHive>(acousticReportBoxName);
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
