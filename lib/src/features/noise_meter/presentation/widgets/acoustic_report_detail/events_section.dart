import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/utils/utils_index.dart';

class EventsSection extends StatelessWidget {
  final AcousticReport report;

  const EventsSection({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (report.events.isEmpty) {
      return _buildNoEventsCard(theme, l10n);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme, l10n),
          const Divider(height: 1),
          _buildTimelineList(theme),
        ],
      ),
    );
  }

  Widget _buildNoEventsCard(ThemeData theme, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.green.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: const Icon(
                Iconsax.tick_circle,
                size: 28,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noInterruptionsDetected,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.environmentConsistentlyQuiet,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: const Icon(
                  Iconsax.sound,
                  size: 18,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.noiseEvents,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Text(
              report.interruptionCount.toString(),
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineList(ThemeData theme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: report.events.length > 10 ? 10 : report.events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final event = report.events[index];
        final color = ReportFormatters.getDecibelColor(event.peakDecibels);
        final isFirst = index == 0;
        final isLast = index == report.events.length - 1 || index == 9;

        return _TimelineEventItem(
          event: event,
          color: color,
          isFirst: isFirst,
          isLast: isLast,
          theme: theme,
        );
      },
    );
  }
}

class _TimelineEventItem extends StatelessWidget {
  final AcousticEvent event;
  final Color color;
  final bool isFirst;
  final bool isLast;
  final ThemeData theme;

  const _TimelineEventItem({
    required this.event,
    required this.color,
    required this.isFirst,
    required this.isLast,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 40,
            child: Column(
              children: [
                if (!isFirst)
                  Container(
                    width: 2,
                    height: 8,
                    color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                  ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Event content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.2), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${event.peakDecibels.toStringAsFixed(1)} dB',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getEventLevel(event.peakDecibels),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Iconsax.clock,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        ReportFormatters.formatEventTime(event.timestamp),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getEventLevel(double decibels) {
    if (decibels < 40) {
      return 'QUIET';
    }
    if (decibels < 60) {
      return 'MODERATE';
    }
    if (decibels < 80) {
      return 'LOUD';
    }
    return 'VERY LOUD';
  }
}
