import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/enhanced_noise_meter_provider.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/noise_meter_screen/noise_meter_screen_components.dart';
import 'package:sensorlab/src/features/noise_meter/utils/utils_index.dart'; // ← Single import

class NoiseMeterScreen extends ConsumerWidget {
  const NoiseMeterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noiseMeterData = ref.watch(enhancedNoiseMeterProvider);
    final noiseMeterNotifier = ref.read(enhancedNoiseMeterProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: _buildAppBar(context, l10n, noiseMeterNotifier),
      body: _buildBody(context, noiseMeterData, noiseMeterNotifier, l10n),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    AppLocalizations l10n,
    EnhancedNoiseMeterNotifier notifier,
  ) {
    return AppBar(
      title: Text(l10n.noiseMeter),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => notifier.stopRecording(),
          tooltip: l10n.resetData,
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    EnhancedNoiseMeterData noiseMeterData,
    EnhancedNoiseMeterNotifier notifier,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NoiseMeterComponents.buildPermissionSection(
              context,
              noiseMeterData,
              notifier,
              l10n,
            ),
            if (noiseMeterData.hasPermission) ...[
              const SizedBox(height: 16),
              NoiseMeterComponents.buildFeatureCardsSection(context),
              const SizedBox(height: 16),
              NoiseMeterComponents.buildCurrentReadingSection(
                context,
                noiseMeterData,
                notifier,
                l10n,
              ),
              const SizedBox(height: 16),
              NoiseMeterComponents.buildStatisticsSection(
                context,
                noiseMeterData,
                l10n,
              ),
              if (noiseMeterData.decibelHistory.isNotEmpty) ...[
                const SizedBox(height: 16),
                NoiseMeterComponents.buildChartSection(noiseMeterData),
              ],
              const SizedBox(height: 16),
              NoiseMeterComponents.buildNoiseGuideSection(l10n),
            ],
            if (noiseMeterData.errorMessage != null) ...[
              const SizedBox(height: 16),
              NoiseMeterComponents.buildErrorSection(noiseMeterData),
            ],
          ],
        ),
      ),
    );
  }
}
