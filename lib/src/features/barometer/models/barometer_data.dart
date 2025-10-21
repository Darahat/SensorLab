import 'dart:math' as math;

class BarometerData {
  final double pressure; // Atmospheric pressure in hectopascals (hPa)
  final double maxPressure; // Maximum pressure recorded in hPa
  final double minPressure; // Minimum pressure recorded in hPa
  final double avgPressure; // Average pressure in hPa
  final bool isActive;
  final int sampleCount; // Number of pressure samples collected
  final DateTime timestamp; // Time of the measurement

  BarometerData({
    this.pressure = 0,
    this.maxPressure = 0,
    this.minPressure = double.infinity,
    this.avgPressure = 0,
    this.isActive = false,
    this.sampleCount = 0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  BarometerData copyWith({
    double? pressure,
    double? maxPressure,
    double? minPressure,
    double? avgPressure,
    bool? isActive,
    int? sampleCount,
    DateTime? timestamp,
  }) {
    return BarometerData(
      pressure: pressure ?? this.pressure,
      maxPressure: maxPressure ?? this.maxPressure,
      minPressure: minPressure ?? this.minPressure,
      avgPressure: avgPressure ?? this.avgPressure,
      isActive: isActive ?? this.isActive,
      sampleCount: sampleCount ?? this.sampleCount,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Reset all values
  BarometerData reset() {
    return BarometerData();
  }

  /// Reset max, min, and average values, keep current pressure
  BarometerData resetStats() {
    return BarometerData(
      pressure: pressure,
      isActive: isActive,
      timestamp: timestamp,
    );
  }

  // Pressure conversions
  /// Get pressure in millibars (mb) - same as hPa
  double get pressureMb => pressure;

  /// Get pressure in inches of mercury (inHg)
  double get pressureInHg => pressure * 0.02953;

  /// Get pressure in millimeters of mercury (mmHg)
  double get pressureMmHg => pressure * 0.750062;

  /// Get pressure in kilopascals (kPa)
  double get pressureKPa => pressure / 10;

  /// Get pressure in atmospheres (atm)
  double get pressureAtm => pressure / 1013.25;

  /// Get pressure in pounds per square inch (psi)
  double get pressurePsi => pressure * 0.0145038;

  // Max pressure conversions
  double get maxPressureMb => maxPressure;
  double get maxPressureInHg => maxPressure * 0.02953;
  double get maxPressureMmHg => maxPressure * 0.750062;

  // Min pressure conversions
  double get minPressureMb => minPressure == double.infinity ? 0 : minPressure;
  double get minPressureInHg => minPressureMb * 0.02953;
  double get minPressureMmHg => minPressureMb * 0.750062;

  // Average pressure conversions
  double get avgPressureMb => avgPressure;
  double get avgPressureInHg => avgPressure * 0.02953;
  double get avgPressureMmHg => avgPressure * 0.750062;

  // Weather prediction based on pressure
  /// Get weather trend based on current pressure
  WeatherTrend get weatherTrend {
    if (pressure > 1022.689) {
      return WeatherTrend.high; // High pressure - Clear/Fair weather
    } else if (pressure < 1009.144) {
      return WeatherTrend.low; // Low pressure - Cloudy/Rainy weather
    } else {
      return WeatherTrend.normal; // Normal pressure - Stable weather
    }
  }

  /// Get pressure change trend (requires historical data)
  PressureTrend getPressureTrend(double previousPressure) {
    final diff = pressure - previousPressure;
    if (diff > 1.0) {
      return PressureTrend.rising; // Pressure rising - Weather improving
    } else if (diff < -1.0) {
      return PressureTrend.falling; // Pressure falling - Weather worsening
    } else {
      return PressureTrend.steady; // Pressure steady - Weather stable
    }
  }

  /// Calculate altitude from pressure (assuming sea level pressure = 1013.25 hPa)
  /// Formula: h = 44330 * (1 - (P/P0)^0.1903)
  double get estimatedAltitude {
    if (pressure <= 0) return 0;
    const seaLevelPressure = 1013.25;
    return (44330 * (1 - math.pow(pressure / seaLevelPressure, 0.1903)))
        .toDouble();
  }

  // Formatted values
  /// Get formatted current pressure in hPa
  String get pressureFormatted => pressure.toStringAsFixed(2);

  /// Get formatted current pressure in inHg
  String get pressureInHgFormatted => pressureInHg.toStringAsFixed(2);

  /// Get formatted current pressure in mmHg
  String get pressureMmHgFormatted => pressureMmHg.toStringAsFixed(1);

  /// Get formatted max pressure in hPa
  String get maxPressureFormatted => maxPressure.toStringAsFixed(2);

  /// Get formatted min pressure in hPa
  String get minPressureFormatted => minPressureMb.toStringAsFixed(2);

  /// Get formatted average pressure in hPa
  String get avgPressureFormatted => avgPressure.toStringAsFixed(2);

  /// Get formatted altitude in meters
  String get altitudeFormatted => estimatedAltitude.toStringAsFixed(0);

  /// Get formatted altitude in feet
  String get altitudeFeetFormatted =>
      (estimatedAltitude * 3.28084).toStringAsFixed(0);
}

/// Weather trend based on atmospheric pressure
enum WeatherTrend {
  high, // High pressure - Clear/Fair weather
  normal, // Normal pressure - Stable weather
  low, // Low pressure - Cloudy/Rainy weather
}

/// Pressure change trend
enum PressureTrend {
  rising, // Pressure rising - Weather improving
  steady, // Pressure steady - Weather stable
  falling, // Pressure falling - Weather worsening
}
