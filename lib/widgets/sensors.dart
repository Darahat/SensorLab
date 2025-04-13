import 'package:all_in_one_sensor_toolkit/models/sensor_card.dart';
import 'package:all_in_one_sensor_toolkit/screens/flashlight_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:all_in_one_sensor_toolkit/screens/compass_screen.dart';
import 'package:all_in_one_sensor_toolkit/screens/geolocator_screen.dart';
import 'package:all_in_one_sensor_toolkit/screens/light_meter_screen.dart';
import 'package:all_in_one_sensor_toolkit/screens/noise_meter_screen.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:all_in_one_sensor_toolkit/widgets/create_interstitial_ad.dart';
import 'package:all_in_one_sensor_toolkit/widgets/sensor_grid_item.dart';
import 'package:all_in_one_sensor_toolkit/widgets/sensor_search_delegate.dart';
import 'package:all_in_one_sensor_toolkit/widgets/show_settings.dart';
import 'package:all_in_one_sensor_toolkit/screens/gyroscope_screen.dart';
import 'package:all_in_one_sensor_toolkit/screens/accelerometer_screen.dart';
import 'package:all_in_one_sensor_toolkit/screens/proximity_screen.dart';
import 'package:all_in_one_sensor_toolkit/screens/qr_scanner_screen.dart';
import 'package:all_in_one_sensor_toolkit/screens/magnetometer_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final List<SensorCard> sensors = [
  SensorCard(
    icon: Iconsax.sound,
    label: 'Noise Meter',
    color: Colors.indigo,
    screen: const NoiseMeterScreen(),
    category: 'Audio',
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
  // SensorCard(
  //   icon: Iconsax.cloud_snow,
  //   label: 'Barometer',
  //   color: Colors.cyan,
  //   screen: const BarometerScreen(),
  //   category: 'Environment',
  // ),
  SensorCard(
    icon: Iconsax.radar,
    label: 'Proximity',
    color: Colors.green,
    screen: const ProximityScreen(),
    category: 'Device',
  ),
  // SensorCard(
  //   icon: Iconsax.temperature,
  //   label: 'Temperature',
  //   color: Colors.orange,
  //   screen: const TemperatureScreen(),
  //   category: 'Environment',
  // ),
  // SensorCard(
  //   icon: Iconsax.drop,
  //   label: 'Humidity',
  //   color: Colors.lightBlue,
  //   screen: const HumidityScreen(),
  //   category: 'Environment',
  // ),
  SensorCard(
    icon: Iconsax.flash,
    label: 'Flashlight',
    color: Colors.yellow,
    screen: FlashlightScreen(),
    category: 'Device',
  ),
  // SensorCard(
  //   icon: Iconsax.graph,
  //   label: 'Sound Graph',
  //   color: Colors.purple,
  //   screen: const SoundGraphScreen(),
  //   category: 'Audio',
  // ),
  SensorCard(
    icon: Iconsax.scan,
    label: 'QR Scanner',
    color: Colors.lime,
    screen: const QRScannerScreen(),
    category: 'Utility',
  ),
];
