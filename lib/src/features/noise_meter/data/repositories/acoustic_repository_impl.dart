import 'dart:async';

import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/noise_meter/data/models/acoustic_report_hive.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/noise_data.dart';

import '../../application/services/acoustic_report_service.dart';
import '../../domain/entities/acoustic_report_entity.dart';
import '../../domain/repositories/acoustic_repository.dart';

class AcousticRepositoryImpl implements AcousticRepository {
  NoiseMeter? _noiseMeter;
  StreamSubscription? _noiseSubscription;
  StreamController<NoiseData>? _controller;

  @override
  Stream<NoiseData> get noiseStream {
    // Cleanup any existing instance first to prevent conflicts
    _cleanup();

    // Create a new broadcast controller
    _controller = StreamController<NoiseData>.broadcast(onCancel: _cleanup);

    try {
      _noiseMeter = NoiseMeter();
      _noiseSubscription = _noiseMeter!.noise.listen(
        (noiseReading) {
          if (_controller != null && !_controller!.isClosed) {
            _controller!.add(NoiseData(meanDecibel: noiseReading.meanDecibel));
          }
        },
        onError: (error) {
          AppLogger.log(
            'Noise meter error in repository: $error',
            level: LogLevel.error,
          );
          if (_controller != null && !_controller!.isClosed) {
            _controller!.addError(error);
          }
        },
        cancelOnError: false,
      );
    } catch (e) {
      AppLogger.log(
        'Failed to create NoiseMeter in repository: $e',
        level: LogLevel.error,
      );
      if (_controller != null && !_controller!.isClosed) {
        _controller!.addError(e);
      }
    }

    return _controller!.stream;
  }

  /// Cleanup method to properly dispose of NoiseMeter resources
  void _cleanup() {
    _noiseSubscription?.cancel();
    _noiseSubscription = null;
    _noiseMeter = null;
    _controller?.close();
    _controller = null;
  }

  /// Public dispose method for external cleanup
  void dispose() {
    _cleanup();
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
