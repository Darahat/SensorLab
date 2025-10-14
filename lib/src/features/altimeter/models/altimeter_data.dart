import 'dart:math' as math;

enum AltitudeSource { gps, barometer, fused }

class AltimeterData {
  final double altitude; // Fused altitude in meters
  final double gpsAltitude; // GPS-based altitude in meters
  final double barometerAltitude; // Barometer-based altitude in meters
  final double pressure; // Current atmospheric pressure in hPa
  final double maxAltitude; // Maximum altitude recorded
  final double minAltitude; // Minimum altitude recorded
  final double avgAltitude; // Average altitude
  final double verticalSpeed; // Rate of altitude change (m/s)
  final double accuracy; // GPS altitude accuracy in meters
  final AltitudeSource primarySource; // Which sensor is currently primary
  final bool isActive;
  final DateTime? lastUpdateTime;
  final int sampleCount;

  // Sea level pressure for barometric calculation (can be calibrated)
  final double seaLevelPressure;

  AltimeterData({
    this.altitude = 0,
    this.gpsAltitude = 0,
    this.barometerAltitude = 0,
    this.pressure = 0,
    this.maxAltitude = double.negativeInfinity,
    this.minAltitude = double.infinity,
    this.avgAltitude = 0,
    this.verticalSpeed = 0,
    this.accuracy = 0,
    this.primarySource = AltitudeSource.fused,
    this.isActive = false,
    this.lastUpdateTime,
    this.sampleCount = 0,
    this.seaLevelPressure = 1013.25, // Standard sea level pressure
  });

  AltimeterData copyWith({
    double? altitude,
    double? gpsAltitude,
    double? barometerAltitude,
    double? pressure,
    double? maxAltitude,
    double? minAltitude,
    double? avgAltitude,
    double? verticalSpeed,
    double? accuracy,
    AltitudeSource? primarySource,
    bool? isActive,
    DateTime? lastUpdateTime,
    int? sampleCount,
    double? seaLevelPressure,
  }) {
    return AltimeterData(
      altitude: altitude ?? this.altitude,
      gpsAltitude: gpsAltitude ?? this.gpsAltitude,
      barometerAltitude: barometerAltitude ?? this.barometerAltitude,
      pressure: pressure ?? this.pressure,
      maxAltitude: maxAltitude ?? this.maxAltitude,
      minAltitude: minAltitude ?? this.minAltitude,
      avgAltitude: avgAltitude ?? this.avgAltitude,
      verticalSpeed: verticalSpeed ?? this.verticalSpeed,
      accuracy: accuracy ?? this.accuracy,
      primarySource: primarySource ?? this.primarySource,
      isActive: isActive ?? this.isActive,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      sampleCount: sampleCount ?? this.sampleCount,
      seaLevelPressure: seaLevelPressure ?? this.seaLevelPressure,
    );
  }

  /// Update with new GPS altitude data
  AltimeterData updateGPS({
    required double gpsAlt,
    required double gpsAccuracy,
    DateTime? timestamp,
  }) {
    final now = timestamp ?? DateTime.now();

    // Calculate vertical speed if we have previous data
    double newVerticalSpeed = verticalSpeed;
    if (lastUpdateTime != null) {
      final timeDiff = now.difference(lastUpdateTime!).inMilliseconds / 1000.0;
      if (timeDiff > 0) {
        newVerticalSpeed = (gpsAlt - gpsAltitude) / timeDiff;
      }
    }

    return copyWith(
      gpsAltitude: gpsAlt,
      accuracy: gpsAccuracy,
      verticalSpeed: newVerticalSpeed,
      lastUpdateTime: now,
    );
  }

  /// Update with new barometer pressure data
  AltimeterData updateBarometer({
    required double pressureHPa,
    DateTime? timestamp,
  }) {
    final now = timestamp ?? DateTime.now();

    // Calculate barometric altitude using hypsometric formula
    // h = 44330 * (1 - (P/P0)^0.1903)
    final baroAlt = pressureHPa > 0
        ? (44330 * (1 - math.pow(pressureHPa / seaLevelPressure, 0.1903)))
              .toDouble()
        : 0.0;

    // Calculate vertical speed if we have previous data
    double newVerticalSpeed = verticalSpeed;
    if (lastUpdateTime != null) {
      final timeDiff = now.difference(lastUpdateTime!).inMilliseconds / 1000.0;
      if (timeDiff > 0) {
        newVerticalSpeed = (baroAlt - barometerAltitude) / timeDiff;
      }
    }

    return copyWith(
      barometerAltitude: baroAlt,
      pressure: pressureHPa,
      verticalSpeed: newVerticalSpeed,
      lastUpdateTime: now,
    );
  }

