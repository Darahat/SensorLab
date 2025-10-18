import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_report_detail/acoustic_report_detail_content.dart';

class AcousticReportDetailScreen extends ConsumerWidget {
  final AcousticReport report;

  const AcousticReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Acoustic Report'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(child: AcousticReportDetailContent(report: report)),
    );
  }
}
