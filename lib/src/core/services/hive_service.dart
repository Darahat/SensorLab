import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sensorlab/src/core/errors/exceptions.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/app_settings/domain/models/app_settings.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_data_point.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/health/domain/entities/activity_session.dart';
import 'package:sensorlab/src/features/health/domain/entities/activity_type.dart';
import 'package:sensorlab/src/features/health/domain/entities/user_profile.dart';
import 'package:sensorlab/src/features/light_meter/models/plant_tracking_session.dart';
import 'package:sensorlab/src/features/noise_meter/data/models/acoustic_report_hive.dart';
import 'package:sensorlab/src/features/noise_meter/data/models/custom_preset_hive.dart';

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

  /// [customPresetsBoxName] Instance
  static const String customPresetsBoxName = HiveConstants.customPresetsBox;

  /// [plantTrackingBoxName] Instance
  static const String plantTrackingBoxName = HiveConstants.plantTrackingBox;

  /// [photoSessionBoxName] Instance
  static const String photoSessionBoxName = HiveConstants.photoSessionBox;

  /// [dailyLightSummaryBoxName] Instance
  static const String dailyLightSummaryBoxName =
      HiveConstants.dailyLightSummaryBox;

  /// [customLabsBoxName] Instance
  static const String customLabsBoxName = 'customLabsBox';

  /// [labSessionsBoxName] Instance
  static const String labSessionsBoxName = 'labSessionsBox';

  /// [sensorDataBoxName] Instance
  static const String sensorDataBoxName = 'sensorDataBox';

  /// Hive Service Initialization
  Future<void> init() async {
    /// If all-ready initialized return nothing
    if (_initialized) {
      return;
    }
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

      /// Teach Hive about [PlantTrackingSession] data model (typeId: 10)
      if (!Hive.isAdapterRegistered(10)) {
        Hive.registerAdapter(PlantTrackingSessionAdapter());
      }

      /// Teach Hive about [LightReadingHive] data model (typeId: 11)
      if (!Hive.isAdapterRegistered(11)) {
        Hive.registerAdapter(LightReadingHiveAdapter());
      }

      /// Teach Hive about [PhotoSession] data model (typeId: 12)
      if (!Hive.isAdapterRegistered(12)) {
        Hive.registerAdapter(PhotoSessionAdapter());
      }

      /// Teach Hive about [DailyLightSummary] data model (typeId: 13)
      if (!Hive.isAdapterRegistered(13)) {
        Hive.registerAdapter(DailyLightSummaryAdapter());
      }

      /// Teach Hive about [HourlyLightData] data model (typeId: 14)
      if (!Hive.isAdapterRegistered(14)) {
        Hive.registerAdapter(HourlyLightDataAdapter());
      }

      /// Teach Hive about [CustomPresetHive] data model (typeId: 15)
      if (!Hive.isAdapterRegistered(15)) {
        Hive.registerAdapter(CustomPresetHiveAdapter());
        _appLogger.info('✅ CustomPresetHiveAdapter registered (typeId: 15)');
      }

      /// Teach Hive about [SensorType] enum (typeId: 20)
      if (!Hive.isAdapterRegistered(20)) {
        Hive.registerAdapter(SensorTypeAdapter());
        _appLogger.info('✅ SensorTypeAdapter registered (typeId: 20)');
      }

      /// Teach Hive about [Lab] data model (typeId: 21)
      if (!Hive.isAdapterRegistered(21)) {
        Hive.registerAdapter(LabAdapter());
        _appLogger.info('✅ LabAdapter registered (typeId: 21)');
      }

      /// Teach Hive about [RecordingStatus] enum (typeId: 22)
      if (!Hive.isAdapterRegistered(22)) {
        Hive.registerAdapter(RecordingStatusAdapter());
        _appLogger.info('✅ RecordingStatusAdapter registered (typeId: 22)');
      }

      /// Teach Hive about [LabSession] data model (typeId: 23)
      if (!Hive.isAdapterRegistered(23)) {
        Hive.registerAdapter(LabSessionAdapter());
        _appLogger.info('✅ LabSessionAdapter registered (typeId: 23)');
      }

      /// Teach Hive about [SensorDataPoint] data model (typeId: 24)
      if (!Hive.isAdapterRegistered(24)) {
        Hive.registerAdapter(SensorDataPointAdapter());
        _appLogger.info('✅ SensorDataPointAdapter registered (typeId: 24)');
      }

      /// Open The Database drawers to read/write data
      await Hive.openBox<AppSettings>(settingsBoxName);
      await Hive.openBox<UserProfile>(userProfileBoxName);
      await Hive.openBox<ActivitySession>(activitySessionBoxName);
      await Hive.openBox<AcousticReportHive>(acousticReportBoxName);
      await Hive.openBox<CustomPresetHive>(customPresetsBoxName);
      _appLogger.info('✅ Custom presets box opened: $customPresetsBoxName');
      await Hive.openBox<PlantTrackingSession>(plantTrackingBoxName);
      await Hive.openBox<PhotoSession>(photoSessionBoxName);
      await Hive.openBox<DailyLightSummary>(dailyLightSummaryBoxName);
      await Hive.openBox<Lab>(customLabsBoxName);
      _appLogger.info('✅ Custom labs box opened: $customLabsBoxName');
      await Hive.openBox<LabSession>(labSessionsBoxName);
      _appLogger.info('✅ Lab sessions box opened: $labSessionsBoxName');
      await Hive.openBox<SensorDataPoint>(sensorDataBoxName);
      _appLogger.info('✅ Sensor data box opened: $sensorDataBoxName');

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

  ///customPresetsBox initialized
  Box<CustomPresetHive> get customPresetsBox {
    _checkInitialized();
    return Hive.box<CustomPresetHive>(customPresetsBoxName);
  }

  ///plantTrackingBox initialized
  Box<PlantTrackingSession> get plantTrackingBox {
    _checkInitialized();
    return Hive.box<PlantTrackingSession>(plantTrackingBoxName);
  }

  ///photoSessionBox initialized
  Box<PhotoSession> get photoSessionBox {
    _checkInitialized();
    return Hive.box<PhotoSession>(photoSessionBoxName);
  }

  ///dailyLightSummaryBox initialized
  Box<DailyLightSummary> get dailyLightSummaryBox {
    _checkInitialized();
    return Hive.box<DailyLightSummary>(dailyLightSummaryBoxName);
  }

  ///customLabsBox initialized
  Box<Lab> get customLabsBox {
    _checkInitialized();
    return Hive.box<Lab>(customLabsBoxName);
  }

  ///labSessionsBox initialized
  Box<LabSession> get labSessionsBox {
    _checkInitialized();
    return Hive.box<LabSession>(labSessionsBoxName);
  }

  ///sensorDataBox initialized
  Box<SensorDataPoint> get sensorDataBox {
    _checkInitialized();
    return Hive.box<SensorDataPoint>(sensorDataBoxName);
  }

  /// check are they initialized or not
  void _checkInitialized() {
    if (!_initialized) {
      throw Exception('HiveService not initialized');
    }
  }

  /// Clear all boxes
  // Future<void> clear() async {
  //   await aiChatBoxInit.clear();
  //   await uTouChatBoxInit.clear();
  // }
}
