import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../models/altimeter_data.dart';

class AltimeterNotifier extends StateNotifier<AltimeterData> {
  StreamSubscription<Position>? _gpsSubscription;
  StreamSubscription<BarometerEvent>? _barometerSubscription;
  Timer? _fusionTimer;

  AltimeterNotifier() : super(AltimeterData()) {
    _initialize();
  }

  Future<void> _initialize() async {
    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    _startGPSStream();
    _startBarometerStream();
    _startFusionTimer();
  }

  void _startGPSStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0, // Get updates for any altitude change
    );

    _gpsSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            state = state.updateGPS(
              gpsAlt: position.altitude,
              gpsAccuracy: position.altitudeAccuracy,
              timestamp: position.timestamp,
            );
          },
          onError: (error) {
            // Handle GPS errors silently
          },
          cancelOnError: false,
        );
  }

  void _startBarometerStream() {
    _barometerSubscription = barometerEventStream().listen(
      (BarometerEvent event) {
        state = state.updateBarometer(pressureHPa: event.pressure);
      },
      onError: (error) {
        // Handle barometer errors silently
      },
      cancelOnError: false,
    );
  }

  /// Fusion timer to periodically combine GPS and barometer data
  void _startFusionTimer() {
    _fusionTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (state.gpsAltitude != 0 || state.barometerAltitude != 0) {
        state = state.fuseAltitude();
      }
    });
  }

  /// Calibrate sea level pressure using known altitude
  /// This improves barometric altitude accuracy
  void calibrate(double knownAltitude) {
    state = state.calibrateSeaLevelPressure(knownAltitude);
  }

  /// Reset statistics (max, min, avg)
  void resetStats() {
    state = state.resetStats();
  }

  /// Reset all data
  void reset() {
    state = AltimeterData();
  }

  @override
  void dispose() {
    _gpsSubscription?.cancel();
    _barometerSubscription?.cancel();
    _fusionTimer?.cancel();
    super.dispose();
  }
}

final altimeterProvider =
    StateNotifierProvider<AltimeterNotifier, AltimeterData>(
      (ref) => AltimeterNotifier(),
    );
