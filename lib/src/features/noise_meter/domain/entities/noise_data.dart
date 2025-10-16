import 'package:flutter/foundation.dart';

/// A pure, domain-specific entity representing a single noise reading.
///
/// This class is independent of any external packages and represents the core
/// business object for a noise measurement in our app.
@immutable
class NoiseData {
  const NoiseData({required this.meanDecibel});

  final double meanDecibel;
}
