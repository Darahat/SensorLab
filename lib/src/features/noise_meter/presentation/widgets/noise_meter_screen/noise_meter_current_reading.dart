import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/enhanced_noise_meter_provider.dart';
import 'package:sensorlab/src/features/noise_meter/utils/double_extensions.dart';
import 'package:sensorlab/src/features/noise_meter/utils/noise_formatters.dart';

import '../../../../../shared/widgets/utility_widgets.dart';
import '../../state/enhanced_noise_data.dart';

class NoiseMeterCurrentReading extends StatelessWidget {
  final EnhancedNoiseMeterData data;
  final EnhancedNoiseMeterNotifier notifier;
  final AppLocalizations l10n;

  const NoiseMeterCurrentReading({
    super.key,
    required this.data,
    required this.notifier,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final noiseColor = NoiseFormatters.getNoiseLevelColor(data.noiseLevel);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Compact header with status and control button
            _buildCompactHeader(noiseColor),
            const SizedBox(height: 16),
            // Compact decibel display
            _buildCompactDecibelDisplay(noiseColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactHeader(Color noiseColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Status indicator
        Row(
          children: [
            Icon(
              data.isRecording ? Icons.mic : Icons.mic_off,
              size: 20,
              color: data.isRecording ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              data.isRecording ? l10n.measuring : l10n.stopped,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),

        // Control button - smaller version
        _buildCompactControlButton(noiseColor),
      ],
    );
  }

  Widget _buildCompactControlButton(Color noiseColor) {
    return ActionButton.compact(
      icon: data.isRecording ? Icons.stop : Icons.play_arrow,
      label: data.isRecording ? l10n.stop : l10n.start,
      onPressed: () {
        if (data.isRecording) {
          notifier.stopRecording();
        } else {
          notifier.startRecordingWithPreset(RecordingPreset.custom);
        }
      },
      color: data.isRecording
          ? Colors.red
          : const Color.fromARGB(255, 11, 5, 63),
    );
  }

  Widget _buildCompactDecibelDisplay(Color noiseColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: noiseColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: noiseColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Current reading
          _buildReadingColumn(
            title: 'Current',
            value: data.currentDecibels.toDecibelString(),
            color: noiseColor,
            icon: Icons.speed,
          ),

          // Vertical divider
          Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),

          // Noise level
          _buildReadingColumn(
            title: 'Level',
            value: _getShortLevelDescription(data.noiseLevel),
            color: noiseColor,
            icon: Icons.volume_up,
          ),

          // Vertical divider
          Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),

          // Average
          _buildReadingColumn(
            title: 'Avg',
            value: data.averageDecibels.toStringAsFixed(1),
            color: Colors.orange,
            icon: Icons.timeline,
          ),
        ],
      ),
    );
  }

  Widget _buildReadingColumn({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color.withOpacity(0.7)),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _getShortLevelDescription(NoiseLevel level) {
    switch (level) {
      case NoiseLevel.quiet:
        return 'Quiet';
      case NoiseLevel.moderate:
        return 'Moderate';
      case NoiseLevel.loud:
        return 'Loud';
      case NoiseLevel.veryLoud:
        return 'Very Loud';
      case NoiseLevel.dangerous:
        return 'Dangerous';
    }
  }
}
