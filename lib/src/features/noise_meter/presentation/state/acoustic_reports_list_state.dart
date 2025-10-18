import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';

part 'acoustic_reports_list_state.freezed.dart';

@freezed
class AcousticReportsListState with _$AcousticReportsListState {
  const factory AcousticReportsListState({
    @Default([]) List<AcousticReport> reports,
    @Default(true) bool isLoading,
    RecordingPreset? filterPreset,
    @Default({}) Set<String> selectedReportIds,
    @Default(false) bool isSelectionMode,
  }) = _AcousticReportsListState;

  const AcousticReportsListState._();

  List<AcousticReport> get filteredReports {
    if (filterPreset == null) {
      return reports;
    }
    return reports.where((r) => r.preset == filterPreset).toList();
  }
}
