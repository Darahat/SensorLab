import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

import '../../models/vibration_data.dart';
import '../providers/vibration_meter_provider.dart';

class VibrationMeterScreen extends ConsumerWidget {
  const VibrationMeterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vibrationData = ref.watch(vibrationMeterProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.vibrationMeter),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          // Reset stats
          IconButton(
            icon: Icon(Iconsax.refresh, color: colorScheme.primary),
            onPressed: () {
              ref.read(vibrationMeterProvider.notifier).resetStats();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.statsReset)));
            },
          ),
        ],
      ),
      body: vibrationData.isActive
          ? _buildVibrationView(context, colorScheme, vibrationData, l10n)
          : _buildWaitingView(colorScheme, l10n),
    );
  }

  Widget _buildWaitingView(ColorScheme colorScheme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.activity,
            size: 80,
            color: colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.waitingForSensor,
            style: TextStyle(
              fontSize: 18,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.vibrationWaiting,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 32),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildVibrationView(
    BuildContext context,
    ColorScheme colorScheme,
    VibrationData data,
    AppLocalizations l10n,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Main Magnitude Display
              _buildMagnitudeDisplay(colorScheme, data, l10n),
              const SizedBox(height: 24),

              // Vibration Level Indicator
              _buildLevelIndicator(colorScheme, data, l10n),
              const SizedBox(height: 24),

              // Real-time Waveform
              _buildWaveform(colorScheme, data, l10n),
              const SizedBox(height: 24),

              // Pattern and Frequency Info
              _buildPatternInfo(colorScheme, data, l10n),
              const SizedBox(height: 24),

              // Axis Breakdown
              _buildAxisBreakdown(colorScheme, data, l10n),
              const SizedBox(height: 24),

              // Advanced Metrics
              _buildAdvancedMetrics(colorScheme, data, l10n),
              const SizedBox(height: 24),

              // Statistics
              _buildStatistics(colorScheme, data, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMagnitudeDisplay(
    ColorScheme colorScheme,
    VibrationData data,
    AppLocalizations l10n,
  ) {
    final levelColor = _getLevelColor(data.level);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [levelColor.withOpacity(0.2), colorScheme.surfaceVariant],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: levelColor.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: levelColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Iconsax.activity, size: 48, color: levelColor),
          const SizedBox(height: 16),
          Text(
            l10n.vibrationMagnitude,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.7),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.magnitudeFormatted,
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: levelColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 8),
                child: Text(
                  'm/s²',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            data.severityDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelIndicator(
    ColorScheme colorScheme,
    VibrationData data,
    AppLocalizations l10n,
  ) {
    const levels = VibrationLevel.values;
    final currentIndex = levels.indexOf(data.level);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            l10n.vibrationLevel,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(
              levels.length,
              (index) => Expanded(
                child: Container(
                  height: 8,
                  margin: EdgeInsets.only(
                    right: index < levels.length - 1 ? 4 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: index <= currentIndex
                        ? _getLevelColor(levels[index])
                        : colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.horizontal(
                      left: index == 0 ? const Radius.circular(4) : Radius.zero,
                      right: index == levels.length - 1
                          ? const Radius.circular(4)
                          : Radius.zero,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                levels.first.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Text(
                data.levelName.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getLevelColor(data.level),
                ),
              ),
              Text(
                levels.last.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform(
    ColorScheme colorScheme,
    VibrationData data,
    AppLocalizations l10n,
  ) {
    if (data.magnitudeHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.realtimeWaveform,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: 0.5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: colorScheme.outline.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: data.maxMagnitude > 0 ? data.maxMagnitude * 1.2 : 1,
                lineBarsData: [
                  LineChartBarData(
                    spots: data.magnitudeHistory
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    color: _getLevelColor(data.level),
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: _getLevelColor(data.level).withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternInfo(
    ColorScheme colorScheme,
    VibrationData data,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoCard(
              colorScheme,
              l10n.pattern,
              data.patternName,
              Iconsax.chart_21,
              Colors.purple,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildInfoCard(
              colorScheme,
              l10n.frequency,
              '${data.frequencyFormatted} Hz',
              Iconsax.flash_circle,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    ColorScheme colorScheme,
    String label,
    String value,
    IconData icon,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: accentColor, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAxisBreakdown(
    ColorScheme colorScheme,
    VibrationData data,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.axisBreakdown,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildAxisBar(
            colorScheme,
            'X',
            data.xFormatted,
            data.x.abs(),
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildAxisBar(
            colorScheme,
            'Y',
            data.yFormatted,
            data.y.abs(),
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildAxisBar(
            colorScheme,
            'Z',
            data.zFormatted,
            data.z.abs(),
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildAxisBar(
    ColorScheme colorScheme,
    String axis,
    String value,
    double magnitude,
    Color color,
  ) {
    const maxAccel = 20.0; // Max expected acceleration
    final percentage = (magnitude / maxAccel).clamp(0.0, 1.0);

    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(
            axis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 60,
          child: Text(
            '$value m/s²',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedMetrics(
    ColorScheme colorScheme,
    VibrationData data,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.advancedMetrics,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricValue(
                colorScheme,
                l10n.rms,
                data.rmsFormatted,
                'm/s²',
                Iconsax.chart_1,
                Colors.teal,
              ),
              _buildMetricValue(
                colorScheme,
                l10n.peakToPeak,
                data.peakToPeakFormatted,
                'm/s²',
                Iconsax.activity,
                Colors.indigo,
              ),
              _buildMetricValue(
                colorScheme,
                l10n.crestFactor,
                data.crestFactorFormatted,
                '',
                Iconsax.graph,
                Colors.pink,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.info_circle, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data.applicationHint,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricValue(
    ColorScheme colorScheme,
    String label,
    String value,
    String unit,
    IconData icon,
    Color accentColor,
  ) {
    return Column(
      children: [
        Icon(icon, color: accentColor, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStatistics(
    ColorScheme colorScheme,
    VibrationData data,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statistics,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                colorScheme,
                l10n.maximum,
                data.maxMagnitudeFormatted,
                'm/s²',
                Iconsax.arrow_up_3,
                Colors.red,
              ),
              _buildStatItem(
                colorScheme,
                l10n.average,
                data.avgMagnitudeFormatted,
                'm/s²',
                Iconsax.minus,
                Colors.blue,
              ),
              _buildStatItem(
                colorScheme,
                l10n.minimum,
                data.minMagnitudeFormatted,
                'm/s²',
                Iconsax.arrow_down,
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    ColorScheme colorScheme,
    String label,
    String value,
    String unit,
    IconData icon,
    Color accentColor,
  ) {
    return Column(
      children: [
        Icon(icon, color: accentColor, size: 20),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getLevelColor(VibrationLevel level) {
    switch (level) {
      case VibrationLevel.none:
        return Colors.grey;
      case VibrationLevel.minimal:
        return Colors.green;
      case VibrationLevel.light:
        return Colors.lightGreen;
      case VibrationLevel.moderate:
        return Colors.yellow;
      case VibrationLevel.strong:
        return Colors.orange;
      case VibrationLevel.severe:
        return Colors.red;
      case VibrationLevel.extreme:
        return Colors.purple;
    }
  }
}
