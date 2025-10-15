import 'package:hive/hive.dart';

import 'plant_light_data.dart';

part 'plant_tracking_session.g.dart';

/// Hive model for persistent plant tracking sessions
@HiveType(typeId: 10)
class PlantTrackingSession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String plantName;

  @HiveField(2)
  final int plantTypeIndex; // Store PlantType as index

  @HiveField(3)
  final DateTime startTime;

  @HiveField(4)
  final DateTime? endTime;

  @HiveField(5)
  final double targetDLI;

  @HiveField(6)
  final double currentDLI;

  @HiveField(7)
  final List<LightReadingHive> readings;

  @HiveField(8)
  final bool isActive;

  @HiveField(9)
  final String? notes; // User notes about plant location or conditions

  @HiveField(10)
  final String? location; // Window location (e.g., "South Window", "Desk")

  const PlantTrackingSession({
    required this.id,
    required this.plantName,
    required this.plantTypeIndex,
    required this.startTime,
    this.endTime,
    required this.targetDLI,
    this.currentDLI = 0.0,
    this.readings = const [],
    this.isActive = true,
    this.notes,
    this.location,
  });

  /// Convert to PlantLightData for UI display
  PlantLightData toPlantLightData() {
    final plantType = PlantType.values[plantTypeIndex];
    final plantInfo = PlantDatabase.getPlantInfo(plantType);

    return PlantLightData(
      plantType: plantType,
      plantName: plantName,
      lightRequirement: plantInfo.lightRequirement,
      targetDLI: targetDLI,
      currentDLI: currentDLI,
      trackingStartTime: startTime,
      readings: readings.map((r) => r.toLightReading()).toList(),
    );
  }

  /// Create from PlantLightData
  factory PlantTrackingSession.fromPlantLightData(
    String id,
    PlantLightData data, {
    String? notes,
    String? location,
  }) {
    return PlantTrackingSession(
      id: id,
      plantName: data.plantName,
      plantTypeIndex: data.plantType.index,
      startTime: data.trackingStartTime,
      targetDLI: data.targetDLI,
      currentDLI: data.currentDLI,
      readings: data.readings
          .map((r) => LightReadingHive.fromLightReading(r))
          .toList(),
      notes: notes,
      location: location,
    );
  }

  PlantTrackingSession copyWith({
    String? id,
    String? plantName,
    int? plantTypeIndex,
    DateTime? startTime,
    DateTime? endTime,
    double? targetDLI,
    double? currentDLI,
    List<LightReadingHive>? readings,
    bool? isActive,
    String? notes,
    String? location,
  }) {
    return PlantTrackingSession(
      id: id ?? this.id,
      plantName: plantName ?? this.plantName,
      plantTypeIndex: plantTypeIndex ?? this.plantTypeIndex,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      targetDLI: targetDLI ?? this.targetDLI,
      currentDLI: currentDLI ?? this.currentDLI,
      readings: readings ?? this.readings,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      location: location ?? this.location,
    );
  }

  /// Calculate progress percentage
  double get progressPercentage {
    if (targetDLI == 0) return 0;
    return (currentDLI / targetDLI * 100).clamp(0, 100);
  }

  /// Get session duration in hours
  double get durationHours {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime).inMinutes / 60.0;
  }

  /// Get average lux during session
  double get averageLux {
    if (readings.isEmpty) return 0;
    final sum = readings.fold<double>(0, (sum, r) => sum + r.lux);
    return sum / readings.length;
  }
}

/// Hive model for individual light readings
@HiveType(typeId: 11)
class LightReadingHive {
  @HiveField(0)
  final int timestampMillis;

  @HiveField(1)
  final double lux;

  @HiveField(2)
  final double ppfd;

  const LightReadingHive({
    required this.timestampMillis,
    required this.lux,
    required this.ppfd,
  });

  DateTime get timestamp =>
      DateTime.fromMillisecondsSinceEpoch(timestampMillis);

  LightReading toLightReading() {
    return LightReading(timestamp: timestamp, lux: lux, ppfd: ppfd);
  }

