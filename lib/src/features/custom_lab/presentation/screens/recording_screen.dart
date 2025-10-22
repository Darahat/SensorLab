import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/recording_session_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/session_complete_dialog.dart';

/// Screen for recording sensor data
class RecordingScreen extends ConsumerStatefulWidget {
  final Lab lab;

  const RecordingScreen({required this.lab, super.key});

  @override
  ConsumerState<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends ConsumerState<RecordingScreen> {
  Timer? _recordingTimer;
  final Map<String, dynamic> _currentSensorData = {};

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    super.dispose();
  }

  Future<void> _startSession() async {
    AppLogger.log(
      'RecordingScreen: _startSession called for lab ${widget.lab.id}',
      level: LogLevel.info,
    );

    final notifier = ref.read(recordingSessionProvider.notifier);
    final success = await notifier.startSession(labId: widget.lab.id);

    AppLogger.log(
      'RecordingScreen: startSession returned success=$success',
      level: LogLevel.info,
    );

    if (success) {
      final state = ref.read(recordingSessionProvider);
      AppLogger.log(
        'RecordingScreen: Session started - id=${state.activeSession?.id}, status=${state.activeSession?.status}, isRecording=${state.isRecording}',
        level: LogLevel.info,
      );
      _startDataCollection();
    } else {
      final state = ref.read(recordingSessionProvider);
      AppLogger.log(
        'RecordingScreen: Failed to start - error=${state.errorMessage}',
        level: LogLevel.error,
      );
      if (mounted) {
        _showError(state.errorMessage ?? 'Failed to start recording session');
      }
    }
  }

  void _startDataCollection() {
    // Simulate sensor data collection
    // In production, this would read from actual sensors
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(
      Duration(milliseconds: widget.lab.recordingInterval),
      (timer) {
        final state = ref.read(recordingSessionProvider);
        AppLogger.log(
          'RecordingScreen tick: isRecording=${state.isRecording}, isPaused=${state.isPaused}, elapsed=${state.elapsedSeconds}s',
          level: LogLevel.debug,
        );
        if (state.isRecording) {
          _collectAndSaveSensorData();
        }
      },
    );
  }

  Future<void> _collectAndSaveSensorData() async {
    // Simulate reading sensor data using SensorType directly
    final sensorData = <String, dynamic>{};

    for (final sensor in widget.lab.sensors) {
      final sensorKey = sensor.name;

      switch (sensor) {
        case SensorType.accelerometer:
          sensorData[sensorKey] = {
            'x': _randomValue(-10, 10),
            'y': _randomValue(-10, 10),
            'z': _randomValue(-10, 10),
          };
          break;
        case SensorType.gyroscope:
          sensorData[sensorKey] = {
            'x': _randomValue(-5, 5),
            'y': _randomValue(-5, 5),
            'z': _randomValue(-5, 5),
          };
          break;
        case SensorType.temperature:
          sensorData[sensorKey] = _randomValue(15, 35);
          break;
        case SensorType.humidity:
          sensorData[sensorKey] = _randomValue(30, 80);
          break;
        case SensorType.lightMeter:
          sensorData[sensorKey] = _randomValue(0, 1000);
          break;
        case SensorType.noiseMeter:
          sensorData[sensorKey] = _randomValue(30, 100);
          break;
        case SensorType.barometer:
          sensorData[sensorKey] = _randomValue(900, 1100);
          break;
        case SensorType.magnetometer:
        case SensorType.proximity:
        case SensorType.gps:
        case SensorType.compass:
        case SensorType.pedometer:
        case SensorType.altimeter:
        case SensorType.speedMeter:
        case SensorType.heartBeat:
          sensorData[sensorKey] = _randomValue(0, 100);
          break;
      }
    }

    setState(() {
      _currentSensorData.clear();
      _currentSensorData.addAll(sensorData);
    });

    // Save data point
    final notifier = ref.read(recordingSessionProvider.notifier);
    AppLogger.log(
      'RecordingScreen: addDataPoint called with keys: ${sensorData.keys.toList()}',
      level: LogLevel.debug,
    );
    await notifier.addDataPoint(sensorData);
    final session = ref.read(recordingSessionProvider).activeSession;
    if (session != null) {
      AppLogger.log(
        'RecordingScreen: dataPointsCount now ${session.dataPointsCount}',
        level: LogLevel.info,
      );
    }
  }

