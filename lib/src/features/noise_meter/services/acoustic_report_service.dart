import 'package:hive_flutter/hive_flutter.dart';
import 'package:sensorlab/src/core/services/hive_service.dart';
import 'package:sensorlab/src/features/noise_meter/models/acoustic_report.dart';
import 'package:sensorlab/src/features/noise_meter/models/enhanced_noise_data.dart';

/// Service for managing acoustic reports in Hive database
class AcousticReportService {
  /// Get the box instance from HiveService
  static Box<AcousticReportHive> get _box {
    return Hive.box<AcousticReportHive>(HiveService.acousticReportBoxName);
  }

  /// Convert AcousticReportHive to AcousticReport
  static AcousticReport _convertToReport(AcousticReportHive hiveReport) {
    return AcousticReport(
      id: hiveReport.id,
      startTime: hiveReport.startTime,
      endTime: hiveReport.endTime,
      duration: hiveReport.duration,
      preset: hiveReport.preset,
      averageDecibels: hiveReport.averageDecibels,
      minDecibels: hiveReport.minDecibels,
      maxDecibels: hiveReport.maxDecibels,
      events: hiveReport.events.map((e) => e.toEvent()).toList(),
      timeInLevels: hiveReport.timeInLevels,
      hourlyAverages: hiveReport.hourlyAverages,
      environmentQuality: hiveReport.environmentQuality,
      recommendation: hiveReport.recommendation,
    );
  }

  /// Save a report to Hive (converts from AcousticReport to AcousticReportHive)
  static Future<void> saveReport(AcousticReport report) async {
    final hiveReport = AcousticReportHive(
      id: report.id,
      startTime: report.startTime,
      endTime: report.endTime,
      duration: report.duration,
      preset: report.preset,
      averageDecibels: report.averageDecibels,
      minDecibels: report.minDecibels,
      maxDecibels: report.maxDecibels,
      events: report.events.map((e) => AcousticEventHive.fromEvent(e)).toList(),
      timeInLevels: report.timeInLevels,
      hourlyAverages: report.hourlyAverages,
      environmentQuality: report.environmentQuality,
      recommendation: report.recommendation,
    );
    await _box.put(report.id, hiveReport);
  }

  /// Get all reports (converts from Hive to regular models)
  static List<AcousticReport> getAllReports() {
    return _box.values
        .map((hiveReport) => _convertToReport(hiveReport))
        .toList();
  }

  /// Get reports sorted by date (newest first)
  static List<AcousticReport> getReportsSorted() {
    final reports = getAllReports();
    reports.sort((a, b) => b.startTime.compareTo(a.startTime));
    return reports;
  }

  /// Get reports by preset type
  static List<AcousticReport> getReportsByPreset(RecordingPreset preset) {
    return _box.values
        .where((r) => r.preset == preset)
        .map((r) => _convertToReport(r))
        .toList();
  }

  /// Get reports in date range
  static List<AcousticReport> getReportsInRange(DateTime start, DateTime end) {
    return _box.values
        .where((r) {
          return r.startTime.isAfter(start) && r.startTime.isBefore(end);
        })
        .map((r) => _convertToReport(r))
        .toList();
  }

  /// Get report by ID
  static AcousticReport? getReportById(String id) {
    final hiveReport = _box.get(id);
    return hiveReport != null ? _convertToReport(hiveReport) : null;
  }

  /// Delete a report
  static Future<void> deleteReport(String id) async {
    await _box.delete(id);
  }

  /// Delete all reports
  static Future<void> deleteAllReports() async {
    await _box.clear();
  }

  /// Get total number of reports
  static int get reportCount => _box.length;

  /// Get reports from last N days
  static List<AcousticReport> getReportsFromLastDays(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _box.values
        .where((r) => r.startTime.isAfter(cutoff))
        .map((r) => _convertToReport(r))
        .toList();
  }

  /// Get average quality score from all reports
  static double get averageQualityScore {
    if (_box.isEmpty) return 0;
    final sum = _box.values.fold<int>(0, (sum, r) => sum + r.qualityScore);
    return sum / _box.length;
  }

  /// Get statistics for a preset type
  static Map<String, dynamic> getPresetStatistics(RecordingPreset preset) {
    final reports = getReportsByPreset(preset);
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

  /// Export reports as JSON
  static List<Map<String, dynamic>> exportReportsAsJson() {
    return _box.values.map((r) => r.toJson()).toList();
  }

  /// Get recent reports (last 10)
  static List<AcousticReport> getRecentReports({int limit = 10}) {
    final sorted = getReportsSorted();
    return sorted.take(limit).toList();
  }

  /// Check if a report exists
  static bool reportExists(String id) {
    return _box.containsKey(id);
  }

  /// Get best quality report
  static AcousticReport? getBestQualityReport() {
    if (_box.isEmpty) return null;
    final best = _box.values.reduce(
      (a, b) => a.qualityScore > b.qualityScore ? a : b,
    );
    return _convertToReport(best);
  }

  /// Get worst quality report
  static AcousticReport? getWorstQualityReport() {
    if (_box.isEmpty) return null;
    final worst = _box.values.reduce(
      (a, b) => a.qualityScore < b.qualityScore ? a : b,
    );
    return _convertToReport(worst);
  }
}
