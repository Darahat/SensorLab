import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
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
import 'package:sensorlab/src/features/qr_scanner/presentation/screens/qr_scanner_screen.dart';
import 'package:sensorlab/src/shared/models/sensor_card.dart';

final List<SensorCard> sensors = [
  SensorCard(
    icon: Icons.health_and_safety,
    label: 'Calorie Burn',
    color: Colors.yellow,
    screen: const HealthScreen(),
    category: 'Health',
  ),
  SensorCard(
    icon: Iconsax.location,
    label: 'Geolocator',
    color: Colors.teal,
    screen: GeolocatorPage(),
    category: 'Location',
  ),
  SensorCard(
    icon: Iconsax.sun_1,
    label: 'Light Meter',
    color: Colors.amber,
    screen: const LightMeterScreen(),
    category: 'Environment',
  ),
  SensorCard(
    icon: Icons.compass_calibration_rounded,
    label: 'Compass',
    color: Colors.deepPurple,
    screen: const CompassScreen(),
    category: 'Navigation',
  ),
  SensorCard(
    icon: Iconsax.activity,
    label: 'Accelerometer',
    color: Colors.pink,
    screen: const AccelerometerScreen(),
    category: 'Motion',
  ),
  SensorCard(
    icon: Iconsax.cpu,
    label: 'Gyroscope',
    color: Colors.blue,
    screen: const GyroscopeScreen(),
    category: 'Motion',
  ),
  SensorCard(
    icon: FontAwesomeIcons.magnet,
    label: 'Magnetometer',
    color: Colors.red,
    screen: const MagnetometerScreen(),
    category: 'Magnetic',
  ),

  SensorCard(
    icon: Iconsax.radar,
    label: 'Proximity',
    color: Colors.green,
    screen: const ProximityScreen(),
    category: 'Device',
  ),

  SensorCard(
    icon: Iconsax.heart,
    label: 'Heart Rate',
    color: Colors.orange,
    screen: const HeartRateScreen(),
    category: 'Health',
  ),
  SensorCard(
    icon: FontAwesomeIcons.droplet,
    label: 'Humidity',
    color: Colors.orange,
    screen: const HumidityScreen(),
    category: 'Environment',
  ),
  SensorCard(
    icon: Iconsax.flash,
    label: 'Flashlight',
    color: Colors.yellow,
    screen: FlashlightScreen(),
    category: 'Device',
  ),

  SensorCard(
    icon: Iconsax.scan,
    label: 'QR Scanner',
    color: Colors.lime,
    screen: const QRScannerScreen(),
    category: 'Utility',
  ),
];
