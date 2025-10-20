import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/noise_meter/application/notifiers/enhanced_noise_meter_notifier.dart';
import 'package:sensorlab/src/features/noise_meter/application/providers/enhanced_noise_meter_provider.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart';
import 'package:sensorlab/src/features/noise_meter/utils/utils_index.dart';

class AcousticMonitoringContent extends ConsumerStatefulWidget {
  final RecordingPreset preset;
  final CustomPresetConfig? customConfig;

  const AcousticMonitoringContent({
    super.key,
    required this.preset,
    this.customConfig,
  });

  @override
  ConsumerState<AcousticMonitoringContent> createState() =>
      _AcousticMonitoringContentState();
}

class _AcousticMonitoringContentState
    extends ConsumerState<AcousticMonitoringContent> {
  // Listener moved into build to satisfy Riverpod constraint

  @override
  Widget build(BuildContext context) {
    // React to newly generated report and show the completion dialog
    ref.listen<EnhancedNoiseMeterData>(enhancedNoiseMeterProvider, (
      previous,
      next,
    ) {
      if (next.lastGeneratedReport != null &&
          previous?.lastGeneratedReport == null) {
        ReportCompleteDialog.show(
          context: context,
          report: next.lastGeneratedReport!,
          preset: widget.preset,
          customConfig: widget.customConfig,
        );
      }
    });
    final state = ref.watch(enhancedNoiseMeterProvider);
    final notifier = ref.read(enhancedNoiseMeterProvider.notifier);

    return WillPopScope(
      onWillPop: () => _onWillPop(context, state, notifier),
      child: Column(
        children: [
          MonitoringAppBar(
            preset: widget.preset,
            customConfig: widget.customConfig,
            state: state,
            notifier: notifier,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _buildContent(state, notifier),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    EnhancedNoiseMeterData state,
    EnhancedNoiseMeterNotifier notifier,
  ) {
    if (!state.isRecording) {
      return RecordingInitialState(
        preset: widget.preset,
        customConfig: widget.customConfig,
        onStartRecording: () => notifier.startRecordingWithPreset(
          widget.preset,
          customDuration: widget.customConfig?.duration,
        ),
      );
    }

    return RecordingActiveState(
      preset: widget.preset,
      customConfig: widget.customConfig,
      state: state,
      notifier: notifier,
    );
  }

  Future<bool> _onWillPop(
    BuildContext context,
    EnhancedNoiseMeterData state,
    EnhancedNoiseMeterNotifier notifier,
  ) async {
    if (state.isRecording) {
      final shouldStop = await StopRecordingDialog.show(context);
      if (shouldStop) {
        notifier.stopRecording();
      }
      return false;
    }
    return true;
  }
}
