import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_monitoring_notifier.dart';
import 'package:sensorlab/src/features/custom_lab/application/state/lab_monitoring_state.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/screens/session_history_screen.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_component_factory.dart';

class LabMonitoringContent extends ConsumerWidget {
  final Lab lab;

  const LabMonitoringContent({required this.lab, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Listen for session completion and navigate to session history
    ref.listen<LabMonitoringState>(labMonitoringNotifierProvider, (
      previous,
      next,
    ) {
      // Session just stopped - navigate to session history
      if (previous?.isRecording == true &&
          !next.isRecording &&
          !next.isPaused) {
        // Pop the recording screen
        Navigator.of(context).pop();

        // Navigate to session history
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SessionHistoryScreen(lab: lab),
          ),
        );
      }
    });

    final monitoringState = ref.watch(labMonitoringNotifierProvider);

    return Column(
      children: [
        // Status banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: monitoringState.isRecording
              ? Colors.red
              : monitoringState.isPaused
              ? Colors.orange
              : Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                monitoringState.isRecording
                    ? Icons.fiber_manual_record
                    : monitoringState.isPaused
                    ? Icons.pause
                    : Icons.check_circle,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Text(
                monitoringState.isRecording
                    ? l10n.recordingStatus.toUpperCase()
                    : monitoringState.isPaused
                    ? l10n.pausedStatus.toUpperCase()
                    : l10n.completedStatus.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),

        // Timer
        Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(l10n.elapsedTime, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text(
                _formatDuration(monitoringState.elapsedSeconds),
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),

        const Divider(),

        // Sensor data display with per-sensor graph
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lab.sensors.length,
            itemBuilder: (context, index) {
              final sensor = lab.sensors[index];

              // Use sensor-specific component from the factory
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SensorComponentFactory.buildSensorWidget(sensor),
              );
            },
          ),
        ),

        // Error display
        if (monitoringState.errorMessage != null)
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.errorContainer,
            child: Row(
              children: [
                Icon(Icons.error, color: theme.colorScheme.error),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    monitoringState.errorMessage!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ],
            ),
          ),

        // Control buttons
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (monitoringState.isRecording)
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => ref
                        .read(labMonitoringNotifierProvider.notifier)
                        .pauseSession(),
                    icon: const Icon(Icons.pause),
                    label: Text(l10n.pause),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                )
              else if (monitoringState.isPaused) ...[
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => ref
                        .read(labMonitoringNotifierProvider.notifier)
                        .resumeSession(),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l10n.resume),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
              if (monitoringState.isRecording || monitoringState.isPaused) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => ref
                        .read(labMonitoringNotifierProvider.notifier)
                        .stopSession(),
                    icon: const Icon(Icons.stop),
                    label: Text(l10n.stop),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
