/// Plant light requirements and daily light tracking
class PlantLightData {
  final PlantType plantType;
  final String plantName;
  final LightRequirement lightRequirement;
  final double targetDLI; // Daily Light Integral in mol/m²/day
  final double currentDLI;
  final DateTime trackingStartTime;
  final List<LightReading> readings;

  const PlantLightData({
    required this.plantType,
    required this.plantName,
    required this.lightRequirement,
    required this.targetDLI,
    this.currentDLI = 0.0,
    required this.trackingStartTime,
    this.readings = const [],
  });

  PlantLightData copyWith({
    PlantType? plantType,
    String? plantName,
    LightRequirement? lightRequirement,
    double? targetDLI,
    double? currentDLI,
    DateTime? trackingStartTime,
    List<LightReading>? readings,
  }) {
    return PlantLightData(
      plantType: plantType ?? this.plantType,
      plantName: plantName ?? this.plantName,
      lightRequirement: lightRequirement ?? this.lightRequirement,
      targetDLI: targetDLI ?? this.targetDLI,
      currentDLI: currentDLI ?? this.currentDLI,
      trackingStartTime: trackingStartTime ?? this.trackingStartTime,
      readings: readings ?? this.readings,
    );
  }

  /// Get progress percentage (0-100)
  double get progressPercentage {
    if (targetDLI == 0) return 0;
    return (currentDLI / targetDLI * 100).clamp(0, 100);
  }

  /// Get status of light exposure
  String get status {
    final percentage = progressPercentage;
    if (percentage < 50) return 'Too Dark';
    if (percentage < 80) return 'Needs More Light';
    if (percentage <= 120) return 'Perfect Light';
    return 'Too Much Light';
  }

  /// Get recommendation
  String get recommendation {
    final percentage = progressPercentage;
    if (percentage < 50) {
      return 'Move your ${plantName.toLowerCase()} closer to a window or add artificial lighting.';
    } else if (percentage < 80) {
      return 'Your ${plantName.toLowerCase()} needs a bit more light. Consider moving it to a brighter spot.';
    } else if (percentage <= 120) {
      return 'Perfect! Your ${plantName.toLowerCase()} is getting ideal light conditions.';
    } else {
      return 'Too much light! Move your ${plantName.toLowerCase()} away from direct sunlight.';
    }
  }

  /// Calculate remaining hours needed at current lux level
  Duration getRemainingTimeAtCurrentLux(double currentLux) {
    if (currentLux == 0 || progressPercentage >= 100) return Duration.zero;

    final remainingDLI = targetDLI - currentDLI;
    if (remainingDLI <= 0) return Duration.zero;

    // Convert lux to μmol/m²/s (approximate conversion for sunlight)
    // 1 μmol/m²/s ≈ 54 lux
    final ppfd = currentLux / 54.0;

    // Calculate hours needed: DLI (mol/m²/day) = PPFD (μmol/m²/s) × 3600 (s/h) × hours / 1,000,000
    final hoursNeeded = (remainingDLI * 1000000) / (ppfd * 3600);

    return Duration(minutes: (hoursNeeded * 60).toInt());
  }
}

/// Individual light reading for DLI calculation
class LightReading {
  final DateTime timestamp;
  final double lux;
  final double ppfd; // Photosynthetic Photon Flux Density (μmol/m²/s)

  const LightReading({
    required this.timestamp,
    required this.lux,
    required this.ppfd,
  });

  factory LightReading.fromLux(double lux, DateTime timestamp) {
    // Convert lux to PPFD (approximate for sunlight)
    // 1 μmol/m²/s ≈ 54 lux
    final ppfd = lux / 54.0;
    return LightReading(timestamp: timestamp, lux: lux, ppfd: ppfd);
  }
}

/// Plant types with their characteristics
enum PlantType {
  succulent,
  cactus,
  snake,
  pothos,
  fern,
  orchid,
  spider,
  monstera,
  fiddle,
  peace,
  rubber,
  croton,
  basil,
  tomato,
  lettuce,
  custom,
}

/// Light requirement categories
enum LightRequirement {
  low, // 2-6 mol/m²/day
  medium, // 6-12 mol/m²/day
  high, // 12-18 mol/m²/day
  veryHigh, // 18+ mol/m²/day
}

