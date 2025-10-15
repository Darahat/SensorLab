import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/enhanced_noise_meter_provider.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/index.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

/// Real-time acoustic monitoring screen - now a stateless ConsumerWidget.
class AcousticMonitoringScreen extends ConsumerWidget {
  final RecordingPreset preset;

  const AcousticMonitoringScreen({super.key, required this.preset});

  // Helper to get the total duration for a preset.
  Duration _getPresetDuration(RecordingPreset preset) {
    switch (preset) {
      case RecordingPreset.sleep:
        return const Duration(hours: 8);
      case RecordingPreset.work:
        return const Duration(hours: 1);
      case RecordingPreset.focus:
        return const Duration(minutes: 30);
      case RecordingPreset.custom:
        return Duration.zero; // Indicates indefinite duration
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(enhancedNoiseMeterProvider.notifier);
    final state = ref.watch(enhancedNoiseMeterProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!state.isRecording && state.lastGeneratedReport == null) {
        notifier.startRecordingWithPreset(preset);
      }
    });

    ref.listen<EnhancedNoiseMeterData>(enhancedNoiseMeterProvider,
        (previous, next) {
      if (next.lastGeneratedReport != null &&
          previous?.lastGeneratedReport == null) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.reportGeneratedSuccess)));
        Navigator.of(context).pop(next.lastGeneratedReport);
      }
    });

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // --- Calculate Progress and Remaining Time ---
    final totalDuration = _getPresetDuration(preset);
    final isCustomPreset = totalDuration == Duration.zero;

    final Duration elapsedDuration = state.sessionDuration;
    final Duration remainingTime =
        isCustomPreset ? Duration.zero : totalDuration - elapsedDuration;

    double progress = 0.0;
    if (!isCustomPreset && totalDuration.inSeconds > 0) {
      progress = elapsedDuration.inSeconds / totalDuration.inSeconds;
      if (progress > 1.0) progress = 1.0;
      if (progress < 0.0) progress = 0.0;
    }
    // --- End Calculation ---

    Future<bool> showStopDialog() async {
      return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.stopRecordingConfirmTitle),
              content: Text(l10n.stopRecordingConfirmMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.continueRecording),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(l10n.recordingStop),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: () async {
        if (state.isRecording) {
          final shouldStop = await showStopDialog();
          if (shouldStop) {
            notifier.stopRecording();
          }
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          title: Text(_getPresetTitle(l10n, preset)),
          centerTitle: true,
          elevation: 0,
          actions: [
            if (state.isRecording)
              IconButton(
                icon: const Icon(Iconsax.pause_circle),
                onPressed: () async {
                  final shouldStop = await showStopDialog();
                  if (shouldStop) {
                    notifier.stopRecording();
                  }
                },
                tooltip: l10n.stopRecordingTooltip,
              ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                StatusCard(
                  isActive: state.isRecording,
                  title: state.isRecording
                      ? l10n.monitoringActive
                      : l10n.monitoringStopped,
                  subtitle: state.isRecording
                      ? l10n.monitoringEnvironment
                      : l10n.recordingCompleted,
                ),
                const SizedBox(height: 24),
                DecibelDisplay(
                  decibels: state.currentDecibels,
                  noiseLevel: _getNoiseLevel(state.currentDecibels),
                  unit: l10n.decibelUnit,
                ),
                const SizedBox(height: 24),

                // Only show progress for presets with a defined duration
                if (!isCustomPreset)
                  SessionProgressIndicator(
                    progress: progress,
                    remainingTime: _formatDuration(
                      remainingTime,
                      l10n,
                    ),
                    label: l10n.monitoringProgress,
                    color: _getDecibelColor(state.averageDecibels),
                  ),

                const SizedBox(height: 24),
                RealtimeLineChart(
                  dataPoints: state.decibelHistory,
                  title: l10n.monitoringLiveChart,
                  lineColor: _getDecibelColor(state.averageDecibels),
                  maxY: 100,
                  horizontalInterval: 20,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Iconsax.chart,
                        label: l10n.reportAverage,
                        value:
                            '${state.averageDecibels.toStringAsFixed(1)} ${l10n.decibelUnit}',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Iconsax.warning_2,
                        label: l10n.reportEvents,
                        value: '${state.events.length}',
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildEventsList(theme, state, l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPresetTitle(AppLocalizations l10n, RecordingPreset preset) {
    switch (preset) {
      case RecordingPreset.sleep:
        return l10n.presetSleepAnalysis;
      case RecordingPreset.work:
        return l10n.presetWorkEnvironment;
      case RecordingPreset.focus:
        return l10n.presetFocusSession;
      case RecordingPreset.custom:
        return l10n.presetCustomRecording;
    }
  }

  Widget _buildEventsList(
    ThemeData theme,
    EnhancedNoiseMeterData state,
    AppLocalizations l10n,
  ) {
    if (state.events.isEmpty) {
      return EmptyStateWidget(
        icon: Iconsax.tick_circle,
        title: 'No Interruptions',
        message: 'Your environment has been quiet',
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Noise Events (${state.events.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.events.length,
              separatorBuilder: (context, index) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final event = state.events[index];
                return NoiseEventItem(
                  timestamp: event.timestamp,
                  peakDecibels: event.peakDecibels,
                  duration: event.duration,
                  eventType: event.eventType,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getDecibelColor(double decibel) {
    if (decibel < 40) return Colors.green;
    if (decibel < 55) return Colors.lightGreen;
    if (decibel < 65) return Colors.orange;
    if (decibel < 75) return Colors.deepOrange;
    return Colors.red;
  }

  String _getNoiseLevel(double decibel) {
    if (decibel < 40) return 'Very Quiet';
    if (decibel < 55) return 'Quiet';
    if (decibel < 65) return 'Moderate';
    if (decibel < 75) return 'Loud';
    return 'Very Loud';
  }

  String _formatDuration(Duration duration, AppLocalizations l10n) {
    if (duration.isNegative) return 'Finished';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m remaining';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s remaining';
    } else {
      return '${seconds}s remaining';
    }
  }
}
