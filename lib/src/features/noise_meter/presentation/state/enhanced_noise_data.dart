import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';

part 'enhanced_noise_data.freezed.dart';

/// Noise levels enum
enum NoiseLevel { quiet, moderate, loud, veryLoud, dangerous }

/// State class for the EnhancedNoiseMeterNotifier.
/// This is a pure, immutable state object using freezed.
@freezed
class EnhancedNoiseMeterData with _$EnhancedNoiseMeterData {
  const factory EnhancedNoiseMeterData({
    @Default(0.0) double currentDecibels,
    @Default(double.infinity) double minDecibels,
    @Default(double.negativeInfinity) double maxDecibels,
    @Default(0.0) double averageDecibels,
    @Default(false) bool isRecording,
    @Default(NoiseLevel.quiet) NoiseLevel noiseLevel,
    @Default([]) List<double> recentReadings,
    String? errorMessage,
    @Default(false) bool hasPermission,
    @Default(0) int totalReadings,
    @Default(Duration.zero) Duration sessionDuration,
    DateTime? sessionStartTime,
    RecordingPreset? activePreset,
    Duration? customPresetDuration, // For custom presets
    @Default([]) List<AcousticEvent> events,
    @Default({}) Map<String, int> timeInLevels,
    @Default([]) List<double> allReadings, // Store all readings for report
    @Default([]) List<AcousticReport> savedReports,
    @Default(false) bool isAnalyzing,
    @Default([]) List<double> decibelHistory, // For real-time chart
    AcousticReport? lastGeneratedReport,
  }) = _EnhancedNoiseMeterData;
}
