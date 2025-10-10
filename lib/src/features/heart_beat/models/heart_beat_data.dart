enum HeartRateStatus {
  initializing,
  ready,
  measuring,
  fingerNotDetected,
  fingerMoved,
  holdStill,
  adjustPressure,
  error,
}

class HeartBeatData {
  final int bpm;
  final HeartRateStatus status;
  final String statusMessage;
  final bool isDetecting;
  final bool isFlashOn;
  final bool isInitialized;
  final bool fingerDetected;
  final bool showSoundWarning;
  final List<int> samples;
  final List<double> bpmHistory;
  final double baselineBrightness;
  final int stableReadings;
  final DateTime? warningStartTime;
  final double lastValidBpm;
  final DateTime lastValidReading;

  const HeartBeatData({
    this.bpm = 0,
    this.status = HeartRateStatus.initializing,
    this.statusMessage = 'Initializing...',
    this.isDetecting = false,
    this.isFlashOn = false,
    this.isInitialized = false,
    this.fingerDetected = false,
    this.showSoundWarning = true,
    this.samples = const [],
    this.bpmHistory = const [],
    this.baselineBrightness = 0,
    this.stableReadings = 0,
    this.warningStartTime,
    this.lastValidBpm = 0,
    required this.lastValidReading,
  });

  factory HeartBeatData.initial() {
    return HeartBeatData(lastValidReading: DateTime.now());
  }

  HeartBeatData copyWith({
    int? bpm,
    HeartRateStatus? status,
    String? statusMessage,
    bool? isDetecting,
    bool? isFlashOn,
    bool? isInitialized,
    bool? fingerDetected,
    bool? showSoundWarning,
    List<int>? samples,
    List<double>? bpmHistory,
    double? baselineBrightness,
    int? stableReadings,
    DateTime? warningStartTime,
    double? lastValidBpm,
    DateTime? lastValidReading,
  }) {
    return HeartBeatData(
      bpm: bpm ?? this.bpm,
      status: status ?? this.status,
      statusMessage: statusMessage ?? this.statusMessage,
      isDetecting: isDetecting ?? this.isDetecting,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      isInitialized: isInitialized ?? this.isInitialized,
      fingerDetected: fingerDetected ?? this.fingerDetected,
      showSoundWarning: showSoundWarning ?? this.showSoundWarning,
      samples: samples ?? this.samples,
      bpmHistory: bpmHistory ?? this.bpmHistory,
      baselineBrightness: baselineBrightness ?? this.baselineBrightness,
      stableReadings: stableReadings ?? this.stableReadings,
      warningStartTime: warningStartTime ?? this.warningStartTime,
      lastValidBpm: lastValidBpm ?? this.lastValidBpm,
      lastValidReading: lastValidReading ?? this.lastValidReading,
    );
  }

  /// Get formatted BPM with unit
  String get bpmWithUnit => '$bpm BPM';

  /// Check if measurement is in progress
  bool get isMeasuring => status == HeartRateStatus.measuring;

  /// Check if heart rate is in normal range
  bool get isNormalRate => bpm >= 60 && bpm <= 100;

  /// Get heart rate category
  String get rateCategory {
    if (bpm == 0) return 'No reading';
    if (bpm < 60) return 'Below normal';
    if (bpm <= 100) return 'Normal';
    return 'Above normal';
  }

  /// Get status color for UI
  HeartRateUIStatus get uiStatus {
    switch (status) {
      case HeartRateStatus.initializing:
        return HeartRateUIStatus.loading;
      case HeartRateStatus.ready:
        return HeartRateUIStatus.ready;
      case HeartRateStatus.measuring:
        return HeartRateUIStatus.measuring;
      case HeartRateStatus.fingerNotDetected:
      case HeartRateStatus.fingerMoved:
      case HeartRateStatus.adjustPressure:
        return HeartRateUIStatus.warning;
      case HeartRateStatus.holdStill:
        return HeartRateUIStatus.measuring;
      case HeartRateStatus.error:
        return HeartRateUIStatus.error;
    }
  }

  /// Check if samples are sufficient for measurement
  bool get hasSufficientSamples => samples.length >= 50;

  /// Get warning time remaining in seconds
  int get warningTimeRemaining {
    if (warningStartTime == null) return 0;
    final elapsed = DateTime.now().difference(warningStartTime!).inSeconds;
    return (5 - elapsed).clamp(0, 5);
  }

  /// Check if measurement is stable
  bool get isStableMeasurement => stableReadings > 3 && bpm > 0;
}

enum HeartRateUIStatus { loading, ready, measuring, warning, error }
