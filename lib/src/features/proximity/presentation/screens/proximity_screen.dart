import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';

class ProximityScreen extends ConsumerStatefulWidget {
  const ProximityScreen({super.key});

  @override
  ConsumerState<ProximityScreen> createState() => _ProximityScreenState();
}

class _ProximityScreenState extends ConsumerState<ProximityScreen> {
  @override
  void initState() {
    super.initState();
    // Check permissions when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(proximityProvider.notifier).checkPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final proximityData = ref.watch(proximityProvider);
    final proximityNotifier = ref.read(proximityProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proximity Sensor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => proximityNotifier.resetData(),
            tooltip: 'Reset Data',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Permission/Sensor Status
            if (!proximityData.hasPermission || !proximityData.hasSensor) ...[
              Card(
                color:
                    (!proximityData.hasPermission ? Colors.red : Colors.orange)
                        .shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        !proximityData.hasPermission
                            ? Icons.security
                            : Icons.sensors_off,
                        size: 48,
                        color: !proximityData.hasPermission
                            ? Colors.red
                            : Colors.orange,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        !proximityData.hasPermission
                            ? 'Permission Required'
                            : 'Sensor Not Available',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        !proximityData.hasPermission
                            ? 'Grant sensor permission to access proximity sensor'
                            : 'Device does not have a proximity sensor',
                        textAlign: TextAlign.center,
                      ),
                      if (!proximityData.hasPermission) ...[
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => proximityNotifier.checkPermissions(),
                          child: const Text('Grant Permission'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Current Reading Card
            if (proximityData.hasPermission && proximityData.hasSensor) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            proximityData.isReading
                                ? Icons.sensors
                                : Icons.sensors_off,
                            size: 32,
                            color: proximityData.isReading
                                ? Colors.green
                                : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            proximityData.isReading ? 'Active' : 'Inactive',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Current Proximity State Display
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(
                            proximityData.proximityStateColor,
                          ).withOpacity(0.2),
                          border: Border.all(
                            color: Color(proximityData.proximityStateColor),
                            width: 4,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              proximityData.proximityStateIcon,
                              style: const TextStyle(fontSize: 48),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              proximityData.formattedDistance,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(proximityData.proximityStateColor),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              proximityData.proximityStateDescription,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(proximityData.proximityStateColor),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Control Buttons
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () =>
                                proximityNotifier.getSingleReading(),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Single Reading'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),

                          ElevatedButton.icon(
                            onPressed: () =>
                                proximityNotifier.toggleMeasurement(),
                            icon: Icon(
                              proximityData.isReading
                                  ? Icons.stop
                                  : Icons.play_arrow,
                            ),
                            label: Text(
                              proximityData.isReading ? 'Stop' : 'Monitor',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: proximityData.isReading
                                  ? Colors.red
                                  : Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Statistics Card (only show if we have session data)
              if (proximityData.totalReadings > 0) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Session Statistics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Duration',
                                proximityData.formattedSessionDuration,
                                Icons.timer,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildStatCard(
                                'Total Readings',
                                '${proximityData.totalReadings}',
                                Icons.analytics,
                                Colors.purple,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Near',
                                '${proximityData.nearDetections}',
                                Icons.warning,
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildStatCard(
                                'Near %',
                                proximityData.nearDetectionPercentage,
                                Icons.pie_chart,
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildStatCard(
                                'Far',
                                '${proximityData.farDetections}',
                                Icons.check_circle,
                                Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],

              // Real-time Activity Chart (only show if we have data)
              if (proximityData.recentReadings.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Proximity Activity Timeline',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            itemCount: proximityData.recentReadings.length,
                            itemBuilder: (context, index) {
                              final reading =
                                  proximityData.recentReadings[proximityData
                                          .recentReadings
                                          .length -
                                      1 -
                                      index];
                              return Container(
                                width: 4,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: reading.isNear
                                      ? Colors.orange
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Near',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Far',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Proximity Guide
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'How Proximity Sensor Works',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildProximityGuideItem(
                        '🔴',
                        'Near Detection',
                        'Object detected close to sensor',
                        'Usually when something is within 5cm of the sensor',
                        Colors.orange,
                      ),
                      _buildProximityGuideItem(
                        '🟢',
                        'Far Detection',
                        'No object detected nearby',
                        'Clear area around the proximity sensor',
                        Colors.green,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info, color: Colors.blue),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'The proximity sensor is typically located near the earpiece and is used to turn off the screen during phone calls.',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Error Message
            if (proximityData.errorMessage != null)
              Card(
                color: Colors.red.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          proximityData.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
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
      ),
    );
  }

  Widget _buildProximityGuideItem(
    String emoji,
    String title,
    String description,
    String details,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: color,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  details,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
