import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/accelerometer_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/altimeter_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/barometer_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/compass_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/gps_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/gyroscope_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/heart_beat_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/light_meter_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/magnetometer_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/noise_meter_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/pedometer_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/proximity_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/speed_meter_display_widget.dart';

/// Factory to create sensor-specific recording widgets
/// This allows custom_lab to reuse existing sensor components from each feature
class SensorComponentFactory {
  /// Returns the appropriate recording widget for the given sensor type
  static Widget buildSensorWidget(SensorType sensorType) {
    switch (sensorType) {
      case SensorType.lightMeter:
        return const LightMeterDisplayWidget();

      case SensorType.noiseMeter:
        return const NoiseMeterDisplayWidget();

      case SensorType.accelerometer:
        return const AccelerometerDisplayWidget();

      case SensorType.gyroscope:
        return const GyroscopeDisplayWidget();

      case SensorType.magnetometer:
        return const MagnetometerDisplayWidget();

      case SensorType.temperature:
        // Temperature and Humidity are not yet implemented with RealtimeLineChart
        // For now, they will use a placeholder or be skipped.
        return const SizedBox.shrink();

      case SensorType.humidity:
        return const SizedBox.shrink();

      case SensorType.barometer:
        return const BarometerDisplayWidget();

      case SensorType.pedometer:
        return const PedometerDisplayWidget();

      case SensorType.compass:
        return const CompassDisplayWidget();

      case SensorType.altimeter:
        return const AltimeterDisplayWidget();

      case SensorType.speedMeter:
        return const SpeedMeterDisplayWidget();

      case SensorType.heartBeat:
        return const HeartBeatDisplayWidget();

      case SensorType.proximity:
        return const ProximityDisplayWidget();

      case SensorType.gps:
        return const GpsDisplayWidget();
    }
  }
}
