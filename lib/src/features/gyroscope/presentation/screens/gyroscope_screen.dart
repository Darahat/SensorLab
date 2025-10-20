import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

import '../providers/gyroscope_provider.dart';

class GyroscopeScreen extends ConsumerStatefulWidget {
  const GyroscopeScreen({super.key});

  @override
  ConsumerState<GyroscopeScreen> createState() => _GyroscopeScreenState();
}

class _GyroscopeScreenState extends ConsumerState<GyroscopeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  LineChartData _buildLineChart(
    List<FlSpot> xSpots,
    List<FlSpot> ySpots,
    List<FlSpot> zSpots,
  ) {
    return LineChartData(
      minY: -5,
      maxY: 5,
      titlesData: const FlTitlesData(show: false),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: xSpots,
          isCurved: true,
          color: Colors.red,
          dotData: const FlDotData(show: false),
        ),
        LineChartBarData(
          spots: ySpots,
          isCurved: true,
          color: Colors.green,
          dotData: const FlDotData(show: false),
        ),
        LineChartBarData(
          spots: zSpots,
          isCurved: true,
          color: Colors.blue,
          dotData: const FlDotData(show: false),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final gyroscopeData = ref.watch(gyroscopeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    // Trigger animation when data changes
    if (gyroscopeData.isActive) {
      _controller.forward(from: 0);
    }

    // Convert GyroscopePoint to FlSpot for chart
    final xSpots = gyroscopeData.xPoints
        .map((point) => FlSpot(point.time, point.value))
        .toList();
    final ySpots = gyroscopeData.yPoints
        .map((point) => FlSpot(point.time, point.value))
        .toList();
    final zSpots = gyroscopeData.zPoints
        .map((point) => FlSpot(point.time, point.value))
        .toList();

    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.gyroscope),
            centerTitle: true,
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            elevation: 0,
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Animated Circle
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..rotateX(
                                gyroscopeData.x * 0.1 * _controller.value,
                              )
                              ..rotateY(
                                gyroscopeData.y * 0.1 * _controller.value,
                              ),
                            alignment: Alignment.center,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    colorScheme.primaryContainer,
                                    colorScheme.primary,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                                border: Border.all(
                                  color: colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Iconsax.activity,
                                    size: 60,
                                    color: colorScheme.onPrimary,
                                  ),
                                  Positioned(
                                    top: 30,
                                    child: Text(
                                      'X: ${gyroscopeData.x.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 30,
                                    child: Text(
                                      'Y: ${gyroscopeData.y.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 30,
                                    child: Text(
                                      'Z: ${gyroscopeData.z.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      // Intensity Bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.motionIntensity,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: gyroscopeData.intensity.clamp(0.0, 1.0),
                            minHeight: 10,
                            backgroundColor: colorScheme.surfaceVariant
                                .withOpacity(0.4),
                            color: gyroscopeData.intensity > 0.5
                                ? Colors.red
                                : gyroscopeData.intensity > 0.2
                                ? Colors.orange
                                : Colors.green,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${(gyroscopeData.intensity * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Live Graph
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.liveSensorGraph,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 200,
                            child: LineChart(
                              _buildLineChart(xSpots, ySpots, zSpots),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Status Box
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: gyroscopeData.isActive
                              ? colorScheme.primary.withOpacity(0.1)
                              : colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: gyroscopeData.isActive
                                ? colorScheme.primary
                                : colorScheme.outline.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          gyroscopeData.isActive
                              ? l10n.active
                              : l10n.moveYourDevice,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: gyroscopeData.isActive
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.angularVelocity,
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
