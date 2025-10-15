/// Camera settings suggestions based on lux values
class CameraSettingsData {
  final double lux;
  final int suggestedISO;
  final String suggestedShutterSpeed;
  final double suggestedAperture;
  final LightingCondition lightingCondition;
  final String recommendation;
  final List<CameraSetting> alternativeSettings;

  const CameraSettingsData({
    required this.lux,
    required this.suggestedISO,
    required this.suggestedShutterSpeed,
    required this.suggestedAperture,
    required this.lightingCondition,
    required this.recommendation,
    this.alternativeSettings = const [],
  });

  factory CameraSettingsData.fromLux(double lux) {
    final condition = _getLightingCondition(lux);
    final baseSettings = _getBaseSettings(lux);
    final alternatives = _getAlternativeSettings(lux);

    return CameraSettingsData(
      lux: lux,
      suggestedISO: baseSettings.iso,
      suggestedShutterSpeed: baseSettings.shutterSpeed,
      suggestedAperture: baseSettings.aperture,
      lightingCondition: condition,
      recommendation: _getRecommendation(condition, lux),
      alternativeSettings: alternatives,
    );
  }

  static LightingCondition _getLightingCondition(double lux) {
    if (lux < 10) return LightingCondition.darkNight;
    if (lux < 50) return LightingCondition.dimIndoor;
    if (lux < 400) return LightingCondition.indoor;
    if (lux < 1000) return LightingCondition.overcast;
    if (lux < 10000) return LightingCondition.brightIndoor;
    if (lux < 32000) return LightingCondition.shade;
    if (lux < 100000) return LightingCondition.fullDaylight;
    return LightingCondition.brightSunlight;
  }

  static CameraSetting _getBaseSettings(double lux) {
    // Baseline settings for f/2.8 and 1/100s equivalent
    // EV = log2(lux / 2.5)

    if (lux < 10) {
      // Very dark - Night/Interior
      return CameraSetting(
        iso: 6400,
        shutterSpeed: '1/30',
        aperture: 1.8,
        notes: 'Use tripod for stability',
      );
    } else if (lux < 50) {
      // Dim interior
      return CameraSetting(
        iso: 3200,
        shutterSpeed: '1/60',
        aperture: 2.0,
        notes: 'Consider using flash or stabilization',
      );
    } else if (lux < 400) {
      // Normal interior
      return CameraSetting(
        iso: 800,
        shutterSpeed: '1/100',
        aperture: 2.8,
        notes: 'Good for handheld shots',
      );
    } else if (lux < 1000) {
      // Bright interior / Overcast outdoor
      return CameraSetting(
        iso: 400,
        shutterSpeed: '1/125',
        aperture: 4.0,
        notes: 'Versatile settings',
      );
    } else if (lux < 10000) {
      // Very bright interior / Cloudy outdoor
      return CameraSetting(
        iso: 200,
        shutterSpeed: '1/250',
        aperture: 5.6,
        notes: 'Great for portraits',
      );
    } else if (lux < 32000) {
      // Shade outdoor
      return CameraSetting(
        iso: 100,
        shutterSpeed: '1/500',
        aperture: 8.0,
        notes: 'Ideal for landscapes',
      );
    } else if (lux < 100000) {
      // Full daylight
      return CameraSetting(
        iso: 100,
        shutterSpeed: '1/1000',
        aperture: 11,
        notes: 'Perfect outdoor conditions',
      );
    } else {
      // Bright sunlight
      return CameraSetting(
        iso: 100,
        shutterSpeed: '1/2000',
        aperture: 16,
        notes: 'Use ND filter if needed',
      );
    }
  }

  static List<CameraSetting> _getAlternativeSettings(double lux) {
    final base = _getBaseSettings(lux);
    final alternatives = <CameraSetting>[];

    // Provide 2-3 alternative combinations
    // Higher ISO, faster shutter (for action)
    alternatives.add(
      CameraSetting(
        iso: (base.iso * 2).clamp(100, 12800),
        shutterSpeed: _fasterShutter(base.shutterSpeed),
        aperture: base.aperture,
        notes: 'For freezing motion',
      ),
    );

    // Lower ISO, wider aperture (for shallow depth)
    if (base.aperture > 1.8) {
      alternatives.add(
        CameraSetting(
          iso: (base.iso / 2).clamp(100, 12800).toInt(),
          shutterSpeed: base.shutterSpeed,
          aperture: (base.aperture - 1.4).clamp(1.4, 22),
          notes: 'For shallow depth of field',
        ),
      );
    }

    // Balanced settings (for video)
    alternatives.add(
      CameraSetting(
        iso: base.iso,
        shutterSpeed: '1/50',
        aperture: (base.aperture + 1).clamp(1.4, 22),
        notes: 'For video (180° shutter rule)',
      ),
    );

    return alternatives;
  }

