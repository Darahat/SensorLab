import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

/// Manages the time series data for a single sensor.
class SensorTimeSeriesNotifier extends StateNotifier<List<double>> {
  SensorTimeSeriesNotifier() : super([]);

  DateTime? _lastUpdate;
  static const _minUpdateInterval = Duration(
    milliseconds: 500,
  ); // Update UI max 2 times per second

  /// Adds a new data point to the time series.
  /// Keeps the list limited to the last 100 points for performance.
  /// Throttles UI updates to 2 Hz to reduce CPU/GPU load.
  void addDataPoint(double value) {
    final now = DateTime.now();

    // Throttle UI updates
    if (_lastUpdate != null &&
        now.difference(_lastUpdate!) < _minUpdateInterval) {
      // Skip UI update but keep the value for next batch
      return;
    }

    _lastUpdate = now;
    state = [...state, value];
    if (state.length > 100) {
      state = state.sublist(state.length - 100);
    }
  }

  /// Clears all data points from the time series.
  void clear() {
    state = [];
    _lastUpdate = null;
  }
}

/// A family of providers for each sensor's time series data.
///
/// Usage: `ref.watch(sensorTimeSeriesProvider(SensorType.lightMeter))`
final sensorTimeSeriesProvider =
    StateNotifierProvider.family<
      SensorTimeSeriesNotifier,
      List<double>,
      SensorType
    >((ref, sensorType) => SensorTimeSeriesNotifier());