/// Plant information database
class PlantDatabase {
  static const Map<PlantType, PlantInfo> plants = {
    PlantType.succulent: PlantInfo(
      name: 'Succulent',
      scientificName: 'Various',
      lightRequirement: LightRequirement.high,
      targetDLI: 12.0,
      minDLI: 8.0,
      maxDLI: 18.0,
      description: 'Succulents thrive in bright, indirect light',
      icon: '🌵',
    ),
    PlantType.cactus: PlantInfo(
      name: 'Cactus',
      scientificName: 'Various Cacti',
      lightRequirement: LightRequirement.veryHigh,
      targetDLI: 15.0,
      minDLI: 12.0,
      maxDLI: 20.0,
      description: 'Cacti need intense, direct sunlight',
      icon: '🌵',
    ),
    PlantType.snake: PlantInfo(
      name: 'Snake Plant',
      scientificName: 'Sansevieria',
      lightRequirement: LightRequirement.low,
      targetDLI: 4.0,
      minDLI: 2.0,
      maxDLI: 12.0,
      description: 'Very low light tolerant, perfect for beginners',
      icon: '🪴',
    ),
    PlantType.pothos: PlantInfo(
      name: 'Pothos',
      scientificName: 'Epipremnum aureum',
      lightRequirement: LightRequirement.low,
      targetDLI: 5.0,
      minDLI: 3.0,
      maxDLI: 10.0,
      description: 'Tolerates low to medium light conditions',
      icon: '🌿',
    ),
    PlantType.fern: PlantInfo(
      name: 'Fern',
      scientificName: 'Various',
      lightRequirement: LightRequirement.medium,
      targetDLI: 8.0,
      minDLI: 4.0,
      maxDLI: 12.0,
      description: 'Prefers indirect, filtered light',
      icon: '🌿',
    ),
    PlantType.orchid: PlantInfo(
      name: 'Orchid',
      scientificName: 'Phalaenopsis',
      lightRequirement: LightRequirement.medium,
      targetDLI: 10.0,
      minDLI: 6.0,
      maxDLI: 14.0,
      description: 'Needs bright, indirect light',
      icon: '🌸',
    ),
    PlantType.spider: PlantInfo(
      name: 'Spider Plant',
      scientificName: 'Chlorophytum comosum',
      lightRequirement: LightRequirement.medium,
      targetDLI: 8.0,
      minDLI: 4.0,
      maxDLI: 12.0,
      description: 'Adaptable to various light conditions',
      icon: '🕷️',
    ),
    PlantType.monstera: PlantInfo(
      name: 'Monstera',
      scientificName: 'Monstera deliciosa',
      lightRequirement: LightRequirement.medium,
      targetDLI: 9.0,
      minDLI: 5.0,
      maxDLI: 13.0,
      description: 'Bright, indirect light preferred',
      icon: '🌿',
    ),
    PlantType.fiddle: PlantInfo(
      name: 'Fiddle Leaf Fig',
      scientificName: 'Ficus lyrata',
      lightRequirement: LightRequirement.high,
      targetDLI: 12.0,
      minDLI: 8.0,
      maxDLI: 16.0,
      description: 'Requires bright, consistent light',
      icon: '🌳',
    ),
    PlantType.peace: PlantInfo(
      name: 'Peace Lily',
      scientificName: 'Spathiphyllum',
      lightRequirement: LightRequirement.low,
      targetDLI: 4.0,
      minDLI: 2.0,
      maxDLI: 8.0,
      description: 'Low light champion',
      icon: '🕊️',
    ),
    PlantType.rubber: PlantInfo(
      name: 'Rubber Plant',
      scientificName: 'Ficus elastica',
      lightRequirement: LightRequirement.medium,
      targetDLI: 10.0,
      minDLI: 6.0,
      maxDLI: 14.0,
      description: 'Bright, indirect light is best',
      icon: '🌱',
    ),
    PlantType.croton: PlantInfo(
      name: 'Croton',
      scientificName: 'Codiaeum variegatum',
      lightRequirement: LightRequirement.high,
      targetDLI: 14.0,
      minDLI: 10.0,
      maxDLI: 18.0,
      description: 'Needs bright light for colorful leaves',
      icon: '🍂',
    ),
    PlantType.basil: PlantInfo(
      name: 'Basil',
      scientificName: 'Ocimum basilicum',
      lightRequirement: LightRequirement.high,
      targetDLI: 14.0,
      minDLI: 10.0,
      maxDLI: 20.0,
      description: 'Herb that loves direct sunlight',
      icon: '🌿',
    ),
    PlantType.tomato: PlantInfo(
      name: 'Tomato',
      scientificName: 'Solanum lycopersicum',
      lightRequirement: LightRequirement.veryHigh,
      targetDLI: 18.0,
      minDLI: 14.0,
      maxDLI: 25.0,
      description: 'Vegetable requiring full sun',
      icon: '🍅',
    ),
    PlantType.lettuce: PlantInfo(
      name: 'Lettuce',
      scientificName: 'Lactuca sativa',
      lightRequirement: LightRequirement.medium,
      targetDLI: 12.0,
      minDLI: 8.0,
      maxDLI: 16.0,
      description: 'Leafy green for moderate light',
      icon: '🥬',
    ),
    PlantType.custom: PlantInfo(
      name: 'Custom Plant',
      scientificName: 'User Defined',
      lightRequirement: LightRequirement.medium,
      targetDLI: 10.0,
      minDLI: 5.0,
      maxDLI: 15.0,
      description: 'Set your own light requirements',
      icon: '🪴',
    ),
  };

  static PlantInfo getPlantInfo(PlantType type) {
    return plants[type]!;
  }

  static List<PlantInfo> getAllPlants() {
    return plants.values.toList();
  }

  static List<PlantInfo> getPlantsByRequirement(LightRequirement requirement) {
    return plants.values
        .where((p) => p.lightRequirement == requirement)
        .toList();
  }
}

/// Plant information class
class PlantInfo {
  final String name;
  final String scientificName;
  final LightRequirement lightRequirement;
  final double targetDLI;
  final double minDLI;
  final double maxDLI;
  final String description;
  final String icon;

  const PlantInfo({
    required this.name,
    required this.scientificName,
    required this.lightRequirement,
    required this.targetDLI,
    required this.minDLI,
    required this.maxDLI,
    required this.description,
    required this.icon,
  });

  String get requirementText {
    switch (lightRequirement) {
      case LightRequirement.low:
        return 'Low Light (2-6 mol/m²/day)';
      case LightRequirement.medium:
        return 'Medium Light (6-12 mol/m²/day)';
      case LightRequirement.high:
        return 'High Light (12-18 mol/m²/day)';
      case LightRequirement.veryHigh:
        return 'Very High Light (18+ mol/m²/day)';
    }
  }
}
