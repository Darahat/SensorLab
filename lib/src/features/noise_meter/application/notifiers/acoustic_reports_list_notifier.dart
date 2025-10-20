import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/noise_meter/application/state/acoustic_reports_list_state.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/domain/repositories/acoustic_repository.dart';

class AcousticReportsListController
    extends StateNotifier<AcousticReportsListState> {
  AcousticReportsListController(this._repository)
    : super(const AcousticReportsListState()) {
    loadReports();
  }

  final AcousticRepository _repository;

  Future<void> loadReports() async {
    state = state.copyWith(isLoading: true);
    try {
      final reports = await _repository.getReports();
      state = state.copyWith(reports: reports, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void setFilter(RecordingPreset? preset) {
    state = state.copyWith(filterPreset: preset);
  }

  void onReportTap(AcousticReport report) {
    if (state.isSelectionMode) {
      final newSelectedIds = Set<String>.from(state.selectedReportIds);
      if (newSelectedIds.contains(report.id)) {
        newSelectedIds.remove(report.id);
      } else {
        newSelectedIds.add(report.id);
      }
      state = state.copyWith(
        selectedReportIds: newSelectedIds,
        isSelectionMode: newSelectedIds.isNotEmpty,
      );
    }
  }

  void onReportLongPress(AcousticReport report) {
    if (!state.isSelectionMode) {
      state = state.copyWith(
        isSelectionMode: true,
        selectedReportIds: {report.id},
      );
    }
  }

  void cancelSelection() {
    state = state.copyWith(isSelectionMode: false, selectedReportIds: {});
  }

  Future<void> deleteSelected() async {
    try {
      for (final id in state.selectedReportIds) {
        await _repository.deleteReport(id);
      }
      await loadReports();
      cancelSelection();
    } catch (_) {}
  }

  // UI actions (dialogs/snackbars) should be handled in the presentation layer.
  // Keep application layer free of BuildContext and Widgets.

  String exportReportsAsCSV(List<AcousticReport> reports) {
    if (reports.isEmpty) {
      return '';
    }

    final csv = StringBuffer();
    csv.writeln(
      'ID,Start Time,End Time,Duration (min),Preset,Average dB,Min dB,Max dB,Events,Quality Score,Quality,Recommendation',
    );

    for (final report in reports) {
      csv.writeln(
        '"${report.id}",' // ID
        '"${report.startTime.toIso8601String()}",' // Start Time
        '"${report.endTime.toIso8601String()}",' // End Time
        '${report.duration.inMinutes}, ' // Duration
        '"${_getPresetName(report.preset)}",' // Preset
        '${report.averageDecibels.toStringAsFixed(1)}, ' // Avg dB
        '${report.minDecibels.toStringAsFixed(1)}, ' // Min dB
        '${report.maxDecibels.toStringAsFixed(1)}, ' // Max dB
        '${report.interruptionCount},' // Events
        '${report.qualityScore},' // Quality Score
        '"${report.environmentQuality}",' // Quality
        '"${_escapeCSV(report.recommendation)}"', // Recommendation
      );
    }
    return csv.toString();
  }

  // Helper methods for CSV formatting
  String _getPresetName(RecordingPreset preset) {
    switch (preset) {
      case RecordingPreset.sleep:
        return 'Sleep';
      case RecordingPreset.work:
        return 'Work';
      case RecordingPreset.focus:
        return 'Focus';
      case RecordingPreset.custom:
        return 'Custom';
    }
  }

  String _escapeCSV(String text) {
    return text.replaceAll('"', '""');
  }
}
