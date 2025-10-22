import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GpsDisplayWidget extends ConsumerWidget {
  const GpsDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // GPS data is not directly graphed as a time series of doubles
    // We can still watch the provider if we want to display some aspect of it
    // For now, it remains a placeholder.
    // final dataPoints = ref.watch(sensorTimeSeriesProvider(SensorType.gps));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'GPS Location',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Tracking location data...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
