import 'package:sensorlab/src/features/noise_meter/application/state/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/utils/app_constants.dart';

class NoiseHelpers {
  static NoiseLevel calculateNoiseLevel(double decibels) {
    if (decibels < AppConstants.quietThreshold) return NoiseLevel.quiet;
    if (decibels < AppConstants.moderateThreshold) return NoiseLevel.moderate;
    if (decibels < AppConstants.loudThreshold) return NoiseLevel.loud;
    if (decibels < AppConstants.veryLoudThreshold) return NoiseLevel.veryLoud;
    return NoiseLevel.dangerous;
  }

  static bool isDangerousLevel(double decibels) {
    return decibels >= AppConstants.veryLoudThreshold;
  }

  static double calculateAverage(List<double> readings) {
    if (readings.isEmpty) return 0.0;
    final sum = readings.reduce((a, b) => a + b);
    return sum / readings.length;
  }

  static double findMax(List<double> readings) {
    if (readings.isEmpty) return 0.0;
    return readings.reduce((a, b) => a > b ? a : b);
  }

  static double findMin(List<double> readings) {
    if (readings.isEmpty) return 0.0;
    return readings.reduce((a, b) => a < b ? a : b);
  }
}
