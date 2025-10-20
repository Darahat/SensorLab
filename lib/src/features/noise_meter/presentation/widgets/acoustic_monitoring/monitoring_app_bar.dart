import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/application/notifiers/enhanced_noise_meter_notifier.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart';
import 'package:sensorlab/src/features/noise_meter/utils/utils_index.dart';

class MonitoringAppBar extends StatelessWidget implements PreferredSizeWidget {
  final RecordingPreset preset;
  final CustomPresetConfig? customConfig;
  final EnhancedNoiseMeterData state;
  final EnhancedNoiseMeterNotifier notifier;

  const MonitoringAppBar({
    super.key,
    required this.preset,
    this.customConfig,
    required this.state,
    required this.notifier,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      title: Text(
        MonitoringFormatters.getPresetTitle(l10n, preset, customConfig),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        if (state.isRecording)
          IconButton(
            icon: const Icon(Iconsax.pause_circle),
            onPressed: () => _onStopPressed(context),
            tooltip: l10n.stopRecordingTooltip,
          ),
      ],
    );
  }

  Future<void> _onStopPressed(BuildContext context) async {
    final shouldStop = await StopRecordingDialog.show(context);
    if (shouldStop) {
      notifier.stopRecording();
    }
  }
}