  /// Fuse GPS and barometer data for more accurate altitude
  /// Uses Kalman filter-like weighted average based on GPS accuracy
  AltimeterData fuseAltitude() {
    if (gpsAltitude == 0 && barometerAltitude == 0) {
      return copyWith(
        altitude: 0,
        primarySource: AltitudeSource.fused,
        isActive: false,
      );
    }

    double fusedAlt;
    AltitudeSource source;

    // If GPS accuracy is poor (> 20m) or unavailable, rely more on barometer
    if (accuracy > 20 || gpsAltitude == 0) {
      if (barometerAltitude != 0) {
        fusedAlt = barometerAltitude;
        source = AltitudeSource.barometer;
      } else {
        fusedAlt = gpsAltitude;
        source = AltitudeSource.gps;
      }
    }
    // If barometer data is unavailable, use GPS
    else if (barometerAltitude == 0) {
      fusedAlt = gpsAltitude;
      source = AltitudeSource.gps;
    }
    // Both sensors available - use weighted fusion
    else {
      // Weight based on GPS accuracy (better accuracy = higher weight)
      // Accuracy typically ranges from 3m (good) to 50m (poor)
      final gpsWeight = 1.0 / (1.0 + (accuracy / 10.0));
      final baroWeight = 1.0 - gpsWeight;

      fusedAlt = (gpsAltitude * gpsWeight) + (barometerAltitude * baroWeight);
      source = AltitudeSource.fused;
    }

    // Update statistics
    final newSampleCount = sampleCount + 1;
    final newMaxAlt = math.max(
      maxAltitude == double.negativeInfinity ? fusedAlt : maxAltitude,
      fusedAlt,
    );
    final newMinAlt = math.min(
      minAltitude == double.infinity ? fusedAlt : minAltitude,
      fusedAlt,
    );

    // Calculate running average
    final newAvgAlt = ((avgAltitude * sampleCount) + fusedAlt) / newSampleCount;

    return copyWith(
      altitude: fusedAlt,
      maxAltitude: newMaxAlt,
      minAltitude: newMinAlt,
      avgAltitude: newAvgAlt,
      primarySource: source,
      isActive: true,
      sampleCount: newSampleCount,
    );
  }

  /// Calibrate sea level pressure based on known altitude
  AltimeterData calibrateSeaLevelPressure(double knownAltitude) {
    if (pressure <= 0) return this;

    // Reverse hypsometric formula: P0 = P / (1 - h/44330)^5.255
    final newSeaLevelPressure =
        pressure / math.pow(1 - (knownAltitude / 44330), 5.255);

    return copyWith(seaLevelPressure: newSeaLevelPressure.toDouble());
  }

  /// Reset statistics
  AltimeterData resetStats() {
    return copyWith(
      maxAltitude: altitude,
      minAltitude: altitude,
      avgAltitude: altitude,
      sampleCount: 0,
    );
  }

  /// Reset all data
  AltimeterData reset() {
    return AltimeterData();
  }

  // Formatted getters
  String get altitudeFormatted => altitude.toStringAsFixed(1);
  String get altitudeFeet => (altitude * 3.28084).toStringAsFixed(0);

  String get gpsAltitudeFormatted => gpsAltitude.toStringAsFixed(1);
  String get barometerAltitudeFormatted => barometerAltitude.toStringAsFixed(1);

  String get maxAltitudeFormatted => maxAltitude == double.negativeInfinity
      ? '0.0'
      : maxAltitude.toStringAsFixed(1);
  String get minAltitudeFormatted =>
      minAltitude == double.infinity ? '0.0' : minAltitude.toStringAsFixed(1);
  String get avgAltitudeFormatted => avgAltitude.toStringAsFixed(1);

  String get verticalSpeedFormatted => verticalSpeed.toStringAsFixed(2);
  String get verticalSpeedFpm =>
      (verticalSpeed * 196.85).toStringAsFixed(0); // feet per minute

  String get accuracyFormatted => accuracy.toStringAsFixed(1);
  String get pressureFormatted => pressure.toStringAsFixed(2);

  /// Get altitude gain (difference from minimum)
  double get altitudeGain =>
      (minAltitude == double.infinity || altitude < minAltitude)
      ? 0
      : altitude - minAltitude;

  String get altitudeGainFormatted => altitudeGain.toStringAsFixed(1);

  /// Get altitude loss (difference from maximum)
  double get altitudeLoss =>
      (maxAltitude == double.negativeInfinity || altitude > maxAltitude)
      ? 0
      : maxAltitude - altitude;

  String get altitudeLossFormatted => altitudeLoss.toStringAsFixed(1);

  /// Get source display name
  String get sourceDisplayName {
    switch (primarySource) {
      case AltitudeSource.gps:
        return 'GPS';
      case AltitudeSource.barometer:
        return 'Barometer';
      case AltitudeSource.fused:
        return 'GPS + Barometer';
    }
  }

  /// Get accuracy level description
  String get accuracyLevel {
    if (accuracy < 5) return 'Excellent';
    if (accuracy < 10) return 'Good';
    if (accuracy < 20) return 'Fair';
    return 'Poor';
  }
}
