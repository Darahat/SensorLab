import 'package:geolocator/geolocator.dart';

enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  whileInUse,
  always,
  unableToDetermine;

  String get displayName {
    switch (this) {
      case LocationPermissionStatus.granted:
        return 'Granted';
      case LocationPermissionStatus.denied:
        return 'Denied';
      case LocationPermissionStatus.deniedForever:
        return 'Denied Forever';
      case LocationPermissionStatus.whileInUse:
        return 'While In Use';
      case LocationPermissionStatus.always:
        return 'Always';
      case LocationPermissionStatus.unableToDetermine:
        return 'Unable to Determine';
    }
  }

  String get icon {
    switch (this) {
      case LocationPermissionStatus.granted:
      case LocationPermissionStatus.whileInUse:
      case LocationPermissionStatus.always:
        return '✅';
      case LocationPermissionStatus.denied:
      case LocationPermissionStatus.deniedForever:
        return '❌';
      case LocationPermissionStatus.unableToDetermine:
        return '❓';
    }
  }

  int get statusColor {
    switch (this) {
      case LocationPermissionStatus.granted:
      case LocationPermissionStatus.whileInUse:
      case LocationPermissionStatus.always:
        return 0xFF4CAF50; // Green
      case LocationPermissionStatus.denied:
      case LocationPermissionStatus.deniedForever:
        return 0xFFF44336; // Red
      case LocationPermissionStatus.unableToDetermine:
        return 0xFFFF9800; // Orange
    }
  }

  bool get isGranted =>
      this == LocationPermissionStatus.granted ||
      this == LocationPermissionStatus.whileInUse ||
      this == LocationPermissionStatus.always;
}

class LocationData {
  final double latitude;
  final double longitude;
  final double altitude;
  final double accuracy;
  final double speed;
  final double speedAccuracy;
  final double heading;
  final DateTime timestamp;

  const LocationData({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.accuracy,
    required this.speed,
    required this.speedAccuracy,
    required this.heading,
    required this.timestamp,
  });

