import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ad_manager.dart';

export '../features/accelerometer/providers/accelerometer_provider.dart';
export '../features/compass/providers/compass_provider.dart';
export '../features/flashlight/providers/flashlight_provider.dart';
// Re-export feature providers for easy access
export '../features/gyroscope/providers/gyroscope_provider.dart';
export '../features/heart_beat/providers/heart_beat_provider.dart';
export '../features/humidity/providers/humidity_provider.dart';
export '../features/light_meter/providers/light_meter_provider.dart';
export '../features/magnetometer/providers/magnetometer_provider.dart';
export '../features/noise_meter/providers/noise_meter_provider.dart';
export '../features/proximity/providers/proximity_provider.dart';

final adManagerProvider = Provider<AdManager>((ref) {
  final mgr = AdManager();
  ref.onDispose(() {
    mgr.disposeInterstitial();
  });
  return mgr;
});
