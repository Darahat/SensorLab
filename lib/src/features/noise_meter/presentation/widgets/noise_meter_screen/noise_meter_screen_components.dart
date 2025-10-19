import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/enhanced_noise_meter_provider.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart';

import '../../state/enhanced_noise_data.dart';

class NoiseMeterComponents {
  static Widget buildPermissionSection(
    BuildContext context,
    EnhancedNoiseMeterData data,
    EnhancedNoiseMeterNotifier notifier,
    AppLocalizations l10n,
  ) => NoiseMeterPermissionSection(data: data, notifier: notifier, l10n: l10n);

  static Widget buildFeatureCardsSection(BuildContext context) =>
      const NoiseMeterFeatureCards();

  static Widget buildCurrentReadingSection(
    BuildContext context,
    EnhancedNoiseMeterData data,
    EnhancedNoiseMeterNotifier notifier,
    AppLocalizations l10n,
  ) => NoiseMeterCurrentReading(data: data, notifier: notifier, l10n: l10n);

  static Widget buildStatisticsSection(
    BuildContext context,
    EnhancedNoiseMeterData data,
    AppLocalizations l10n,
  ) => NoiseMeterStatisticsSection(data: data, l10n: l10n);

  static Widget buildChartSection(EnhancedNoiseMeterData data) =>
      NoiseMeterChartSection(data: data);

  static Widget buildNoiseGuideSection(AppLocalizations l10n) =>
      NoiseMeterGuideSection(l10n: l10n);

  static Widget buildErrorSection(EnhancedNoiseMeterData data) =>
      NoiseMeterErrorSection(data: data);
}
