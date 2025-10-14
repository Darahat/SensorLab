import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

import '../../models/altimeter_data.dart';
import '../providers/altimeter_provider.dart';

class AltimeterScreen extends ConsumerStatefulWidget {
  const AltimeterScreen({super.key});

  @override
  ConsumerState<AltimeterScreen> createState() => _AltimeterScreenState();
}

class _AltimeterScreenState extends ConsumerState<AltimeterScreen> {
  bool _useFeet = false; // true for feet, false for meters

  @override
  Widget build(BuildContext context) {
    final altimeterData = ref.watch(altimeterProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.altimeter),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          // Unit toggle
          IconButton(
            icon: Text(
              _useFeet ? 'M' : 'FT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            onPressed: () {
              setState(() {
                _useFeet = !_useFeet;
              });
            },
          ),
          // Calibrate
          IconButton(
            icon: Icon(Iconsax.setting_2, color: colorScheme.primary),
            onPressed: () => _showCalibrateDialog(context),
          ),
          // Reset stats
          IconButton(
            icon: Icon(Iconsax.refresh, color: colorScheme.primary),
            onPressed: () {
              ref.read(altimeterProvider.notifier).resetStats();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.statsReset)));
            },
          ),
        ],
      ),
      body: altimeterData.isActive
          ? _buildAltimeterView(colorScheme, altimeterData, l10n)
          : _buildWaitingView(colorScheme, l10n),
    );
  }

  Widget _buildWaitingView(ColorScheme colorScheme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.location,
            size: 80,
            color: colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.waitingForSensor,
            style: TextStyle(
              fontSize: 18,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.altimeterWaiting,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 32),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildAltimeterView(
    ColorScheme colorScheme,
    AltimeterData data,
    AppLocalizations l10n,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Main Altitude Display
              _buildMainAltitude(colorScheme, data, l10n),
              const SizedBox(height: 24),

              // Vertical Speed Indicator
              _buildVerticalSpeed(colorScheme, data, l10n),
              const SizedBox(height: 24),

              // Source Information
              _buildSourceInfo(colorScheme, data, l10n),
              const SizedBox(height: 24),

              // Sensor Readings Grid
              _buildSensorReadings(colorScheme, data, l10n),
              const SizedBox(height: 24),

              // Statistics Grid
              _buildStatistics(colorScheme, data, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainAltitude(
    ColorScheme colorScheme,
    AltimeterData data,
    AppLocalizations l10n,
  ) {
    final altitude = _useFeet ? data.altitudeFeet : data.altitudeFormatted;
    final unit = _useFeet ? 'ft' : 'm';

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Iconsax.arrow_up_3, size: 48, color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            l10n.altitude,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onPrimaryContainer.withOpacity(0.7),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                altitude,
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 8),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.aboveSeaLevel,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onPrimaryContainer.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalSpeed(
    ColorScheme colorScheme,
    AltimeterData data,
    AppLocalizations l10n,
  ) {
    final speed = _useFeet
        ? data.verticalSpeedFpm
        : data.verticalSpeedFormatted;
    final unit = _useFeet ? 'ft/min' : 'm/s';
    final isClimbing = data.verticalSpeed > 0.1;
    final isDescending = data.verticalSpeed < -0.1;

    Color speedColor;
    IconData speedIcon;
    String speedText;

    if (isClimbing) {
      speedColor = Colors.green;
      speedIcon = Iconsax.arrow_up_3;
      speedText = l10n.climbing;
    } else if (isDescending) {
      speedColor = Colors.red;
      speedIcon = Iconsax.arrow_down;
      speedText = l10n.descending;
    } else {
      speedColor = Colors.grey;
      speedIcon = Iconsax.minus;
      speedText = l10n.stable;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: speedColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: speedColor.withOpacity(0.3), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: speedColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(speedIcon, color: speedColor, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  speedText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: speedColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.verticalSpeed >= 0 ? '+' : ''}$speed $unit',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceInfo(
    ColorScheme colorScheme,
    AltimeterData data,
    AppLocalizations l10n,
  ) {
    Color sourceColor;
    String sourceDescription;

    switch (data.primarySource) {
      case AltitudeSource.gps:
        sourceColor = Colors.blue;
        sourceDescription = l10n.usingGpsOnly;
        break;
      case AltitudeSource.barometer:
        sourceColor = Colors.orange;
        sourceDescription = l10n.usingBarometerOnly;
        break;
      case AltitudeSource.fused:
        sourceColor = Colors.purple;
        sourceDescription = l10n.usingFusedData;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Iconsax.cpu, color: sourceColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dataSource,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.sourceDisplayName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: sourceColor,
                  ),
                ),
                Text(
                  sourceDescription,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          if (data.primarySource == AltitudeSource.gps ||
              data.primarySource == AltitudeSource.fused) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getAccuracyColor(data.accuracyLevel).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getAccuracyColor(data.accuracyLevel).withOpacity(0.5),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    data.accuracyLevel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getAccuracyColor(data.accuracyLevel),
                    ),
                  ),
                  Text(
                    '±${data.accuracyFormatted}m',
                    style: TextStyle(
                      fontSize: 9,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSensorReadings(
    ColorScheme colorScheme,
    AltimeterData data,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.sensorReadings,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSensorValue(
                colorScheme,
                l10n.gpsAltitude,
                _useFeet
                    ? (data.gpsAltitude * 3.28084).toStringAsFixed(0)
                    : data.gpsAltitudeFormatted,
                _useFeet ? 'ft' : 'm',
                Iconsax.gps,
                Colors.blue,
              ),
              _buildSensorValue(
                colorScheme,
                l10n.baroAltitude,
                _useFeet
                    ? (data.barometerAltitude * 3.28084).toStringAsFixed(0)
                    : data.barometerAltitudeFormatted,
                _useFeet ? 'ft' : 'm',
                Iconsax.chart_21,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: _buildSensorValue(
              colorScheme,
              l10n.pressure,
              data.pressureFormatted,
              'hPa',
              Iconsax.wind,
              Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorValue(
    ColorScheme colorScheme,
    String label,
    String value,
    String unit,
    IconData icon,
    Color accentColor,
  ) {
    return Column(
      children: [
        Icon(icon, color: accentColor, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withOpacity(0.6),
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
                  fontSize: 11,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatistics(
    ColorScheme colorScheme,
    AltimeterData data,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statistics,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                colorScheme,
                l10n.maximum,
                _useFeet
                    ? (double.parse(data.maxAltitudeFormatted) * 3.28084)
                          .toStringAsFixed(0)
                    : data.maxAltitudeFormatted,
                _useFeet ? 'ft' : 'm',
                Iconsax.arrow_up_3,
                Colors.green,
              ),
              _buildStatItem(
                colorScheme,
                l10n.average,
                _useFeet
                    ? (double.parse(data.avgAltitudeFormatted) * 3.28084)
                          .toStringAsFixed(0)
                    : data.avgAltitudeFormatted,
                _useFeet ? 'ft' : 'm',
                Iconsax.minus,
                Colors.blue,
              ),
              _buildStatItem(
                colorScheme,
                l10n.minimum,
                _useFeet
                    ? (double.parse(data.minAltitudeFormatted) * 3.28084)
                          .toStringAsFixed(0)
                    : data.minAltitudeFormatted,
                _useFeet ? 'ft' : 'm',
                Iconsax.arrow_down,
                Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                colorScheme,
                l10n.gain,
                _useFeet
                    ? (data.altitudeGain * 3.28084).toStringAsFixed(0)
                    : data.altitudeGainFormatted,
                _useFeet ? 'ft' : 'm',
                Iconsax.trend_up,
                Colors.purple,
              ),
              _buildStatItem(
                colorScheme,
                l10n.loss,
                _useFeet
                    ? (data.altitudeLoss * 3.28084).toStringAsFixed(0)
                    : data.altitudeLossFormatted,
                _useFeet ? 'ft' : 'm',
                Iconsax.trend_down,
                Colors.orange,
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
        Icon(icon, color: accentColor, size: 20),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withOpacity(0.6),
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getAccuracyColor(String level) {
    switch (level) {
      case 'Excellent':
        return Colors.green;
      case 'Good':
        return Colors.blue;
      case 'Fair':
        return Colors.orange;
      case 'Poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showCalibrateDialog(BuildContext context) {
    final controller = TextEditingController();
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.calibrateAltimeter),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.calibrateDescription,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.knownAltitude,
                suffixText: 'm',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final altitude = double.tryParse(controller.text);
              if (altitude != null) {
                ref.read(altimeterProvider.notifier).calibrate(altitude);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.calibrationComplete)),
                );
              }
            },
            child: Text(l10n.calibrate),
          ),
        ],
      ),
    );
  }
}
