import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ad_manager.dart';

// Re-export feature providers for easy access
export '../features/accelerometer/presentation/providers/accelerometer_provider.dart';
export '../features/altimeter/presentation/providers/altimeter_provider.dart';
export '../features/compass/presentation/providers/compass_provider.dart';
export '../features/flashlight/presentation/providers/flashlight_provider.dart';
export '../features/geolocator/presentation/providers/geolocator_provider.dart';
export '../features/gyroscope/presentation/providers/gyroscope_provider.dart';
export '../features/health/providers/health_provider.dart';
export '../features/heart_beat/presentation/providers/heart_beat_provider.dart';
export '../features/humidity/presentation/providers/humidity_provider.dart';
export '../features/light_meter/presentation/providers/light_meter_provider.dart';
export '../features/magnetometer/presentation/providers/magnetometer_provider.dart';
export '../features/noise_meter/application/providers/enhanced_noise_meter_provider.dart';
export '../features/pedometer/presentation/providers/pedometer_provider.dart';
export '../features/proximity/presentation/providers/proximity_provider.dart';
export '../features/qr_scanner/presentation/providers/qr_scanner_provider.dart';
export '../features/speed_meter/presentation/providers/speed_meter_provider.dart';

final adManagerProvider = Provider<AdManager>((ref) {
  final mgr = AdManager();
  ref.onDispose(() {
    mgr.disposeInterstitial();
  });
  return mgr;
});
