import 'dart:math' as math;

class AccelerometerData {
  final double x;
  final double y;
  final double z;
  final double maxX;
  final double maxY;
  final double maxZ;
  final bool isActive;

  const AccelerometerData({
    this.x = 0,
    this.y = 0,
    this.z = 0,
    this.maxX = 0,
    this.maxY = 0,
    this.maxZ = 0,
    this.isActive = false,
  });

  AccelerometerData copyWith({
    double? x,
    double? y,
    double? z,
    double? maxX,
    double? maxY,
    double? maxZ,
    bool? isActive,
  }) {
    return AccelerometerData(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      maxX: maxX ?? this.maxX,
      maxY: maxY ?? this.maxY,
      maxZ: maxZ ?? this.maxZ,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Calculate the magnitude of acceleration vector
  double get magnitude => math.sqrt(x * x + y * y + z * z);

  /// Calculate the maximum magnitude recorded
  double get maxMagnitude => math.sqrt(maxX * maxX + maxY * maxY + maxZ * maxZ);

  /// Get formatted current values
  String get xFormatted => x.toStringAsFixed(2);
  String get yFormatted => y.toStringAsFixed(2);
  String get zFormatted => z.toStringAsFixed(2);

  /// Get formatted max values
  String get maxXFormatted => maxX.toStringAsFixed(2);
  String get maxYFormatted => maxY.toStringAsFixed(2);
  String get maxZFormatted => maxZ.toStringAsFixed(2);

  /// Get formatted magnitude
  String get magnitudeFormatted => magnitude.toStringAsFixed(2);

  /// Check if device is experiencing significant motion
  bool get hasSignificantMotion =>
      magnitude > 1.0; // Threshold for motion detection

  /// Get motion intensity (0-1 scale)
  double get motionIntensity {
    const maxExpectedAcceleration = 20.0; // m/s²
    return (magnitude / maxExpectedAcceleration).clamp(0.0, 1.0);
  }

  /// Reset max values
  AccelerometerData resetMaxValues() {
    return copyWith(maxX: 0, maxY: 0, maxZ: 0);
  }
}
