import 'dart:async';
import 'dart:math' show max;

// Note: Removed random-based simulation; this provider now uses only real GPS data.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/geolocator_data.dart';

// Provider instance
final geolocatorProvider =
    StateNotifierProvider<GeolocatorProvider, GeolocatorData>(
      (ref) => GeolocatorProvider(),
    );

class GeolocatorProvider extends StateNotifier<GeolocatorData> {
  GeolocatorProvider() : super(GeolocatorData());

  StreamSubscription<Position>? _positionSubscription;
  Timer? _trackingTimer;
  DateTime? _lastLocationUpdate;

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }

  // Initialize location services
  Future<void> initialize() async {
    state = state.copyWith(isInitialized: false);

    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      // Check location permission
      final permission = await _checkPermission();

      state = state.copyWith(
        isServiceEnabled: serviceEnabled,
        permissionStatus: _mapPermission(permission),
        isInitialized: true,
        sessionStartTime: DateTime.now(),
      );

      // Auto-get location if possible
      if (state.canGetLocation) {
        await getCurrentLocation();
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to initialize: $e',
        isInitialized: true,
      );
    }
  }

  // Request location permission
  Future<void> requestPermission() async {
    try {
      final permission = await Geolocator.requestPermission();
      state = state.copyWith(permissionStatus: _mapPermission(permission));

      // Try to get location if permission granted
      if (state.permissionStatus.isGranted) {
        await getCurrentLocation();
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Permission request failed: $e');
    }
  }

  // Open app settings for location
  Future<void> openLocationSettings() async {
    try {
      await Geolocator.openAppSettings();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to open settings: $e');
    }
  }

  // Get current location once
  Future<void> getCurrentLocation() async {
    if (!state.canGetLocation) {
      state = state.copyWith(
        errorMessage: 'Cannot get location. Check permissions and service.',
      );
      return;
    }

    state = state.copyWith(isLoadingLocation: true);

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: state.desiredAccuracy,
        timeLimit: const Duration(seconds: 30),
      );

      final locationData = LocationData.fromPosition(position);

      state = state.copyWith(
        currentLocation: locationData,
        isLoadingLocation: false,
        locationUpdates: state.locationUpdates + 1,
      );

      // Get address for the location
      await _getAddressForLocation(locationData);
    } catch (e) {
      state = state.copyWith(
        isLoadingLocation: false,
        errorMessage: 'Failed to get location: $e',
      );
    }
  }

  // Start continuous location tracking
  Future<void> startTracking() async {
    if (!state.canTrackLocation) {
      state = state.copyWith(
        errorMessage: 'Cannot start tracking. Check permissions and service.',
      );
      return;
    }

    try {
      final locationSettings = LocationSettings(
        accuracy: state.desiredAccuracy,
        distanceFilter: state.distanceFilter,
        timeLimit: const Duration(seconds: 30),
      );

      _positionSubscription =
          Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen(
            _handleLocationUpdate,
            onError: (error) {
              state = state.copyWith(
                errorMessage: 'Location tracking error: $error',
              );
            },
          );

      // Start tracking timer
      _trackingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateTrackingDuration();
      });

      state = state.copyWith(
        isTracking: true,
        sessionStartTime: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to start tracking: $e');
    }
  }

  // Stop location tracking
  void stopTracking() {
    _positionSubscription?.cancel();
    _trackingTimer?.cancel();
    _positionSubscription = null;
    _trackingTimer = null;

    state = state.copyWith(isTracking: false);
  }

  // Clear all location data
  void clearData() {
    stopTracking();

    state = GeolocatorData(
      permissionStatus: state.permissionStatus,
      isServiceEnabled: state.isServiceEnabled,
      isInitialized: state.isInitialized,
      desiredAccuracy: state.desiredAccuracy,
      distanceFilter: state.distanceFilter,
      timeInterval: state.timeInterval,
      sessionStartTime: DateTime.now(),
    );
  }

  // Settings
  void setAccuracy(LocationAccuracy accuracy) {
    state = state.copyWith(desiredAccuracy: accuracy);
  }

  void setDistanceFilter(int distance) {
    state = state.copyWith(distanceFilter: distance);
  }

  void setTimeInterval(Duration interval) {
    state = state.copyWith(timeInterval: interval);
  }

  // Private methods
  Future<LocationPermission> _checkPermission() async {
    return await Geolocator.checkPermission();
  }

  LocationPermissionStatus _mapPermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
        return LocationPermissionStatus.always;
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.whileInUse;
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.unableToDetermine;
    }
  }

  void _handleLocationUpdate(Position position) {
    final locationData = LocationData.fromPosition(position);
    final previousLocation = state.currentLocation;

    // Calculate distance if we have a previous location
    double addedDistance = 0.0;
    if (previousLocation != null) {
      addedDistance = Geolocator.distanceBetween(
        previousLocation.latitude,
        previousLocation.longitude,
        locationData.latitude,
        locationData.longitude,
      );
    }

    // Update location history
    final updatedHistory = List<LocationData>.from(state.locationHistory);
    updatedHistory.add(locationData);

    // Keep only last 100 locations
    if (updatedHistory.length > 100) {
      updatedHistory.removeAt(0);
    }

    // Calculate statistics
    final newTotalDistance = state.totalDistance + addedDistance;
    final newMaxSpeed = max(state.maxSpeed, locationData.speed);
    final newAverageSpeed = _calculateAverageSpeed(updatedHistory);

    state = state.copyWith(
      currentLocation: locationData,
      locationHistory: updatedHistory,
      totalDistance: newTotalDistance,
      maxSpeed: newMaxSpeed,
      averageSpeed: newAverageSpeed,
      locationUpdates: state.locationUpdates + 1,
    );

    // Get address occasionally (not for every update to save API calls)
    if (_shouldUpdateAddress()) {
      _getAddressForLocation(locationData);
    }

    _lastLocationUpdate = DateTime.now();
  }

  bool _shouldUpdateAddress() {
    if (_lastLocationUpdate == null) return true;

    // Update address every 30 seconds or if moved significantly
    final timeSinceLastUpdate = DateTime.now().difference(_lastLocationUpdate!);
    return timeSinceLastUpdate > const Duration(seconds: 30);
  }

  Future<void> _getAddressForLocation(LocationData location) async {
    if (state.isLoadingAddress) return;

    state = state.copyWith(isLoadingAddress: true);

    try {
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;

        final addressData = AddressData(
          fullAddress: _formatFullAddress(placemark),
          country: placemark.country ?? '',
          locality: placemark.locality ?? '',
          subLocality: placemark.subLocality ?? '',
          street: _formatStreet(placemark),
          postalCode: placemark.postalCode ?? '',
          timestamp: DateTime.now(),
        );

        state = state.copyWith(
          currentAddress: addressData,
          isLoadingAddress: false,
        );
      } else {
        state = state.copyWith(isLoadingAddress: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingAddress: false,
        errorMessage: 'Failed to get address: $e',
      );
    }
  }

  String _formatFullAddress(Placemark placemark) {
    final parts = <String>[];

    if (placemark.street?.isNotEmpty == true) {
      parts.add(placemark.street!);
    }

    if (placemark.subLocality?.isNotEmpty == true) {
      parts.add(placemark.subLocality!);
    }

    if (placemark.locality?.isNotEmpty == true) {
      parts.add(placemark.locality!);
    }

    if (placemark.administrativeArea?.isNotEmpty == true) {
      parts.add(placemark.administrativeArea!);
    }

    if (placemark.postalCode?.isNotEmpty == true) {
      parts.add(placemark.postalCode!);
    }

    if (placemark.country?.isNotEmpty == true) {
      parts.add(placemark.country!);
    }

    return parts.join(', ');
  }

  String _formatStreet(Placemark placemark) {
    final parts = <String>[];

    if (placemark.subThoroughfare?.isNotEmpty == true) {
      parts.add(placemark.subThoroughfare!);
    }

    if (placemark.thoroughfare?.isNotEmpty == true) {
      parts.add(placemark.thoroughfare!);
    }

    return parts.join(' ');
  }

  double _calculateAverageSpeed(List<LocationData> history) {
    if (history.isEmpty) return 0.0;

    final speeds = history.map((location) => location.speed).toList();
    final totalSpeed = speeds.reduce((a, b) => a + b);

    return totalSpeed / speeds.length;
  }

  void _updateTrackingDuration() {
    if (!state.isTracking) return;

    final duration = DateTime.now().difference(state.sessionStartTime);
    state = state.copyWith(trackingDuration: duration);
  }

  // Quick actions for testing
  // (Removed simulateMovement: random simulation is not allowed)

  // Service status refresh
  Future<void> refreshServiceStatus() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final permission = await Geolocator.checkPermission();

      state = state.copyWith(
        isServiceEnabled: serviceEnabled,
        permissionStatus: _mapPermission(permission),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to refresh status: $e');
    }
  }
}
