import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

/// Manages the time series data for a single sensor.
class SensorTimeSeriesNotifier extends StateNotifier<List<double>> {
  SensorTimeSeriesNotifier() : super([]);

  /// Adds a new data point to the time series.
  /// Keeps the list limited to the last 100 points for performance.
  void addDataPoint(double value) {
    state = [...state, value];
    if (state.length > 100) {
      state = state.sublist(state.length - 100);
    }
  }

  /// Clears all data points from the time series.
  void clear() {
    state = [];
  }
}

/// A family of providers for each sensor's time series data.
///
/// Usage: `ref.watch(sensorTimeSeriesProvider(SensorType.lightMeter))`
final sensorTimeSeriesProvider =
    StateNotifierProvider.family<SensorTimeSeriesNotifier, List<double>, SensorType>(
  (ref, sensorType) => SensorTimeSeriesNotifier(),
);
