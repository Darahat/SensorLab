import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../src/core/providers.dart';

class HumidityScreen extends ConsumerStatefulWidget {
  const HumidityScreen({super.key});

  @override
  ConsumerState<HumidityScreen> createState() => _HumidityScreenState();
}

class _HumidityScreenState extends ConsumerState<HumidityScreen> {
  @override
  void initState() {
    super.initState();
    // Check sensor availability when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(humidityProvider.notifier).checkSensorAvailability();
    });
  }

  @override
  Widget build(BuildContext context) {
    final humidityData = ref.watch(humidityProvider);
    final humidityNotifier = ref.read(humidityProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Humidity'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => humidityNotifier.resetData(),
            tooltip: 'Reset Data',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sensor Status Card
            if (!humidityData.hasSensor)
              Card(
                color: Colors.orange.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.info, size: 48, color: Colors.orange),
                      const SizedBox(height: 8),
                      const Text(
                        'No Humidity Sensor Detected',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Most smartphones don\'t have humidity sensors. Showing simulated data for demonstration.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed:
                            () => humidityNotifier.checkSensorAvailability(),
                        child: const Text('Check Again'),
                      ),
                    ],
                  ),
                ),
              ),

            // Current Reading Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          humidityData.isReading
                              ? Icons.water_drop
                              : Icons.water_drop_outlined,
                          size: 32,
                          color:
                              humidityData.isReading
                                  ? Colors.blue
                                  : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          humidityData.isReading ? 'Measuring' : 'Stopped',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Current Humidity Display
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(
                          humidityData.humidityLevelColor,
                        ).withOpacity(0.2),
                        border: Border.all(
                          color: Color(humidityData.humidityLevelColor),
                          width: 4,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            humidityData.humidityLevelIcon,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            humidityData.formattedCurrentHumidity,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(humidityData.humidityLevelColor),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            humidityData.humidityLevelDescription,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(humidityData.humidityLevelColor),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => humidityNotifier.getSingleReading(),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Single Reading'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => humidityNotifier.toggleMeasurement(),
                          icon: Icon(
                            humidityData.isReading
                                ? Icons.stop
                                : Icons.play_arrow,
                          ),
                          label: Text(
                            humidityData.isReading ? 'Stop' : 'Continuous',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                humidityData.isReading
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

            // Comfort Assessment Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Comfort Assessment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(
                          humidityData.humidityLevelColor,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color(
                            humidityData.humidityLevelColor,
                          ).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            humidityData.humidityLevelIcon,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              humidityData.comfortAssessment,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(humidityData.humidityLevelColor),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Statistics Card (only show if we have session data)
            if (humidityData.totalReadings > 0) ...[
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
                              humidityData.formattedSessionDuration,
                              Icons.timer,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              'Readings',
                              '${humidityData.totalReadings}',
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
                              'Min',
                              humidityData.formattedMinHumidity,
                              Icons.keyboard_arrow_down,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              'Average',
                              humidityData.formattedAverageHumidity,
                              Icons.remove,
                              Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              'Max',
                              humidityData.formattedMaxHumidity,
                              Icons.keyboard_arrow_up,
                              Colors.red,
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

            // Real-time Chart (only show if we have data)
            if (humidityData.recentReadings.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Real-time Humidity Levels',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: true),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '${value.toInt()}%',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots:
                                    humidityData.recentReadings
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          return FlSpot(
                                            entry.key.toDouble(),
                                            entry.value,
                                          );
                                        })
                                        .toList(),
                                isCurved: true,
                                color: Color(humidityData.humidityLevelColor),
                                barWidth: 2,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Color(
                                    humidityData.humidityLevelColor,
                                  ).withOpacity(0.1),
                                ),
                              ),
                            ],
                            minY: 0,
                            maxY: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Humidity Level Guide
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Humidity Level Guide',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildHumidityGuideItem(
                      '🏜️',
                      'Very Dry',
                      '0-30%',
                      'May cause skin/respiratory irritation',
                      Colors.red,
                    ),
                    _buildHumidityGuideItem(
                      '🌵',
                      'Dry',
                      '30-40%',
                      'Somewhat dry, consider humidifier',
                      Colors.orange,
                    ),
                    _buildHumidityGuideItem(
                      '🌿',
                      'Comfortable',
                      '40-60%',
                      'Ideal humidity level',
                      Colors.green,
                    ),
                    _buildHumidityGuideItem(
                      '💧',
                      'Humid',
                      '60-70%',
                      'Somewhat humid, may feel sticky',
                      Colors.blue,
                    ),
                    _buildHumidityGuideItem(
                      '🌊',
                      'Very Humid',
                      '70%+',
                      'Too humid, may promote mold',
                      Colors.indigo,
                    ),
                  ],
                ),
              ),
            ),

            // Error Message
            if (humidityData.errorMessage != null)
              Card(
                color: Colors.orange.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.orange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          humidityData.errorMessage!,
                          style: const TextStyle(color: Colors.orange),
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

  Widget _buildHumidityGuideItem(
    String emoji,
    String level,
    String range,
    String description,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$level ($range)',
                  style: TextStyle(fontWeight: FontWeight.w500, color: color),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
