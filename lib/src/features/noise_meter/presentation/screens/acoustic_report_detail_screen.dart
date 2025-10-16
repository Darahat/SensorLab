import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/report/hourly_breakdown_chart.dart';
import 'package:sensorlab/src/shared/widgets/common_cards.dart'
    hide EmptyStateWidget;
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

/// Acoustic Report Detail Screen - Shows comprehensive report with charts
class AcousticReportDetailScreen extends ConsumerWidget {
  final AcousticReport report;

  const AcousticReportDetailScreen({super.key, required this.report});

  // --- Helper method for formatting duration ---
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Acoustic Report'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.share),
            onPressed: () => _shareReport(context),
            tooltip: 'Share Report',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quality Score Card
              _buildQualityScoreCard(theme),
              const SizedBox(height: 24),

              // Statistics Grid
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Iconsax.chart,
                      label: 'Average',
                      value:
                          report.averageDecibels.isNaN ||
                              report.averageDecibels.isInfinite
                          ? '--'
                          : '${report.averageDecibels.toStringAsFixed(1)} dB',
                      color: _getDecibelColor(report.averageDecibels),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Iconsax.arrow_up,
                      label: 'Peak',
                      value:
                          report.maxDecibels == double.negativeInfinity ||
                              report.maxDecibels.isNaN
                          ? '--'
                          : '${report.maxDecibels.toStringAsFixed(1)} dB',
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Hourly Chart
              if (report.hourlyAverages.isNotEmpty) ...[
                HourlyBreakdownChart(hourlyAverages: report.hourlyAverages),
                const SizedBox(height: 24),
              ],

              // Events List
              _buildEventsSection(theme),
              const SizedBox(height: 24),

              // Recommendation
              _buildRecommendation(theme),
              const SizedBox(height: 24),

              // Session Info
              _buildSessionInfo(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQualityScoreCard(ThemeData theme) {
    final score = report.qualityScore;
    final color = _getQualityColor(score);
    final qualityLabel = _getQualityLabel(score);

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
              'Environment Quality',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // Circular quality indicator
            SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 16,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        score.toString(),
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        qualityLabel,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionInfo(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            InfoRow(
              icon: Iconsax.calendar,
              label: 'Date',
              value: _formatDate(report.startTime),
            ),
            const SizedBox(height: 12),
            InfoRow(
              icon: Iconsax.clock,
              label: 'Duration',
              value: _formatDuration(report.duration),
            ),
            const SizedBox(height: 12),
            InfoRow(
              icon: Iconsax.setting_2,
              label: 'Preset',
              value: _getPresetName(report.preset),
            ),
          ],
        ),
      ),
    );
  }

  void _shareReport(BuildContext context) {
    final avgValue =
        report.averageDecibels.isNaN || report.averageDecibels.isInfinite
        ? '--'
        : report.averageDecibels.toStringAsFixed(1);

    final peakValue =
        report.maxDecibels == double.negativeInfinity ||
            report.maxDecibels.isNaN
        ? '--'
        : report.maxDecibels.toStringAsFixed(1);

    final reportText =
        'Acoustic Environment Report\n\n'
        'Quality Score: ${report.qualityScore}/100 (${report.environmentQuality})\n'
        'Average: $avgValue dB\n'
        'Peak: $peakValue dB\n'
        'Events: ${report.interruptionCount}\n'
        'Duration: ${_formatDuration(report.duration)}\n\n'
        'Recommendation: ${report.recommendation}';

    Clipboard.setData(ClipboardData(text: reportText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report copied to clipboard!')),
    );
  }

  Widget _buildEventsSection(ThemeData theme) {
    if (report.events.isEmpty) {
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
                'No Interruptions Detected',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your environment was consistently quiet',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Noise Events',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${report.interruptionCount}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...report.events.map(
              (event) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getDecibelColor(event.peakDecibels),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${event.peakDecibels.toStringAsFixed(1)} dB',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _formatEventTime(event.timestamp),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendation(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.lamp_charge, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Recommendation',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              report.recommendation,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  String _formatEventTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  Color _getQualityColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.lightGreen;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getQualityLabel(int score) {
    if (score >= 80) return 'EXCELLENT';
    if (score >= 60) return 'GOOD';
    if (score >= 40) return 'FAIR';
    return 'POOR';
  }

  Color _getDecibelColor(double decibel) {
    if (decibel < 40) return Colors.green;
    if (decibel < 55) return Colors.lightGreen;
    if (decibel < 65) return Colors.orange;
    if (decibel < 75) return Colors.deepOrange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getPresetName(RecordingPreset preset) {
    switch (preset) {
      case RecordingPreset.sleep:
        return 'Sleep Analysis';
      case RecordingPreset.work:
        return 'Work Environment';
      case RecordingPreset.focus:
        return 'Focus Session';
      case RecordingPreset.custom:
        return 'Custom';
    }
  }
}
