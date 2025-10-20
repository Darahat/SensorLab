import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/noise_meter/application/notifiers/enhanced_noise_meter_notifier.dart';
import 'package:sensorlab/src/features/noise_meter/application/services/acoustic_report_service.dart';
import 'package:sensorlab/src/features/noise_meter/application/state/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/data/providers/acoustic_repository_provider.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart'
    as entities;

/// Provider for the enhanced noise meter notifier
final enhancedNoiseMeterProvider =
    StateNotifierProvider<EnhancedNoiseMeterNotifier, EnhancedNoiseMeterData>((
      ref,
    ) {
      final repository = ref.watch(acousticRepositoryProvider);
      return EnhancedNoiseMeterNotifier(repository);
    });

/// Aggregated statistics for reports (lightweight provider)
final reportStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'total': AcousticReportService.reportCount,
    'averageQuality': AcousticReportService.averageQualityScore.toInt(),
    'sleepStats': AcousticReportService.getPresetStatistics(
      entities.RecordingPreset.sleep,
    ),
    'workStats': AcousticReportService.getPresetStatistics(
      entities.RecordingPreset.work,
    ),
    'focusStats': AcousticReportService.getPresetStatistics(
      entities.RecordingPreset.focus,
    ),
  };
});
