import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Sensor Screens
import '../features/accelerometer/presentation/screens/accelerometer_screen.dart';
// App Settings
import '../features/app_settings/presentation/pages/settings_page.dart';
import '../features/compass/presentation/screens/compass_screen.dart';
import '../features/flashlight/presentation/screens/flashlight_screen.dart';
import '../features/gyroscope/presentation/screens/gyroscope_screen.dart';
import '../features/health/presentation/screens/health_screen.dart';
import '../features/humidity/presentation/screens/humidity_screen.dart';
import '../features/light_meter/presentation/screens/light_meter_screen.dart';
import '../features/magnetometer/presentation/screens/magnetometer_screen.dart';
import '../features/noise_meter/presentation/screens/noise_meter_screen.dart';
import '../features/proximity/presentation/screens/proximity_screen.dart';
import '../features/qr_scanner/presentation/screens/qr_scanner_screen.dart';
// Scanner Models
import '../features/scanner/models/scan_result.dart';
import '../features/scanner/presentation/screens/barcode_scanner_screen.dart';
import '../features/scanner/presentation/screens/scan_result_screen.dart';
// Scanner Screens
import '../features/scanner/presentation/screens/scanner_main_screen.dart';
// Shared screens
import '../shared/presentation/screens/home_screen.dart';
import '../shared/presentation/screens/splash_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Home Screen
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Settings
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),

      // Sensor Routes
      GoRoute(
        path: '/accelerometer',
        name: 'accelerometer',
        builder: (context, state) => const AccelerometerScreen(),
      ),
      GoRoute(
        path: '/compass',
        name: 'compass',
        builder: (context, state) => const CompassScreen(),
      ),
      GoRoute(
        path: '/flashlight',
        name: 'flashlight',
        builder: (context, state) => const FlashlightScreen(),
      ),
      GoRoute(
        path: '/gyroscope',
        name: 'gyroscope',
        builder: (context, state) => const GyroscopeScreen(),
      ),
      GoRoute(
        path: '/health',
        name: 'health',
        builder: (context, state) => const HealthScreen(),
      ),
      GoRoute(
        path: '/humidity',
        name: 'humidity',
        builder: (context, state) => const HumidityScreen(),
      ),
      GoRoute(
        path: '/light-meter',
        name: 'light-meter',
        builder: (context, state) => const LightMeterScreen(),
      ),
      GoRoute(
        path: '/magnetometer',
        name: 'magnetometer',
        builder: (context, state) => const MagnetometerScreen(),
      ),
      GoRoute(
        path: '/noise-meter',
        name: 'noise-meter',
        builder: (context, state) => const NoiseMeterScreen(),
      ),
      GoRoute(
        path: '/proximity',
        name: 'proximity',
        builder: (context, state) => const ProximityScreen(),
      ),

      // Scanner Routes
      GoRoute(
        path: '/scanner',
        name: 'scanner',
        builder: (context, state) => const ScannerMainScreen(),
        routes: [
          GoRoute(
            path: '/qr',
            name: 'qr-scanner',
            builder: (context, state) => const QRScannerScreen(),
          ),
          GoRoute(
            path: '/barcode',
            name: 'barcode-scanner',
            builder: (context, state) => const BarcodeScannerScreen(),
          ),
          GoRoute(
            path: '/result',
            name: 'scan-result',
            builder: (context, state) {
              final result = state.extra as ScanResult?;
              return ScanResultScreen(result: result!);
            },
          ),
        ],
      ),
    ],
  );
});
