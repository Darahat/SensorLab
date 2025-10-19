import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_reports_list/acoustic_reports_list_content.dart';

class AcousticReportsListScreen extends ConsumerWidget {
  const AcousticReportsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const SafeArea(child: AcousticReportsListContent()),
    );
  }
}
