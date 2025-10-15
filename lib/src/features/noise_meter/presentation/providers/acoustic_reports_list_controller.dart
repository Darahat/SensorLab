
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/domain/repositories/acoustic_repository.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/enhanced_noise_data.dart';

import '../../data/repositories/acoustic_repository_impl.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/acoustic_reports_list_state.dart';

/// Provider for the AcousticReportsListController
final acousticReportsListProvider = StateNotifierProvider.autoDispose<
    AcousticReportsListController, AcousticReportsListState>(
  (ref) {
    final repository = ref.watch(acousticRepositoryProvider);
    return AcousticReportsListController(repository);
  },
);

/// Controller for the AcousticReportsListScreen
class AcousticReportsListController extends StateNotifier<AcousticReportsListState> {
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
      // Handle error appropriately in a real app
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
      // Reload reports from repository
      await loadReports();
      // Exit selection mode
      cancelSelection();
    } catch (e) {
      // Handle error
    }
  }

  String exportReportsAsCSV(List<AcousticReport> reports) {
    if (reports.isEmpty) return '';

    final csv = StringBuffer();
    csv.writeln(
      'ID,Start Time,End Time,Duration (min),Preset,Average dB,Min dB,Max dB,Events,Quality Score,Quality,Recommendation',
    );

    for (final report in reports) {
      csv.writeln(
        '"${report.id}",'
        '"${report.startTime.toIso8601String()}",'
        '"${report.endTime.toIso8601String()}",'
        '${report.duration.inMinutes}, '
        '"${report.preset.name}",'
        '${report.averageDecibels.toStringAsFixed(1)}, '
        '${report.minDecibels.toStringAsFixed(1)}, '
        '${report.maxDecibels.toStringAsFixed(1)}, '
        '${report.interruptionCount},'
        '${report.qualityScore},'
        '"${report.environmentQuality}",'
        '"${report.recommendation.replaceAll('"', '""')}"'
      );
    }
    return csv.toString();
  }
}
