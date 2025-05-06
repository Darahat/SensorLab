import 'package:flutter/material.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: Icon(isTracking ? Icons.stop : Icons.play_arrow),
          label: Text(isTracking ? 'STOP TRACKING' : 'START TRACKING'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
