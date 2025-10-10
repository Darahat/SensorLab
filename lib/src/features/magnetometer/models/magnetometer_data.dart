import 'dart:math' as math;

class MagnetometerData {
  final double x;
  final double y;
  final double z;
  final double strength;
  final double maxStrength;
  final bool isActive;

  const MagnetometerData({
    this.x = 0,
    this.y = 0,
    this.z = 0,
    this.strength = 0,
    this.maxStrength = 0,
    this.isActive = false,
  });

  MagnetometerData copyWith({
    double? x,
    double? y,
    double? z,
    double? strength,
    double? maxStrength,
    bool? isActive,
  }) {
    return MagnetometerData(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      strength: strength ?? this.strength,
      maxStrength: maxStrength ?? this.maxStrength,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Calculate magnetic field strength from x, y, z components
  static double calculateStrength(double x, double y, double z) {
    return math.sqrt(x * x + y * y + z * z);
  }

  /// Get normalized strength (0-1 scale) for visualization
  double get normalizedStrength => (strength / 1000).clamp(0, 1);

  /// Get angle for compass needle visualization
  double get fieldAngle => math.atan2(y, x);

  /// Get formatted current values
  String get xFormatted => x.toStringAsFixed(2);
  String get yFormatted => y.toStringAsFixed(2);
  String get zFormatted => z.toStringAsFixed(2);
  String get strengthFormatted => strength.toStringAsFixed(2);
  String get maxStrengthFormatted => maxStrength.toStringAsFixed(2);

  /// Get strength with unit
  String get strengthWithUnit => '${strengthFormatted} μT';
  String get maxStrengthWithUnit => 'Max: ${maxStrengthFormatted} μT';

  /// Check if magnetic field is strong
  bool get hasStrongField => strength > 100; // μT threshold

  /// Get field intensity (0-1 scale)
  double get fieldIntensity {
    const maxExpectedField = 500.0; // μT
    return (strength / maxExpectedField).clamp(0.0, 1.0);
  }

  /// Get normalized axis values for visualization (-1 to 1)
  double get normalizedX => (x / 1000).clamp(-1.0, 1.0);
  double get normalizedY => (y / 1000).clamp(-1.0, 1.0);
  double get normalizedZ => (z / 1000).clamp(-1.0, 1.0);

  /// Reset max strength
  MagnetometerData resetMaxStrength() {
    return copyWith(maxStrength: 0);
  }
}
