/// Recording preset types
enum RecordingPreset {
  sleep, // 8 hours
  work, // 1 hour
  focus, // 30 minutes
  custom,
}

/// Acoustic event - represents a noise interruption
class AcousticEvent {
  final DateTime timestamp;
  final double peakDecibels;
  final Duration duration;
  final String eventType; // 'spike', 'sustained', 'intermittent'

  const AcousticEvent({
    required this.timestamp,
    required this.peakDecibels,
    required this.duration,
    required this.eventType,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'peakDecibels': peakDecibels,
    'duration': duration.inSeconds,
    'eventType': eventType,
  };

  factory AcousticEvent.fromJson(Map<String, dynamic> json) => AcousticEvent(
    timestamp: DateTime.parse(json['timestamp']),
    peakDecibels: json['peakDecibels'],
    duration: Duration(seconds: json['duration']),
    eventType: json['eventType'],
  );
}

/// Acoustic session report
class AcousticReport {
  final String id; // Unique identifier
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final RecordingPreset preset;
  final double averageDecibels;
  final double minDecibels;
  final double maxDecibels;
  final List<AcousticEvent> events;
  final Map<String, int> timeInLevels; // Time spent in each noise level
  final List<double> hourlyAverages;
  final String environmentQuality; // 'excellent', 'good', 'fair', 'poor'
  final String recommendation;

  AcousticReport({
    String? id,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.preset,
    required this.averageDecibels,
    required this.minDecibels,
    required this.maxDecibels,
    required this.events,
    required this.timeInLevels,
    required this.hourlyAverages,
    required this.environmentQuality,
    required this.recommendation,
  }) : id = id ?? '${startTime.millisecondsSinceEpoch}';

  /// Get formatted duration
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Get interruption count (events over threshold)
  int get interruptionCount => events.where((e) => e.peakDecibels > 65).length;

  /// Get quality score (0-100)
  int get qualityScore {
    int score = 100;

    // Penalize high average
    if (averageDecibels > 70) {
      score -= 40;
    } else if (averageDecibels > 60) {
      score -= 20;
    } else if (averageDecibels > 50) {
      score -= 10;
    }

    // Penalize interruptions
    score -= interruptionCount * 5;

    // Penalize max peaks
    if (maxDecibels > 85) {
      score -= 15;
    } else if (maxDecibels > 75) {
      score -= 10;
    }

    return score.clamp(0, 100);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'duration': duration.inSeconds,
    'preset': preset.name,
    'averageDecibels': averageDecibels,
    'minDecibels': minDecibels,
    'maxDecibels': maxDecibels,
    'events': events.map((e) => e.toJson()).toList(),
    'timeInLevels': timeInLevels,
    'hourlyAverages': hourlyAverages,
    'environmentQuality': environmentQuality,
    'recommendation': recommendation,
  };

  factory AcousticReport.fromJson(Map<String, dynamic> json) => AcousticReport(
    id: json['id'],
    startTime: DateTime.parse(json['startTime']),
    endTime: DateTime.parse(json['endTime']),
    duration: Duration(seconds: json['duration']),
    preset: RecordingPreset.values.firstWhere((e) => e.name == json['preset']),
    averageDecibels: json['averageDecibels'],
    minDecibels: json['minDecibels'],
    maxDecibels: json['maxDecibels'],
    events: (json['events'] as List)
        .map((e) => AcousticEvent.fromJson(e))
        .toList(),
    timeInLevels: Map<String, int>.from(json['timeInLevels']),
    hourlyAverages: List<double>.from(json['hourlyAverages']),
    environmentQuality: json['environmentQuality'],
    recommendation: json['recommendation'],
  );
}

/// Extended noise meter data with acoustic analysis
class EnhancedNoiseMeterData {
  final double currentDecibels;
  final double minDecibels;
  final double maxDecibels;
  final double averageDecibels;
  final bool isRecording;
  final NoiseLevel noiseLevel;
  final List<double> recentReadings;
  final String? errorMessage;
  final bool hasPermission;
  final int totalReadings;
  final Duration sessionDuration;
  final DateTime? sessionStartTime;