  factory LightReadingHive.fromLightReading(LightReading reading) {
    return LightReadingHive(
      timestampMillis: reading.timestamp.millisecondsSinceEpoch,
      lux: reading.lux,
      ppfd: reading.ppfd,
    );
  }
}

/// Photo session with camera settings and conditions
@HiveType(typeId: 12)
class PhotoSession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final double lux;

  @HiveField(3)
  final int iso;

  @HiveField(4)
  final String shutterSpeed;

  @HiveField(5)
  final double aperture;

  @HiveField(6)
  final int lightingConditionIndex; // Store LightingCondition as index

  @HiveField(7)
  final String? scenarioType; // "Portrait", "Landscape", "Macro", etc.

  @HiveField(8)
  final String? notes;

  @HiveField(9)
  final String? location;

  @HiveField(10)
  final bool wasSuccessful; // User can mark if photo turned out good

  @HiveField(11)
  final int? rating; // 1-5 stars

  const PhotoSession({
    required this.id,
    required this.timestamp,
    required this.lux,
    required this.iso,
    required this.shutterSpeed,
    required this.aperture,
    required this.lightingConditionIndex,
    this.scenarioType,
    this.notes,
    this.location,
    this.wasSuccessful = false,
    this.rating,
  });

  PhotoSession copyWith({
    String? id,
    DateTime? timestamp,
    double? lux,
    int? iso,
    String? shutterSpeed,
    double? aperture,
    int? lightingConditionIndex,
    String? scenarioType,
    String? notes,
    String? location,
    bool? wasSuccessful,
    int? rating,
  }) {
    return PhotoSession(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      lux: lux ?? this.lux,
      iso: iso ?? this.iso,
      shutterSpeed: shutterSpeed ?? this.shutterSpeed,
      aperture: aperture ?? this.aperture,
      lightingConditionIndex:
          lightingConditionIndex ?? this.lightingConditionIndex,
      scenarioType: scenarioType ?? this.scenarioType,
      notes: notes ?? this.notes,
      location: location ?? this.location,
      wasSuccessful: wasSuccessful ?? this.wasSuccessful,
      rating: rating ?? this.rating,
    );
  }

  String get fStop => 'f/${aperture.toStringAsFixed(1)}';

  String get formattedSettings => 'ISO $iso | $shutterSpeed | $fStop';
}

/// Daily light summary for quick insights
@HiveType(typeId: 13)
class DailyLightSummary {
  @HiveField(0)
  final String date; // Format: yyyy-MM-dd

  @HiveField(1)
  final double maxLux;

  @HiveField(2)
  final double minLux;

  @HiveField(3)
  final double averageLux;

  @HiveField(4)
  final double totalDLI;

  @HiveField(5)
  final int totalReadings;

  @HiveField(6)
  final List<HourlyLightData> hourlyData;

  @HiveField(7)
  final int sunriseHour; // Hour of first significant light (>100 lux)

  @HiveField(8)
  final int sunsetHour; // Hour of last significant light (>100 lux)

  const DailyLightSummary({
    required this.date,
    required this.maxLux,
    required this.minLux,
    required this.averageLux,
    required this.totalDLI,
    required this.totalReadings,
    this.hourlyData = const [],
    this.sunriseHour = 0,
    this.sunsetHour = 0,
  });

  /// Check if it was a sunny day (peak > 50k lux)
  bool get wasSunnyDay => maxLux > 50000;

  /// Get daylight hours
  int get daylightHours {
    if (sunsetHour <= sunriseHour) return 0;
    return sunsetHour - sunriseHour;
  }
}

/// Hourly aggregated light data
@HiveType(typeId: 14)
class HourlyLightData {
  @HiveField(0)
  final int hour; // 0-23

  @HiveField(1)
  final double averageLux;

  @HiveField(2)
  final double maxLux;

  @HiveField(3)
  final int readingCount;

  const HourlyLightData({
    required this.hour,
    required this.averageLux,
    required this.maxLux,
    required this.readingCount,
  });
}