  double _randomValue(double min, double max) {
    return min +
        (max - min) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Listen for session completion and show dialog
    ref.listen<RecordingSessionState>(recordingSessionProvider, (
      previous,
      next,
    ) {
      // Session just completed
      if (previous?.isRecording == true &&
          !next.isRecording &&
          !next.isPaused &&
          next.activeSession != null &&
          next.activeSession!.status == RecordingStatus.completed) {
        SessionCompleteDialog.show(
          context: context,
          session: next.activeSession!,
        );
      }
    });

    final recordingState = ref.watch(recordingSessionProvider);
    final session = recordingState.activeSession;

    return WillPopScope(
      onWillPop: () async {
        if (recordingState.isRecording || recordingState.isPaused) {
          final shouldExit = await _showExitConfirmation();
          return shouldExit ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.lab.name),
          actions: [
            if (session != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    l10n.dataPoints(session.dataPointsCount),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            // Status banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: recordingState.isRecording
                  ? Colors.red
                  : recordingState.isPaused
                  ? Colors.orange
                  : Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    recordingState.isRecording
                        ? Icons.fiber_manual_record
                        : recordingState.isPaused
                        ? Icons.pause
                        : Icons.check_circle,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    recordingState.isRecording
                        ? l10n.recordingStatus.toUpperCase()
                        : recordingState.isPaused
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
                    _formatDuration(recordingState.elapsedSeconds),
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Sensor data display
            Expanded(
              child: _currentSensorData.isEmpty
                  ? Center(
                      child: Text(
                        l10n.collectingSensorData,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _currentSensorData.length,
                      itemBuilder: (context, index) {
                        final entry = _currentSensorData.entries.elementAt(
                          index,
                        );
                        return Card(
                          child: ListTile(
                            leading: Icon(
                              _getSensorIcon(entry.key),
                              color: theme.colorScheme.primary,
                            ),
                            title: Text(
                              entry.key.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              _formatSensorValue(entry.value),
                              style: const TextStyle(fontFamily: 'monospace'),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Error display
            if (recordingState.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                color: theme.colorScheme.errorContainer,
                child: Row(
                  children: [
                    Icon(Icons.error, color: theme.colorScheme.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        recordingState.errorMessage!,
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
                  if (recordingState.isRecording)
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _pauseRecording(),
                        icon: const Icon(Icons.pause),
                        label: Text(l10n.pause),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    )
                  else if (recordingState.isPaused) ...[
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _resumeRecording(),
                        icon: const Icon(Icons.play_arrow),
                        label: Text(l10n.resume),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                  if (recordingState.isRecording ||
                      recordingState.isPaused) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _stopRecording(),
                        icon: const Icon(Icons.stop),
                        label: Text(l10n.stop),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                  if (!recordingState.isRecording && !recordingState.isPaused)
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.check),
                        label: Text(l10n.done),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  String _formatSensorValue(dynamic value) {
    if (value is Map) {
      return value.entries
          .map((e) => '${e.key}: ${(e.value as num).toStringAsFixed(2)}')
          .join(', ');
    } else if (value is num) {
      return value.toStringAsFixed(2);
    }
    return value.toString();
  }

  IconData _getSensorIcon(String sensorName) {
    switch (sensorName.toLowerCase()) {
      case 'accelerometer':
        return Icons.speed;
      case 'gyroscope':
        return Icons.screen_rotation;
      case 'temperature':
        return Icons.thermostat;
      case 'humidity':
        return Icons.water_drop;
      case 'light':
        return Icons.light_mode;
      case 'noise':
        return Icons.volume_up;
      case 'pressure':
        return Icons.compress;
      default:
        return Icons.sensors;
    }
  }

  Future<void> _pauseRecording() async {
    final notifier = ref.read(recordingSessionProvider.notifier);
    await notifier.pauseSession();
  }

  Future<void> _resumeRecording() async {
    final notifier = ref.read(recordingSessionProvider.notifier);
    await notifier.resumeSession();
  }

  Future<void> _stopRecording() async {
    final notifier = ref.read(recordingSessionProvider.notifier);
    await notifier.stopSession();
    _recordingTimer?.cancel();

    AppLogger.log(
      'RecordingScreen: stopRecording called',
      level: LogLevel.info,
    );

    // Dialog will be shown automatically via ref.listen
  }

  Future<bool?> _showExitConfirmation() async {
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
              await _stopRecording();
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
