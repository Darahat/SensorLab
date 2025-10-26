import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/providers.dart';

class GpsDisplayWidget extends ConsumerWidget {
  const GpsDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gpsData = ref.watch(geolocatorProvider);

    Widget content;
    if (gpsData.isLoadingLocation) {
      content = const CircularProgressIndicator();
    } else if (gpsData.errorMessage != null) {
      content = Text(
        'Error: ${gpsData.errorMessage}',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      );
    } else if (gpsData.currentLocation == null) {
      content = Text(
        'No location data available.',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    } else {
      if (gpsData.isLoadingAddress) {
        content = Text(
          'Finding address...',
          style: Theme.of(context).textTheme.bodyMedium,
        );
      } else if (gpsData.currentAddress != null) {
        content = Text(
          gpsData.currentAddress!.fullAddress,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        );
      } else {
        content = Text(
          'Lat: ${gpsData.currentLocation!.latitude.toStringAsFixed(6)}, Lon: ${gpsData.currentLocation!.longitude.toStringAsFixed(6)}',
          style: Theme.of(context).textTheme.bodyMedium,
        );
      }
    }

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
            content,
          ],
        ),
      ),
    );
  }
}
