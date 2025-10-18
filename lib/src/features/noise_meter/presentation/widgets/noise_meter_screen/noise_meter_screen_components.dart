import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/enhanced_noise_meter_provider.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/noise_meter_screen/noise_meter_chart_section.dart';

import '../../state/enhanced_noise_data.dart';
import 'noise_meter_current_reading.dart';
import 'noise_meter_error_section.dart';
import 'noise_meter_feature_cards.dart';
import 'noise_meter_guide_section.dart';
// Import all the individual component files
import 'noise_meter_permission_section.dart';
import 'noise_meter_statistics_section.dart';

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
