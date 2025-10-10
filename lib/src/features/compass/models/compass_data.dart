class CompassData {
  final double? heading;
  final String currentDirection;
  final bool isCalibrating;
  final bool hasError;
  final bool isActive;

  static const List<String> directions = [
    'N',
    'NE',
    'E',
    'SE',
    'S',
    'SW',
    'W',
    'NW',
  ];

  const CompassData({
    this.heading,
    this.currentDirection = 'N',
    this.isCalibrating = false,
    this.hasError = false,
    this.isActive = false,
  });

  CompassData copyWith({
    double? heading,
    String? currentDirection,
    bool? isCalibrating,
    bool? hasError,
    bool? isActive,
  }) {
    return CompassData(
      heading: heading ?? this.heading,
      currentDirection: currentDirection ?? this.currentDirection,
      isCalibrating: isCalibrating ?? this.isCalibrating,
      hasError: hasError ?? this.hasError,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Calculate direction from heading
  static String calculateDirection(double? heading) {
    if (heading == null) return 'N';
    final index = ((heading + 22.5) % 360) ~/ 45;
    return directions[index];
  }

  /// Get heading in degrees as formatted string
  String get headingDisplay => heading?.toStringAsFixed(1) ?? '--';

  /// Get heading with degree symbol
  String get headingWithUnit => '${headingDisplay}°';

  /// Check if compass has valid reading
  bool get hasValidReading => heading != null && !hasError;
}
