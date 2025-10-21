import 'package:hive_flutter/hive_flutter.dart';
import 'package:sensorlab/src/core/services/hive_service.dart';
import 'package:sensorlab/src/features/noise_meter/data/models/acoustic_report_hive.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';

/// Service for managing acoustic reports in Hive database.
///
/// This service should only be concerned with persisting and retrieving the
/// AcousticReportHive DTO (Data Transfer Object). The mapping to and from the
/// domain entity (AcousticReport) is the responsibility of the repository layer.
///
/// NOTE: The use of static methods here acts like a global singleton, which can
/// make testing difficult. A future refactoring should involve providing this
/// service through Riverpod to allow for easier dependency injection and mocking.
class AcousticReportService {
  /// Get the box instance from HiveService
  static Box<AcousticReportHive> get _box {
    return Hive.box<AcousticReportHive>(HiveService.acousticReportBoxName);
  }

  /// Save a report DTO to Hive
  static Future<void> saveReport(AcousticReportHive hiveReport) async {
    await _box.put(hiveReport.id, hiveReport);
  }

  /// Get all report DTOs sorted by date (newest first)
  static List<AcousticReportHive> getReportsSorted() {
    final reports = _box.values.toList();
    reports.sort((a, b) => b.startTime.compareTo(a.startTime));
    return reports;
  }

  /// Delete a report by its ID
  static Future<void> deleteReport(String id) async {
    await _box.delete(id);
  }

  /// Delete all reports
  static Future<void> deleteAllReports() async {
    await _box.clear();
  }

  /// Get total number of reports
  static int get reportCount => _box.length;

  ///
  /// --- The methods below contain business logic and should be refactored ---
  ///
  /// These methods currently perform calculations that belong in the domain or
  /// application layer, not in a data persistence service. They require mapping
  /// from DTO to Entity, which is a sign that the responsibility is in the
  /// wrong place. This is a code smell and should be addressed in a future refactoring.
  ///

  /// Get average quality score from all reports
  static double get averageQualityScore {
    if (_box.isEmpty) {
      return 0;
    }
    final sum = _box.values.fold<double>(
      0,
      (sum, r) => sum + r.toEntity().qualityScore,
    );
    return sum / _box.length;
  }

  /// Get statistics for a preset type
  static Map<String, dynamic> getPresetStatistics(RecordingPreset preset) {
    final reports = _box.values
        .where((r) => r.presetIndex == preset.index)
        .map((r) => r.toEntity())
        .toList();
    if (reports.isEmpty) {
      return {
        'count': 0,
        'averageDecibels': 0.0,
        'averageQuality': 0,
        'totalInterruptions': 0,
      };
    }

    final avgDb =
        reports.fold<double>(0, (sum, r) => sum + r.averageDecibels) /
        reports.length;

    final avgQuality =
        reports.fold<int>(0, (sum, r) => sum + r.qualityScore) / reports.length;

    final totalInterruptions = reports.fold<int>(
      0,
      (sum, r) => sum + r.interruptionCount,
    );

    return {
      'count': reports.length,
      'averageDecibels': avgDb,
      'averageQuality': avgQuality.toInt(),
      'totalInterruptions': totalInterruptions,
    };
  }
}
