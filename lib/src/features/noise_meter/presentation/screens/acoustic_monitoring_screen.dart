import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/models/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/enhanced_noise_meter_provider.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report generated successfully!')),
      );
      Navigator.pop(context, report);
    } else if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
          title: Text(_getPresetTitle()),
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
                tooltip: 'Stop Recording',
              ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Status Card
                _buildStatusCard(theme, isDark, state),
                const SizedBox(height: 24),

                // Current Decibel Display
                _buildDecibelDisplay(theme, state),
                const SizedBox(height: 24),

                // Progress Indicator
                _buildProgressIndicator(theme, state),
                const SizedBox(height: 24),

                // Real-time Chart
                _buildRealtimeChart(theme, isDark, state),
                const SizedBox(height: 24),

                // Statistics Cards
                _buildStatisticsCards(theme, isDark, state),
                const SizedBox(height: 24),

                // Events List
                _buildEventsList(theme, isDark, state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPresetTitle() {
    switch (widget.preset) {
      case RecordingPreset.sleep:
        return 'Sleep Analysis (8h)';
      case RecordingPreset.work:
        return 'Work Environment (1h)';
      case RecordingPreset.focus:
        return 'Focus Session (30m)';
      case RecordingPreset.custom:
        return 'Custom Recording';
    }
  }

  Widget _buildStatusCard(
    ThemeData theme,
    bool isDark,
    EnhancedNoiseMeterData state,
  ) {
    final color = state.isRecording ? Colors.green : Colors.grey;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.isRecording
                        ? 'Recording Active'
                        : 'Recording Stopped',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.isRecording
                        ? 'Monitoring acoustic environment...'
                        : 'Recording completed',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
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

  Widget _buildDecibelDisplay(ThemeData theme, EnhancedNoiseMeterData state) {
    final decibel = state.currentDecibels;
    final color = _getDecibelColor(decibel);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
        ),
        child: Column(
          children: [
            Text(
              'Current Level',
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  decibel.toStringAsFixed(1),
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 8),
                  child: Text(
                    'dB',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _getNoiseLevel(decibel),
              style: theme.textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(
    ThemeData theme,
    EnhancedNoiseMeterData state,
  ) {
    final progress = state.progress;
    final remaining = state.remainingTime ?? Duration.zero;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatDuration(remaining),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getDecibelColor(state.averageDecibels),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(1)}% complete',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealtimeChart(
    ThemeData theme,
    bool isDark,
    EnhancedNoiseMeterData state,
  ) {
    final dataPoints = state.decibelHistory;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Monitoring',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: dataPoints.isEmpty
                  ? Center(
                      child: Text(
                        'Collecting data...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 20,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.2),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 20,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}',
                                  style: theme.textTheme.bodySmall,
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: dataPoints.length.toDouble(),
                        minY: 0,
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              dataPoints.length,
                              (index) =>
                                  FlSpot(index.toDouble(), dataPoints[index]),
                            ),
                            isCurved: true,
                            color: _getDecibelColor(state.averageDecibels),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: _getDecibelColor(
                                state.averageDecibels,
                              ).withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(
    ThemeData theme,
    bool isDark,
    EnhancedNoiseMeterData state,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Iconsax.chart,
            label: 'Average',
            value: '${state.averageDecibels.toStringAsFixed(1)} dB',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Iconsax.warning_2,
            label: 'Events',
            value: '${state.events.length}',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildEventsList(
    ThemeData theme,
    bool isDark,
    EnhancedNoiseMeterData state,
  ) {
    if (state.events.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Iconsax.tick_circle, size: 48, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                'No Interruptions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your environment has been quiet',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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
                return _EventItem(event: event);
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

  String _formatDuration(Duration duration) {
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
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Stop Recording?'),
            content: const Text(
              'Are you sure you want to stop the recording? This will generate your acoustic environment report.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Continue Recording'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Stop & Generate Report'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventItem extends StatelessWidget {
  final AcousticEvent event;

  const _EventItem({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getEventColor(event.peakDecibels);

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_getEventIcon(event.eventType), color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.eventType,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${event.peakDecibels.toStringAsFixed(1)} dB • ${_formatTime(event.timestamp)}',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${event.duration.inSeconds}s',
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Color _getEventColor(double decibel) {
    if (decibel < 70) return Colors.orange;
    if (decibel < 80) return Colors.deepOrange;
    return Colors.red;
  }

  IconData _getEventIcon(String type) {
    switch (type.toLowerCase()) {
      case 'spike':
        return Iconsax.flash_1;
      case 'sustained':
        return Iconsax.chart_1;
      case 'intermittent':
        return Iconsax.sound;
      default:
        return Iconsax.warning_2;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
