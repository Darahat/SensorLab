# 📍 Geolocator Module Documentation

## Overview

The geolocator module provides precise GPS location services including position tracking, distance calculations, and geofencing capabilities for location-aware applications.

## Features

- Real-time GPS positioning
- Distance and speed calculations
- Location accuracy indicators
- Background location tracking
- Geofencing support

## Integration

```yaml
dependencies:
  geolocator: ^10.1.0
  geocoding: ^2.1.1
```

```dart
// Entity
class LocationData {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy;
  final double? speed;
  final DateTime timestamp;

  double distanceTo(LocationData other) {
    return Geolocator.distanceBetween(
      latitude, longitude,
      other.latitude, other.longitude,
    );
  }
}

// Provider
final locationProvider = StreamProvider<LocationData>((ref) {
  return Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
  ).map((position) => LocationData(
    latitude: position.latitude,
    longitude: position.longitude,
    altitude: position.altitude,
    accuracy: position.accuracy,
    speed: position.speed,
    timestamp: position.timestamp ?? DateTime.now(),
  ));
});
```

## Permissions

```xml
<!-- Android -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

## Use Cases

- Navigation applications
- Fitness tracking
- Asset tracking
- Emergency services
- Location-based reminders