  factory LocationData.fromPosition(Position position) {
    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      accuracy: position.accuracy,
      speed: position.speed,
      speedAccuracy: position.speedAccuracy,
      heading: position.heading,
      timestamp: position.timestamp,
    );
  }

  LocationData copyWith({
    double? latitude,
    double? longitude,
    double? altitude,
    double? accuracy,
    double? speed,
    double? speedAccuracy,
    double? heading,
    DateTime? timestamp,
  }) {
    return LocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      accuracy: accuracy ?? this.accuracy,
      speed: speed ?? this.speed,
      speedAccuracy: speedAccuracy ?? this.speedAccuracy,
      heading: heading ?? this.heading,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Formatted getters
  String get formattedLatitude => '${latitude.toStringAsFixed(6)}°';
  String get formattedLongitude => '${longitude.toStringAsFixed(6)}°';
  String get formattedAltitude => '${altitude.toStringAsFixed(1)} m';
  String get formattedAccuracy => '${accuracy.toStringAsFixed(1)} m';
  String get formattedSpeed =>
      '${(speed * 3.6).toStringAsFixed(1)} km/h'; // Convert m/s to km/h
  String get formattedHeading => '${heading.toStringAsFixed(1)}°';

  String get formattedCoordinates => '$formattedLatitude, $formattedLongitude';

  String get formattedTimestamp {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  // Cardinal direction from heading
  String get cardinalDirection {
    if (heading >= 337.5 || heading < 22.5) return 'N';
    if (heading >= 22.5 && heading < 67.5) return 'NE';
    if (heading >= 67.5 && heading < 112.5) return 'E';
    if (heading >= 112.5 && heading < 157.5) return 'SE';
    if (heading >= 157.5 && heading < 202.5) return 'S';
    if (heading >= 202.5 && heading < 247.5) return 'SW';
    if (heading >= 247.5 && heading < 292.5) return 'W';
    if (heading >= 292.5 && heading < 337.5) return 'NW';
    return 'Unknown';
  }

  // Accuracy level description
  String get accuracyDescription {
    if (accuracy < 5) return 'Excellent';
    if (accuracy < 10) return 'Good';
    if (accuracy < 20) return 'Fair';
    if (accuracy < 50) return 'Poor';
    return 'Very Poor';
  }

  int get accuracyColor {
    if (accuracy < 5) return 0xFF4CAF50; // Green
    if (accuracy < 10) return 0xFF8BC34A; // Light Green
    if (accuracy < 20) return 0xFFFF9800; // Orange
    if (accuracy < 50) return 0xFFFF5722; // Deep Orange
    return 0xFFF44336; // Red
  }

  // Speed category
  String get speedCategory {
    final kmh = speed * 3.6;
    if (kmh < 1) return 'Stationary';
    if (kmh < 5) return 'Walking';
    if (kmh < 15) return 'Jogging';
    if (kmh < 30) return 'Cycling';
    if (kmh < 50) return 'Driving (City)';
    if (kmh < 80) return 'Driving (Highway)';
    return 'High Speed';
  }

  // Google Maps URL
  String get googleMapsUrl =>
      'https://www.google.com/maps?q=$latitude,$longitude';

  // What3Words-style coordinates (simplified)
  String get gridReference {
    final latGrid = (latitude * 1000).toInt();
    final lngGrid = (longitude * 1000).toInt();
    return 'Grid: $latGrid.$lngGrid';
  }
}

class AddressData {
  final String fullAddress;
  final String country;
  final String locality;
  final String subLocality;
  final String street;
  final String postalCode;
  final DateTime timestamp;

  const AddressData({
    required this.fullAddress,
    required this.country,
    required this.locality,
    required this.subLocality,
    required this.street,
    required this.postalCode,
    required this.timestamp,
  });

  AddressData copyWith({
    String? fullAddress,
    String? country,
    String? locality,
    String? subLocality,
    String? street,
    String? postalCode,
    DateTime? timestamp,
  }) {
    return AddressData(
      fullAddress: fullAddress ?? this.fullAddress,
      country: country ?? this.country,
      locality: locality ?? this.locality,
      subLocality: subLocality ?? this.subLocality,
      street: street ?? this.street,
      postalCode: postalCode ?? this.postalCode,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  String get formattedTimestamp {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  String get shortAddress {
    final parts = <String>[];
    if (street.isNotEmpty) parts.add(street);
    if (locality.isNotEmpty) parts.add(locality);
    if (country.isNotEmpty) parts.add(country);
    return parts.take(2).join(', ');
  }
}

class GeolocatorData {
  final LocationData? currentLocation;
  final AddressData? currentAddress;
  final List<LocationData> locationHistory;
  final LocationPermissionStatus permissionStatus;
  final bool isServiceEnabled;
  final bool isTracking;
  final bool isInitialized;
  final bool isLoadingLocation;
  final bool isLoadingAddress;

  // Statistics
  final double totalDistance; // in meters
  final double maxSpeed; // in m/s
  final double averageSpeed; // in m/s
  final Duration trackingDuration;
  final DateTime sessionStartTime;
  final int locationUpdates;

  // Settings
  final LocationAccuracy desiredAccuracy;
  final int distanceFilter; // minimum distance in meters
  final Duration timeInterval;

  // Error handling
  final String? errorMessage;

  GeolocatorData({
    this.currentLocation,
    this.currentAddress,
    this.locationHistory = const [],
    this.permissionStatus = LocationPermissionStatus.unableToDetermine,
    this.isServiceEnabled = false,
    this.isTracking = false,
    this.isInitialized = false,
    this.isLoadingLocation = false,
    this.isLoadingAddress = false,
    this.totalDistance = 0.0,
    this.maxSpeed = 0.0,
    this.averageSpeed = 0.0,
    this.trackingDuration = Duration.zero,
    DateTime? sessionStartTime,
    this.locationUpdates = 0,
    this.desiredAccuracy = LocationAccuracy.high,
    this.distanceFilter = 10,
    this.timeInterval = const Duration(seconds: 5),
    this.errorMessage,
  }) : sessionStartTime = sessionStartTime ?? DateTime.now();

  GeolocatorData copyWith({
    LocationData? currentLocation,
    AddressData? currentAddress,
    List<LocationData>? locationHistory,
    LocationPermissionStatus? permissionStatus,
    bool? isServiceEnabled,
    bool? isTracking,
    bool? isInitialized,
    bool? isLoadingLocation,
    bool? isLoadingAddress,
    double? totalDistance,
    double? maxSpeed,
    double? averageSpeed,
    Duration? trackingDuration,
    DateTime? sessionStartTime,
    int? locationUpdates,
    LocationAccuracy? desiredAccuracy,
    int? distanceFilter,
    Duration? timeInterval,
    String? errorMessage,
  }) {
    return GeolocatorData(
      currentLocation: currentLocation ?? this.currentLocation,
      currentAddress: currentAddress ?? this.currentAddress,
      locationHistory: locationHistory ?? this.locationHistory,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      isServiceEnabled: isServiceEnabled ?? this.isServiceEnabled,
      isTracking: isTracking ?? this.isTracking,
      isInitialized: isInitialized ?? this.isInitialized,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      isLoadingAddress: isLoadingAddress ?? this.isLoadingAddress,
      totalDistance: totalDistance ?? this.totalDistance,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      trackingDuration: trackingDuration ?? this.trackingDuration,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      locationUpdates: locationUpdates ?? this.locationUpdates,
      desiredAccuracy: desiredAccuracy ?? this.desiredAccuracy,
      distanceFilter: distanceFilter ?? this.distanceFilter,
      timeInterval: timeInterval ?? this.timeInterval,
      errorMessage: errorMessage,
    );
  }

  // Status indicators
  String get statusIcon {
    if (!isInitialized) return '⏳';
    if (!isServiceEnabled) return '📍';
    if (!permissionStatus.isGranted) return '🔒';
    if (isTracking) return '🎯';
    if (currentLocation != null) return '📍';
    return '❓';
  }

  String get statusDescription {
    if (!isInitialized) return 'Initializing...';
    if (!isServiceEnabled) return 'Location Service Disabled';
    if (!permissionStatus.isGranted)
      return 'Permission ${permissionStatus.displayName}';
    if (isTracking) return 'Tracking Location';
    if (currentLocation != null) return 'Location Available';
    return 'No Location Data';
  }

  int get statusColor {
    if (!isInitialized || isLoadingLocation) return 0xFF2196F3; // Blue
    if (!isServiceEnabled || !permissionStatus.isGranted)
      return 0xFFF44336; // Red
    if (isTracking) return 0xFF4CAF50; // Green
    if (currentLocation != null) return 0xFF8BC34A; // Light Green
    return 0xFFFF9800; // Orange
  }

  // Formatted getters
  String get formattedTotalDistance {
    if (totalDistance < 1000) {
      return '${totalDistance.toStringAsFixed(0)} m';
    } else {
      return '${(totalDistance / 1000).toStringAsFixed(2)} km';
    }
  }

  String get formattedMaxSpeed => '${(maxSpeed * 3.6).toStringAsFixed(1)} km/h';
  String get formattedAverageSpeed =>
      '${(averageSpeed * 3.6).toStringAsFixed(1)} km/h';
  String get formattedLocationUpdates => '$locationUpdates updates';

  String get formattedTrackingDuration {
    final hours = trackingDuration.inHours;
    final minutes = trackingDuration.inMinutes % 60;
    final seconds = trackingDuration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  String get formattedAccuracy => desiredAccuracy.name.toUpperCase();

  // Capabilities
  bool get canGetLocation =>
      isInitialized && isServiceEnabled && permissionStatus.isGranted;
  bool get canTrackLocation => canGetLocation && !isTracking;
  bool get canOpenMaps => currentLocation != null;
  bool get hasLocationHistory => locationHistory.isNotEmpty;

  // Quick actions
  String get googleMapsUrl => currentLocation?.googleMapsUrl ?? '';
  String get currentCoordinates =>
      currentLocation?.formattedCoordinates ?? 'No location';
  String get currentAccuracy => currentLocation?.formattedAccuracy ?? '--';
  String get currentSpeed => currentLocation?.formattedSpeed ?? '0.0 km/h';

  // Statistics summary
  String get sessionSummary {
    if (!hasLocationHistory) return 'No tracking data';
    return '$formattedLocationUpdates • $formattedTotalDistance • $formattedTrackingDuration';
  }

  String get accuracySummary =>
      currentLocation?.accuracyDescription ?? 'Unknown';
  int get accuracyColor => currentLocation?.accuracyColor ?? 0xFFBDBDBD;
}
