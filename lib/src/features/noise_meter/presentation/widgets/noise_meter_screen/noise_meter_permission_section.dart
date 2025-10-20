import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/application/notifiers/enhanced_noise_meter_notifier.dart';
import 'package:sensorlab/src/features/noise_meter/application/state/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';

class NoiseMeterPermissionSection extends StatelessWidget {
  final EnhancedNoiseMeterData data;
  final EnhancedNoiseMeterNotifier notifier;
  final AppLocalizations l10n;

  const NoiseMeterPermissionSection({
    super.key,
    required this.data,
    required this.notifier,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    if (data.hasPermission) return const SizedBox.shrink();

    return Card(
      color: Colors.orange.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.mic_off, size: 48, color: Colors.orange),
            const SizedBox(height: 8),
            Text(
              l10n.permissionRequired,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Grant microphone permission to measure noise levels',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  notifier.startRecordingWithPreset(RecordingPreset.custom),
              child: Text(l10n.grantPermission),
            ),
          ],
        ),
      ),
    );
  }
}
