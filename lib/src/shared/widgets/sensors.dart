import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/accelerometer/presentation/screens/accelerometer_screen.dart';
import 'package:sensorlab/src/features/compass/presentation/screens/compass_screen.dart';
import 'package:sensorlab/src/features/flashlight/presentation/screens/flashlight_screen.dart';
import 'package:sensorlab/src/features/geolocator/presentation/screens/geolocator_screen.dart';
import 'package:sensorlab/src/features/gyroscope/presentation/screens/gyroscope_screen.dart';
import 'package:sensorlab/src/features/health/presentation/screens/health_screen.dart';
import 'package:sensorlab/src/features/heart_beat/presentation/screens/heart_beat_screen.dart';
import 'package:sensorlab/src/features/humidity/presentation/screens/humidity_screen.dart';
import 'package:sensorlab/src/features/light_meter/presentation/screens/light_meter_screen.dart';
import 'package:sensorlab/src/features/magnetometer/presentation/screens/magnetometer_screen.dart';
import 'package:sensorlab/src/features/proximity/presentation/screens/proximity_screen.dart';
import 'package:sensorlab/src/features/scanner/presentation/screens/scanner_main_screen.dart';
import 'package:sensorlab/src/shared/models/sensor_card.dart';

List<SensorCard> getSensors(AppLocalizations l10n) {
  return [
    SensorCard(
      icon: Icons.health_and_safety,
      label: l10n.calorieBurn,
      color: Colors.yellow,
      screen: const HealthScreen(),
      category: l10n.health,
    ),
    SensorCard(
      icon: Iconsax.location,
      label: l10n.geolocator,
      color: Colors.teal,
      screen: GeolocatorPage(),
      category: l10n.location,
    ),
    SensorCard(
      icon: Iconsax.sun_1,
      label: l10n.lightMeter,
      color: Colors.amber,
      screen: const LightMeterScreen(),
      category: l10n.environment,
    ),
    SensorCard(
      icon: Icons.compass_calibration_rounded,
      label: l10n.compass,
      color: Colors.deepPurple,
      screen: const CompassScreen(),
      category: l10n.navigation,
    ),
    SensorCard(
      icon: Iconsax.activity,
      label: l10n.accelerometer,
      color: Colors.pink,
      screen: const AccelerometerScreen(),
      category: l10n.motion,
    ),
    SensorCard(
      icon: Iconsax.cpu,
      label: l10n.gyroscope,
      color: Colors.blue,
      screen: const GyroscopeScreen(),
      category: l10n.motion,
    ),
    SensorCard(
      icon: FontAwesomeIcons.magnet,
      label: l10n.magnetometer,
      color: Colors.red,
      screen: const MagnetometerScreen(),
      category: l10n.magnetic,
    ),
    SensorCard(
      icon: Iconsax.radar,
      label: l10n.proximity,
      color: Colors.green,
      screen: const ProximityScreen(),
      category: l10n.device,
    ),
    SensorCard(
      icon: Iconsax.heart,
      label: l10n.heartRate,
      color: Colors.orange,
      screen: const HeartRateScreen(),
      category: l10n.health,
    ),
    SensorCard(
      icon: FontAwesomeIcons.droplet,
      label: l10n.humidity,
      color: Colors.orange,
      screen: const HumidityScreen(),
      category: l10n.environment,
    ),
    SensorCard(
      icon: Iconsax.flash,
      label: l10n.flashlight,
      color: Colors.yellow,
      screen: const FlashlightScreen(),
      category: l10n.device,
    ),
    SensorCard(
      icon: Iconsax.scan,
      label: l10n.scanner,
      color: Colors.lime,
      screen: const ScannerMainScreen(),
      category: l10n.utility,
    ),
  ];
}