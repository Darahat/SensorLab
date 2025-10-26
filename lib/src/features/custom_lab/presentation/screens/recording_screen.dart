import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/core/providers.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_monitoring_notifier.dart';
import 'package:sensorlab/src/features/custom_lab/application/state/lab_monitoring_state.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/widgets_index.dart';

class RecordingScreen extends ConsumerWidget {
  final Lab lab;

  const RecordingScreen({required this.lab, super.key});

  Future<bool?> _showExitConfirmation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.stopRecordingQuestion),
        content: Text(l10n.stopRecordingConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.continueRecordingAction),
          ),
          FilledButton(
            onPressed: () async {
              await ref
                  .read(labMonitoringNotifierProvider.notifier)
                  .stopSession();
              if (!context.mounted) return;
              Navigator.of(context).pop(true);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.stopAndSave),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monitoringState = ref.watch(labMonitoringNotifierProvider);

    // Start session when the widget is first built
    // This is a common pattern for ConsumerWidget to trigger actions once.
    // Ensure this only runs once per widget lifecycle.
    ref.listen<LabMonitoringState>(labMonitoringNotifierProvider, (
      previous,
      next,
    ) {
      if (previous?.activeLab == null && next.activeLab != null) {
        // Session started, do nothing here, content widget handles UI
      }
    });

    // Trigger start session only once when the screen is initialized
    // This is a workaround for ConsumerWidget to mimic initState behavior
    // for actions that should only happen once.
    if (!monitoringState.isRecording &&
        !monitoringState.isPaused &&
        monitoringState.activeLab == null) {
      Future.microtask(() {
        ref.read(labMonitoringNotifierProvider.notifier).startSession(lab: lab);
        if (lab.sensors.contains(SensorType.gps)) {
          ref.read(geolocatorProvider.notifier).initialize();
        }
      });
    }

    return WillPopScope(
      onWillPop: () async {
        if (monitoringState.isRecording || monitoringState.isPaused) {
          final shouldExit = await _showExitConfirmation(context, ref);
          return shouldExit ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(lab.name),
          actions: [
            if (monitoringState.activeSession != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context)!.dataPoints(
                      monitoringState.activeSession!.dataPointsCount,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: LabMonitoringContent(lab: lab),
      ),
    );
  }
}
