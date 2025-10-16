import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

import '../../models/barometer_data.dart';
import '../providers/barometer_provider.dart';

class BarometerScreen extends ConsumerStatefulWidget {
  const BarometerScreen({super.key});

  @override
  ConsumerState<BarometerScreen> createState() => _BarometerScreenState();
}

class _BarometerScreenState extends ConsumerState<BarometerScreen> {
  // Pressure unit: 0 = hPa, 1 = inHg, 2 = mmHg
  int _selectedUnit = 0;

  @override
  Widget build(BuildContext context) {
    final barometerData = ref.watch(barometerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.barometer),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          // Unit toggle button
          PopupMenuButton<int>(
            icon: Icon(Iconsax.setting_2, color: colorScheme.primary),
            onSelected: (value) {
              setState(() {
                _selectedUnit = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(
                      _selectedUnit == 0 ? Icons.check : null,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('hPa / mb'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      _selectedUnit == 1 ? Icons.check : null,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('inHg'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(
                      _selectedUnit == 2 ? Icons.check : null,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('mmHg'),
                  ],
                ),
              ),
            ],
          ),
          // Reset button
          IconButton(
            icon: Icon(Iconsax.refresh, color: colorScheme.primary),
            onPressed: () => ref.read(barometerProvider.notifier).resetStats(),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Main Pressure Display
                _buildPressureGauge(colorScheme, barometerData),
                const SizedBox(height: 40),

                // Status Indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: barometerData.isActive
                        ? colorScheme.primary.withOpacity(0.1)
                        : colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: barometerData.isActive
                          ? colorScheme.primary
                          : colorScheme.outline.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    barometerData.isActive
                        ? l10n.active
                        : l10n.waitingForSensor,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: barometerData.isActive
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Weather Prediction
                _buildWeatherPrediction(colorScheme, barometerData, l10n),
                const SizedBox(height: 30),

                // Stats Grid
                _buildStatsGrid(colorScheme, barometerData, l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPressureGauge(ColorScheme colorScheme, BarometerData data) {
    final pressure = _getPressureValue(data);
    final unit = _getUnitString();
    final pressureFormatted = pressure.toStringAsFixed(
      _selectedUnit == 0 ? 2 : 2,
    );

    // Calculate pressure percentage for visual effect (950-1050 hPa range)
    final minPressure = _selectedUnit == 0
        ? 950.0
        : (_selectedUnit == 1 ? 28.0 : 710.0);
    final maxPressure = _selectedUnit == 0
        ? 1050.0
        : (_selectedUnit == 1 ? 31.0 : 790.0);
    final pressurePercentage =
        ((pressure - minPressure) / (maxPressure - minPressure)).clamp(
          0.0,
          1.0,
        );

    // Get color based on pressure
    Color pressureColor = colorScheme.primary;
    if (data.weatherTrend == WeatherTrend.high) {
      pressureColor = Colors.green;
    } else if (data.weatherTrend == WeatherTrend.low) {
      pressureColor = Colors.orange;
    }

    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [pressureColor.withOpacity(0.2), colorScheme.surfaceVariant],
        ),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.3),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: pressureColor.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pressure arc indicator
          CustomPaint(
            size: const Size(220, 220),
            painter: _PressureArcPainter(
              percentage: pressurePercentage,
              color: pressureColor,
            ),
          ),
          // Pressure value
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.cloud,
                size: 40,
                color: pressureColor.withOpacity(0.7),
              ),
              const SizedBox(height: 8),
              Text(
                pressureFormatted,
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: pressureColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withOpacity(0.6),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherPrediction(
    ColorScheme colorScheme,
    BarometerData data,
    AppLocalizations l10n,
  ) {
    String weatherText;
    IconData weatherIcon;
    Color weatherColor;

    switch (data.weatherTrend) {
      case WeatherTrend.high:
        weatherText = l10n.clearWeather;
        weatherIcon = Iconsax.sun_1;
        weatherColor = Colors.green;
        break;
      case WeatherTrend.low:
        weatherText = l10n.cloudyWeather;
        weatherIcon = Iconsax.cloud_drizzle;
        weatherColor = Colors.orange;
        break;
      case WeatherTrend.normal:
        weatherText = l10n.stableWeather;
        weatherIcon = Iconsax.cloud_sunny;
        weatherColor = Colors.blue;
        break;
    }

    // Get pressure trend
    final trend = ref.read(barometerProvider.notifier).getPressureTrend();
    String? trendText;
    IconData? trendIcon;

    if (trend != null) {
      switch (trend) {
        case PressureTrend.rising:
          trendText = l10n.pressureRising;
          trendIcon = Iconsax.arrow_up_2;
          break;
        case PressureTrend.falling:
          trendText = l10n.pressureFalling;
          trendIcon = Iconsax.arrow_down_1;
          break;
        case PressureTrend.steady:
          trendText = l10n.pressureSteady;
          trendIcon = Iconsax.minus;
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: weatherColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: weatherColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(weatherIcon, color: weatherColor, size: 32),
              const SizedBox(width: 12),
              Text(
                weatherText,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: weatherColor,
                ),
              ),
            ],
          ),
          if (trendText != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  trendIcon,
                  color: colorScheme.onSurface.withOpacity(0.7),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  trendText,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
    ColorScheme colorScheme,
    BarometerData data,
    AppLocalizations l10n,
  ) {
    final maxPressure = _getMaxPressure(
      data,
    ).toStringAsFixed(_selectedUnit == 0 ? 2 : 2);
    final minPressure = _getMinPressure(
      data,
    ).toStringAsFixed(_selectedUnit == 0 ? 2 : 2);
    final avgPressure = _getAvgPressure(
      data,
    ).toStringAsFixed(_selectedUnit == 0 ? 2 : 2);
    final altitude = data.altitudeFormatted;
    final unit = _getUnitString();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                colorScheme,
                l10n.maximum,
                maxPressure,
                unit,
                Iconsax.arrow_up_1,
                Colors.red,
              ),
              _buildStatItem(
                colorScheme,
                l10n.minimum,
                minPressure,
                unit,
                Iconsax.arrow_down_1,
                Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                colorScheme,
                l10n.average,
                avgPressure,
                unit,
                Iconsax.chart_1,
                Colors.green,
              ),
              _buildStatItem(
                colorScheme,
                l10n.altitude,
                altitude,
                'm',
                Iconsax.status_up,
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    ColorScheme colorScheme,
    String label,
    String value,
    String unit,
    IconData icon,
    Color accentColor,
  ) {
    return Column(
      children: [
        Icon(icon, color: accentColor, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  double _getPressureValue(BarometerData data) {
    switch (_selectedUnit) {
      case 1:
        return data.pressureInHg;
      case 2:
        return data.pressureMmHg;
      default:
        return data.pressure;
    }
  }

  double _getMaxPressure(BarometerData data) {
    switch (_selectedUnit) {
      case 1:
        return data.maxPressureInHg;
      case 2:
        return data.maxPressureMmHg;
      default:
        return data.maxPressure;
    }
  }

  double _getMinPressure(BarometerData data) {
    switch (_selectedUnit) {
      case 1:
        return data.minPressureInHg;
      case 2:
        return data.minPressureMmHg;
      default:
        return data.minPressureMb;
    }
  }

  double _getAvgPressure(BarometerData data) {
    switch (_selectedUnit) {
      case 1:
        return data.avgPressureInHg;
      case 2:
        return data.avgPressureMmHg;
      default:
        return data.avgPressure;
    }
  }

  String _getUnitString() {
    switch (_selectedUnit) {
      case 1:
        return 'inHg';
      case 2:
        return 'mmHg';
      default:
        return 'hPa';
    }
  }
}

// Custom painter for pressure arc
class _PressureArcPainter extends CustomPainter {
  final double percentage;
  final Color color;

  _PressureArcPainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background arc
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -225 * 3.14159 / 180, // Start angle
      270 * 3.14159 / 180, // Sweep angle
      false,
      backgroundPaint,
    );

    // Progress arc
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.5), color],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -225 * 3.14159 / 180, // Start angle
      270 * 3.14159 / 180 * percentage, // Sweep angle based on pressure
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_PressureArcPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
