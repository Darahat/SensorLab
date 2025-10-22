import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/utils/utils_index.dart';

class ReportStatistics extends StatelessWidget {
  final AcousticReport report;

  const ReportStatistics({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.keyStatistics,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // Make tiles a bit taller to avoid rare vertical overflow by ~11px on small heights
            childAspectRatio: 0.95,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _ModernStatCard(
                icon: Iconsax.chart,
                label: l10n.averageDecibels,
                value: ReportFormatters.formatDecibelValue(
                  report.averageDecibels,
                ),
                color: ReportFormatters.getDecibelColor(report.averageDecibels),
                trend: null,
              ),
              _ModernStatCard(
                icon: Iconsax.arrow_up,
                label: l10n.peakDecibels,
                value: ReportFormatters.formatDecibelValue(report.maxDecibels),
                color: Colors.red,
                trend: null,
              ),
              _ModernStatCard(
                icon: Iconsax.sound,
                label: l10n.noiseEvents,
                value: report.interruptionCount.toString(),
                color: report.interruptionCount > 5
                    ? Colors.orange
                    : Colors.green,
                trend: null,
              ),
              _ModernStatCard(
                icon: Iconsax.clock,
                label: l10n.duration,
                value: ReportFormatters.formatDuration(report.duration),
                color: theme.colorScheme.primary,
                trend: null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModernStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? trend;

  const _ModernStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        // Relax padding slightly to gain vertical room
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.2)),
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
                if (trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      trend!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  // Slightly smaller to prevent tight layouts from overflowing
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
