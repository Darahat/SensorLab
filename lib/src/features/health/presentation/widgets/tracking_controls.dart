import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

class TrackingControls extends StatelessWidget {
  final bool isTracking;
  final VoidCallback onPressed;

  const TrackingControls({
    super.key,
    required this.isTracking,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: Icon(isTracking ? Icons.stop : Icons.play_arrow),
          label: Text(isTracking ? l10n.stopTracking : l10n.startTracking),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
