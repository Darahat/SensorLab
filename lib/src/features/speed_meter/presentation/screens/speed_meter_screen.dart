import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

import '../../models/speed_data.dart';
import '../providers/speed_meter_provider.dart';

class SpeedMeterScreen extends ConsumerStatefulWidget {
  const SpeedMeterScreen({super.key});

  @override
  ConsumerState<SpeedMeterScreen> createState() => _SpeedMeterScreenState();
}

class _SpeedMeterScreenState extends ConsumerState<SpeedMeterScreen> {
  bool _useKmh = true; // true for km/h, false for mph

  @override
  void initState() {
    super.initState();
    // Start tracking when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(speedMeterProvider.notifier).startTracking();
    });
  }

  @override
  void dispose() {
    // Stop tracking when screen is disposed
    ref.read(speedMeterProvider.notifier).stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final speedData = ref.watch(speedMeterProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.speedMeter),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          // Unit toggle button
          IconButton(
            icon: Text(
              _useKmh ? 'MPH' : 'KM/H',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            onPressed: () {
              setState(() {
                _useKmh = !_useKmh;
              });
            },
          ),
          // Reset button
          IconButton(
            icon: Icon(Iconsax.refresh, color: colorScheme.primary),
            onPressed: () => ref.read(speedMeterProvider.notifier).resetStats(),
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
                // Main Speed Display (Speedometer)
                _buildSpeedometer(colorScheme, speedData),
                const SizedBox(height: 40),

                // Status Indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: speedData.isActive
                        ? colorScheme.primary.withOpacity(0.1)
                        : colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: speedData.isActive
                          ? colorScheme.primary
                          : colorScheme.outline.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    speedData.isActive ? l10n.tracking : l10n.waitingForGps,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: speedData.isActive
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Stats Grid
                _buildStatsGrid(colorScheme, speedData, l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedometer(ColorScheme colorScheme, SpeedData data) {
    final currentSpeed = _useKmh ? data.speedKmh : data.speedMph;
    final speedFormatted = _useKmh
        ? data.speedKmhFormatted
        : data.speedMphFormatted;
    final unit = _useKmh ? 'km/h' : 'mph';

    // Calculate speed percentage for visual effect (0-200 km/h or 0-125 mph)
    final maxDisplaySpeed = _useKmh ? 200.0 : 125.0;
    final speedPercentage = (currentSpeed / maxDisplaySpeed).clamp(0.0, 1.0);

    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.3),
            colorScheme.surfaceVariant,
          ],
        ),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.3),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.2 * speedPercentage),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Speed arc indicator
          CustomPaint(
            size: const Size(220, 220),
            painter: _SpeedArcPainter(
              percentage: speedPercentage,
              color: colorScheme.primary,
            ),
          ),
          // Speed value
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                speedFormatted,
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 20,
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

  Widget _buildStatsGrid(
    ColorScheme colorScheme,
    SpeedData data,
    AppLocalizations l10n,
  ) {
    final maxSpeed = _useKmh
        ? data.maxSpeedKmhFormatted
        : data.maxSpeedMphFormatted;
    final avgSpeed = _useKmh
        ? data.avgSpeedKmhFormatted
        : data.avgSpeedMphFormatted;
    final distance = _useKmh
        ? data.distanceKmFormatted
        : data.distanceMilesFormatted;
    final distanceUnit = _useKmh ? 'km' : 'mi';
    final speedUnit = _useKmh ? 'km/h' : 'mph';

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
                l10n.maxSpeed,
                maxSpeed,
                speedUnit,
                Iconsax.arrow_up_1,
                Colors.red,
              ),
              _buildStatItem(
                colorScheme,
                l10n.avgSpeed,
                avgSpeed,
                speedUnit,
                Iconsax.chart_1,
                Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatItem(
            colorScheme,
            l10n.distance,
            distance,
            distanceUnit,
            Iconsax.routing_2,
            Colors.green,
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Custom painter for speed arc
class _SpeedArcPainter extends CustomPainter {
  final double percentage;
  final Color color;

  _SpeedArcPainter({required this.percentage, required this.color});

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
      270 * 3.14159 / 180 * percentage, // Sweep angle based on speed
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_SpeedArcPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
