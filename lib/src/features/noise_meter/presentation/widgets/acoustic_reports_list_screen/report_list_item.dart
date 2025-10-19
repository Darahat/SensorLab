import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/acoustic_report_detail_screen.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart';

class ReportListItem extends StatelessWidget {
  final AcousticReport report;
  final bool isSelected;
  final bool isSelectionMode;
  final String? titleOverride;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ReportListItem({
    super.key,
    required this.report,
    required this.isSelected,
    required this.isSelectionMode,
    this.titleOverride,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Stack(
        children: [
          ReportSummaryCard(
            title:
                titleOverride ?? ReportFormatters.getPresetName(report.preset),
            date: ReportFormatters.formatListDate(context, report.startTime),
            avgDecibels: report.averageDecibels,
            qualityScore: report.qualityScore.toDouble(),
            eventCount: report.events.length,
            presetName: ReportFormatters.getPresetName(report.preset),
            onTap: () {
              if (isSelectionMode) {
                onTap();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AcousticReportDetailScreen(report: report),
                  ),
                );
              }
            },
          ),
          if (isSelectionMode)
            Positioned(
              top: 8,
              right: 8,
              child: _buildSelectionIndicator(context),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectionIndicator(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(4),
      child: Icon(
        isSelected ? Iconsax.tick_circle5 : Iconsax.record_circle,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
