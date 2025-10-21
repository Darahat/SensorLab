import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart';

class AcousticReportDetailScreen extends ConsumerWidget {
  final AcousticReport report;

  const AcousticReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.acousticReport),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(child: AcousticReportDetailContent(report: report)),
    );
  }
}
