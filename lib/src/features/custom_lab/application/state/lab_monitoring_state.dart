import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';

part 'lab_monitoring_state.freezed.dart';

@freezed
class LabMonitoringState with _$LabMonitoringState {
  const factory LabMonitoringState({
    @Default(false) bool isRecording,
    @Default(false) bool isPaused,
    @Default(false) bool isAnalyzing,
    Lab? activeLab,
    LabSession? activeSession,
    @Default(0) int elapsedSeconds,
    String? errorMessage,
  }) = _LabMonitoringState;
}
