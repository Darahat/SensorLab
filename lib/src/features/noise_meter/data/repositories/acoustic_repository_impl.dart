import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/acoustic_report_entity.dart';
import '../../domain/repositories/acoustic_repository.dart';
import '../../services/acoustic_report_service.dart';
import 'package:sensorlab/src/features/noise_meter/data/models/acoustic_report_hive.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/noise_data.dart';

// Provider for the new repository
final acousticRepositoryProvider = Provider<AcousticRepository>((ref) {
  return AcousticRepositoryImpl();
});

class AcousticRepositoryImpl implements AcousticRepository {
  NoiseMeter? _noiseMeter;

  @override
  Stream<NoiseData> get noiseStream {
    _noiseMeter ??= NoiseMeter();
    return _noiseMeter!.noise.map((noiseReading) {
      return NoiseData(meanDecibel: noiseReading.meanDecibel);
    });
  }

  @override
  Future<bool> checkPermission() async {
    return await Permission.microphone.isGranted;
  }

  @override
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  // --- Acoustic Report Persistence ---

  @override
  Future<void> saveReport(AcousticReport report) {
    // 1. Convert Entity to DTO
    final reportHive = AcousticReportHive.fromEntity(report);
    // 2. Save the DTO
    return AcousticReportService.saveReport(reportHive);
  }

  @override
  Future<List<AcousticReport>> getReports() async {
    // 1. Get DTOs from the service
    final reportHiveList = AcousticReportService.getReportsSorted();
    // 2. Map DTOs to Entities and return
    return reportHiveList.map((hiveDto) => hiveDto.toEntity()).toList();
  }

  @override
  Future<void> deleteReport(String reportId) {
    return AcousticReportService.deleteReport(reportId);
  }

  @override
  Future<void> deleteAllReports() {
    return AcousticReportService.deleteAllReports();
  }
}