  // Acoustic analysis fields
  final RecordingPreset? activePreset;
  final List<AcousticEvent> events;
  final Map<String, int> timeInLevels;
  final List<double> allReadings; // Store all readings for report
  final List<AcousticReport> savedReports;
  final bool isAnalyzing;
  final List<double> decibelHistory; // For real-time chart (last 100 readings)
  final AcousticReport? lastGeneratedReport;

  const EnhancedNoiseMeterData({
    this.currentDecibels = 0.0,
    this.minDecibels = double.infinity,
    this.maxDecibels = double.negativeInfinity,
    this.averageDecibels = 0.0,
    this.isRecording = false,
    this.noiseLevel = NoiseLevel.quiet,
    this.recentReadings = const [],
    this.errorMessage,
    this.hasPermission = false,
    this.totalReadings = 0,
    this.sessionDuration = Duration.zero,
    this.sessionStartTime,
    this.activePreset,
    this.events = const [],
    this.timeInLevels = const {},
    this.allReadings = const [],
    this.savedReports = const [],
    this.isAnalyzing = false,
    this.decibelHistory = const [],
    this.lastGeneratedReport,
  });

  EnhancedNoiseMeterData copyWith({
    double? currentDecibels,
    double? minDecibels,
    double? maxDecibels,
    double? averageDecibels,
    bool? isRecording,
    NoiseLevel? noiseLevel,
    List<double>? recentReadings,
    String? errorMessage,
    bool? hasPermission,
    int? totalReadings,
    Duration? sessionDuration,
    DateTime? sessionStartTime,
    RecordingPreset? activePreset,
    List<AcousticEvent>? events,
    Map<String, int>? timeInLevels,
    List<double>? allReadings,
    List<AcousticReport>? savedReports,
    bool? isAnalyzing,
    List<double>? decibelHistory,
    AcousticReport? lastGeneratedReport,
  }) {
    return EnhancedNoiseMeterData(
      currentDecibels: currentDecibels ?? this.currentDecibels,
      minDecibels: minDecibels ?? this.minDecibels,
      maxDecibels: maxDecibels ?? this.maxDecibels,
      averageDecibels: averageDecibels ?? this.averageDecibels,
      isRecording: isRecording ?? this.isRecording,
      noiseLevel: noiseLevel ?? this.noiseLevel,
      recentReadings: recentReadings ?? this.recentReadings,
      errorMessage: errorMessage ?? this.errorMessage,
      hasPermission: hasPermission ?? this.hasPermission,
      totalReadings: totalReadings ?? this.totalReadings,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      activePreset: activePreset ?? this.activePreset,
      events: events ?? this.events,
      timeInLevels: timeInLevels ?? this.timeInLevels,
      allReadings: allReadings ?? this.allReadings,
      savedReports: savedReports ?? this.savedReports,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      decibelHistory: decibelHistory ?? this.decibelHistory,
      lastGeneratedReport: lastGeneratedReport ?? this.lastGeneratedReport,
    );
  }

  /// Get preset duration
  Duration getPresetDuration(RecordingPreset preset) {
    switch (preset) {
      case RecordingPreset.sleep:
        return const Duration(hours: 8);
      case RecordingPreset.work:
        return const Duration(hours: 1);
      case RecordingPreset.focus:
        return const Duration(minutes: 30);
      case RecordingPreset.custom:
        return Duration.zero;
    }
  }

  /// Get preset name
  String getPresetName(RecordingPreset preset) {
    switch (preset) {
      case RecordingPreset.sleep:
        return 'Analyze Sleep (8 hours)';
      case RecordingPreset.work:
        return 'Monitor Office Focus (1 hour)';
      case RecordingPreset.focus:
        return 'Quick Focus Check (30 min)';
      case RecordingPreset.custom:
        return 'Custom Duration';
    }
  }

  /// Get environment quality assessment
  String get environmentQuality {
    if (averageDecibels <= 35) return 'excellent';
    if (averageDecibels <= 50) return 'good';
    if (averageDecibels <= 65) return 'fair';
    return 'poor';
  }

