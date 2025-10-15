import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/models/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/enhanced_noise_meter_provider.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/index.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

/// Real-time acoustic monitoring screen
class AcousticMonitoringScreen extends ConsumerStatefulWidget {
  final RecordingPreset preset;

  const AcousticMonitoringScreen({super.key, required this.preset});

  @override
  ConsumerState<AcousticMonitoringScreen> createState() =>
      _AcousticMonitoringScreenState();
}

class _AcousticMonitoringScreenState
    extends ConsumerState<AcousticMonitoringScreen> {
  bool _isRecording = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start recording automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startRecording();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRecording() {
    ref
        .read(enhancedNoiseMeterProvider.notifier)
        .startRecordingWithPreset(widget.preset);
    setState(() {
      _isRecording = true;
    });
  }

  void _stopRecording() async {
    _timer?.cancel();
    final report = await ref
        .read(enhancedNoiseMeterProvider.notifier)
        .stopRecording();

    setState(() {
      _isRecording = false;
    });

    if (report != null && mounted) {
      // Show success and pop
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.reportGeneratedSuccess)));
      Navigator.pop(context, report);
    } else if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(enhancedNoiseMeterProvider);

    return WillPopScope(
      onWillPop: () async {
        if (_isRecording) {
          final shouldStop = await _showStopDialog();
          if (shouldStop) {
            _stopRecording();
          }
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          title: Text(_getPresetTitle(l10n)),
          centerTitle: true,
          elevation: 0,
          actions: [
            if (_isRecording)
              IconButton(
                icon: const Icon(Iconsax.pause_circle),
                onPressed: () async {
                  final shouldStop = await _showStopDialog();
                  if (shouldStop) {
                    _stopRecording();
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
                // Status Card - Using reusable widget
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

                // Current Decibel Display - Using specialized widget
                DecibelDisplay(
                  decibels: state.currentDecibels,
                  noiseLevel: _getNoiseLevel(state.currentDecibels),
                  unit: l10n.decibelUnit,
                ),
                const SizedBox(height: 24),

                // Progress Indicator - Using specialized widget
                SessionProgressIndicator(
                  progress: state.progress,
                  remainingTime: _formatDuration(
                    state.remainingTime ?? Duration.zero,
                    l10n,
                  ),
                  label: l10n.monitoringProgress,
                  color: _getDecibelColor(state.averageDecibels),
                ),
                const SizedBox(height: 24),

                // Real-time Chart - Using reusable chart widget
                RealtimeLineChart(
                  dataPoints: state.decibelHistory,
                  title: l10n.monitoringLiveChart,
                  lineColor: _getDecibelColor(state.averageDecibels),
                  maxY: 100,
                  horizontalInterval: 20,
                ),
                const SizedBox(height: 24),

                // Statistics Cards - Using reusable StatCard
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

                // Events List
                _buildEventsList(theme, state, l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPresetTitle(AppLocalizations l10n) {
    switch (widget.preset) {
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

  Future<bool> _showStopDialog() async {
    final l10n = AppLocalizations.of(context)!;
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
}
