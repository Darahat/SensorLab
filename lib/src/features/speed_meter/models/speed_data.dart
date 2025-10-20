class SpeedData {
  final double currentSpeed; // Current speed in m/s
  final double maxSpeed; // Maximum speed recorded in m/s
  final double avgSpeed; // Average speed in m/s
  final double distance; // Total distance traveled in meters
  final bool isActive;
  final int sampleCount; // Number of speed samples collected

  const SpeedData({
    this.currentSpeed = 0,
    this.maxSpeed = 0,
    this.avgSpeed = 0,
    this.distance = 0,
    this.isActive = false,
    this.sampleCount = 0,
  });

  SpeedData copyWith({
    double? currentSpeed,
    double? maxSpeed,
    double? avgSpeed,
    double? distance,
    bool? isActive,
    int? sampleCount,
  }) {
    return SpeedData(
      currentSpeed: currentSpeed ?? this.currentSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      avgSpeed: avgSpeed ?? this.avgSpeed,
      distance: distance ?? this.distance,
      isActive: isActive ?? this.isActive,
      sampleCount: sampleCount ?? this.sampleCount,
    );
  }

  /// Reset all values
  SpeedData reset() {
    return const SpeedData();
  }

  /// Reset max and average values, keep current speed
  SpeedData resetStats() {
    return SpeedData(currentSpeed: currentSpeed, isActive: isActive);
  }

  // Speed conversions
  /// Get current speed in kilometers per hour
  double get speedKmh => currentSpeed * 3.6;

  /// Get current speed in miles per hour
  double get speedMph => currentSpeed * 2.23694;

  /// Get max speed in kilometers per hour
  double get maxSpeedKmh => maxSpeed * 3.6;

  /// Get max speed in miles per hour
  double get maxSpeedMph => maxSpeed * 2.23694;

  /// Get average speed in kilometers per hour
  double get avgSpeedKmh => avgSpeed * 3.6;

  /// Get average speed in miles per hour
  double get avgSpeedMph => avgSpeed * 2.23694;

  // Distance conversions
  /// Get distance in kilometers
  double get distanceKm => distance / 1000;

  /// Get distance in miles
  double get distanceMiles => distance / 1609.34;

  // Formatted values
  /// Get formatted current speed (m/s)
  String get currentSpeedFormatted => currentSpeed.toStringAsFixed(2);

  /// Get formatted current speed in km/h
  String get speedKmhFormatted => speedKmh.toStringAsFixed(1);

  /// Get formatted current speed in mph
  String get speedMphFormatted => speedMph.toStringAsFixed(1);

  /// Get formatted max speed in km/h
  String get maxSpeedKmhFormatted => maxSpeedKmh.toStringAsFixed(1);

  /// Get formatted max speed in mph
  String get maxSpeedMphFormatted => maxSpeedMph.toStringAsFixed(1);

  /// Get formatted average speed in km/h
  String get avgSpeedKmhFormatted => avgSpeedKmh.toStringAsFixed(1);

  /// Get formatted average speed in mph
  String get avgSpeedMphFormatted => avgSpeedMph.toStringAsFixed(1);

  /// Get formatted distance in km
  String get distanceKmFormatted => distanceKm.toStringAsFixed(2);

  /// Get formatted distance in miles
  String get distanceMilesFormatted => distanceMiles.toStringAsFixed(2);
}