  /// Get recommendation based on preset and data
  String getRecommendation() {
    if (activePreset == RecordingPreset.sleep) {
      if (averageDecibels <= 30) {
        return 'Perfect sleep environment! Noise levels are ideal for quality rest.';
      } else if (averageDecibels <= 40) {
        return 'Good sleep environment. Consider using earplugs for even better rest.';
      } else if (averageDecibels <= 50) {
        return 'Acceptable but not ideal. Try white noise machines or soundproofing.';
      } else {
        return 'Too noisy for quality sleep. Strong soundproofing recommended.';
      }
    } else if (activePreset == RecordingPreset.work ||
        activePreset == RecordingPreset.focus) {
      if (averageDecibels <= 45) {
        return 'Ideal for focus work! Environment supports productivity.';
      } else if (averageDecibels <= 55) {
        return 'Good for most work. Background music might help with concentration.';
      } else if (averageDecibels <= 65) {
        return 'Acceptable but distracting. Consider noise-cancelling headphones.';
      } else {
        return 'Too loud for focused work. Find a quieter space or use noise isolation.';
      }
    }
    return 'Monitor your environment to optimize for your specific needs.';
  }

  /// Generate acoustic report from current session
  AcousticReport generateReport() {
    // Calculate hourly averages
    final hourlyAvgs = <double>[];
    if (allReadings.isNotEmpty && sessionDuration.inHours > 0) {
      final readingsPerHour = allReadings.length / sessionDuration.inHours;
      for (int h = 0; h < sessionDuration.inHours; h++) {
        final start = (h * readingsPerHour).toInt();
        final end = ((h + 1) * readingsPerHour).toInt();
        if (end <= allReadings.length) {
          final hourReadings = allReadings.sublist(start, end);
          final avg =
              hourReadings.reduce((a, b) => a + b) / hourReadings.length;
          hourlyAvgs.add(avg);
        }
      }
    }

    return AcousticReport(
      startTime: sessionStartTime ?? DateTime.now(),
      endTime: DateTime.now(),
      duration: sessionDuration,
      preset: activePreset ?? RecordingPreset.custom,
      averageDecibels: averageDecibels,
      minDecibels: minDecibels,
      maxDecibels: maxDecibels,
      events: events,
      timeInLevels: timeInLevels,
      hourlyAverages: hourlyAvgs,
      environmentQuality: environmentQuality,
      recommendation: getRecommendation(),
    );
  }

  String get formattedCurrentDecibels =>
      '${currentDecibels.toStringAsFixed(1)} dB';
  String get formattedAverageDecibels =>
      '${averageDecibels.toStringAsFixed(1)} dB';
  String get formattedMinDecibels => minDecibels == double.infinity
      ? '--'
      : '${minDecibels.toStringAsFixed(1)} dB';
  String get formattedMaxDecibels => maxDecibels == double.negativeInfinity
      ? '--'
      : '${maxDecibels.toStringAsFixed(1)} dB';

  String get formattedDuration {
    final hours = sessionDuration.inHours;
    final minutes = sessionDuration.inMinutes.remainder(60);
    final seconds = sessionDuration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get remaining time for preset
  Duration? get remainingTime {
    if (activePreset == null || !isRecording) return null;
    final targetDuration = getPresetDuration(activePreset!);
    final remaining = targetDuration - sessionDuration;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Get progress (0.0 to 1.0)
  double get progress {
    if (activePreset == null || !isRecording) return 0.0;
    final targetDuration = getPresetDuration(activePreset!);
    if (targetDuration.inSeconds == 0) return 0.0;
    return (sessionDuration.inSeconds / targetDuration.inSeconds).clamp(
      0.0,
      1.0,
    );
  }

  String? get formattedRemainingTime {
    final remaining = remainingTime;
    if (remaining == null) return null;
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    if (hours > 0) {
      return '$hours h $minutes min remaining';
    }
    return '$minutes min remaining';
  }
}

/// Noise levels enum
enum NoiseLevel { quiet, moderate, loud, veryLoud, dangerous }