  static String _fasterShutter(String current) {
    final match = RegExp(r'1/(\d+)').firstMatch(current);
    if (match != null) {
      final speed = int.parse(match.group(1)!);
      return '1/${speed * 2}';
    }
    return current;
  }

  static String _getRecommendation(LightingCondition condition, double lux) {
    switch (condition) {
      case LightingCondition.darkNight:
        return 'Very low light. Use a tripod, increase ISO, or add artificial lighting. '
            'Consider long exposure for creative effects.';
      case LightingCondition.dimIndoor:
        return 'Low light conditions. Use image stabilization or increase ISO. '
            'A flash might be helpful for freeze motion.';
      case LightingCondition.indoor:
        return 'Typical indoor lighting. Balance ISO and shutter speed for sharp images. '
            'Window light can add nice natural fill.';
      case LightingCondition.overcast:
        return 'Overcast outdoor light. Great for even, soft lighting. '
            'No harsh shadows - perfect for portraits.';
      case LightingCondition.brightIndoor:
        return 'Bright indoor or cloudy outdoor. Good conditions for most photography. '
            'Consider slightly wider apertures for portraits.';
      case LightingCondition.shade:
        return 'Open shade - excellent lighting! Soft and flattering for portraits. '
            'Watch white balance for color accuracy.';
      case LightingCondition.fullDaylight:
        return 'Full daylight - optimal lighting conditions. '
            'Watch for harsh shadows. Golden hour approaching!';
      case LightingCondition.brightSunlight:
        return 'Intense sunlight. Use fast shutter speeds and consider ND filters. '
            'Harsh shadows - find shade for portraits.';
    }
  }

  String get evValue {
    // Calculate Exposure Value: EV = log2(lux / 2.5)
    if (lux <= 0) return 'N/A';
    final ev = (log2(lux / 2.5));
    return ev.toStringAsFixed(1);
  }

  static double log2(double x) {
    return log(x) / log(2);
  }

  static double log(double x) {
    // Simple natural log approximation
    return x
        .toString()
        .length
        .toDouble(); // Placeholder - use dart:math in real implementation
  }
}

/// Individual camera setting combination
class CameraSetting {
  final int iso;
  final String shutterSpeed;
  final double aperture;
  final String notes;

  const CameraSetting({
    required this.iso,
    required this.shutterSpeed,
    required this.aperture,
    required this.notes,
  });

  String get fStop => 'f/${aperture.toStringAsFixed(1)}';
}

/// Lighting condition categories
enum LightingCondition {
  darkNight, // < 10 lux
  dimIndoor, // 10-50 lux
  indoor, // 50-400 lux
  overcast, // 400-1000 lux
  brightIndoor, // 1000-10000 lux
  shade, // 10000-32000 lux
  fullDaylight, // 32000-100000 lux
  brightSunlight, // > 100000 lux
}

extension LightingConditionExtension on LightingCondition {
  String get name {
    switch (this) {
      case LightingCondition.darkNight:
        return 'Dark Night';
      case LightingCondition.dimIndoor:
        return 'Dim Indoor';
      case LightingCondition.indoor:
        return 'Indoor';
      case LightingCondition.overcast:
        return 'Overcast Outdoor';
      case LightingCondition.brightIndoor:
        return 'Bright Indoor';
      case LightingCondition.shade:
        return 'Open Shade';
      case LightingCondition.fullDaylight:
        return 'Full Daylight';
      case LightingCondition.brightSunlight:
        return 'Bright Sunlight';
    }
  }

  String get icon {
    switch (this) {
      case LightingCondition.darkNight:
        return '🌙';
      case LightingCondition.dimIndoor:
        return '💡';
      case LightingCondition.indoor:
        return '🏠';
      case LightingCondition.overcast:
        return '☁️';
      case LightingCondition.brightIndoor:
        return '✨';
      case LightingCondition.shade:
        return '🌳';
      case LightingCondition.fullDaylight:
        return '🌤️';
      case LightingCondition.brightSunlight:
        return '☀️';
    }
  }

  String get luxRange {
    switch (this) {
      case LightingCondition.darkNight:
        return '< 10 lux';
      case LightingCondition.dimIndoor:
        return '10-50 lux';
      case LightingCondition.indoor:
        return '50-400 lux';
      case LightingCondition.overcast:
        return '400-1,000 lux';
      case LightingCondition.brightIndoor:
        return '1,000-10,000 lux';
      case LightingCondition.shade:
        return '10,000-32,000 lux';
      case LightingCondition.fullDaylight:
        return '32,000-100,000 lux';
      case LightingCondition.brightSunlight:
        return '> 100,000 lux';
    }
  }
}
