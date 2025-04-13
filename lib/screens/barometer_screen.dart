import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:math';
// import 'package:app_settings/app_settings.dart';

class BarometerScreen extends StatefulWidget {
  const BarometerScreen({super.key});

  @override
  State<BarometerScreen> createState() => _BarometerScreenState();
}

class _BarometerScreenState extends State<BarometerScreen> {
  double _pressure = 1013.25; // Default sea level pressure in hPa
  double _altitude = 0;
  bool _isLoading = true;
  bool _hasSensor = true;
  bool _permissionGranted = true;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndSensor();
  }

  Future<void> _checkPermissionsAndSensor() async {
    // Check location permissions (needed for altitude)
    final locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      final requestedPermission = await Geolocator.requestPermission();
      if (requestedPermission != LocationPermission.whileInUse &&
          requestedPermission != LocationPermission.always) {
        setState(() {
          _permissionGranted = false;
          _isLoading = false;
        });
        return;
      }
    }

    // Check if device has barometer (simulated check)
    // In a real app, you would use sensor_plus or similar to check
    final hasBarometer = await _checkBarometerAvailability();

    if (!hasBarometer) {
      setState(() {
        _hasSensor = false;
        _isLoading = false;
      });
      return;
    }

    // Get data if we have permission and sensor
    _getBarometricData();
  }

  Future<bool> _checkBarometerAvailability() async {
    // This is a simulation - in a real app you'd use:
    // await SensorManager().isSensorAvailable(Sensors.BAROMETER);
    // Using sensor_plus package or similar
    return true; // Assume true for this example
  }

  Future<void> _getBarometricData() async {
    try {
      // Simulate getting data (replace with actual sensor reading)
      final position = await Geolocator.getCurrentPosition();

      setState(() {
        // Simulate pressure based on altitude
        _pressure = 1013.25 * pow(1 - (position.altitude / 44330), 5.255);
        _altitude = position.altitude;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasSensor = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barometer'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _buildContent(colorScheme),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ColorScheme colorScheme) {
    if (!_permissionGranted) {
      return _buildPermissionDeniedView(colorScheme);
    }

    if (!_hasSensor) {
      return _buildNoSensorView(colorScheme);
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pressure Display
        Text(
          '${_pressure.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: _getPressureColor(_pressure, colorScheme),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'hPa',
          style: TextStyle(
            fontSize: 20,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 40),

        // Pressure Gauge
        _buildPressureGauge(colorScheme),
        const SizedBox(height: 40),

        // Altitude Card
        _buildAltitudeCard(colorScheme),
      ],
    );
  }

  Widget _buildPressureGauge(ColorScheme colorScheme) {
    final normalizedPressure = (_pressure - 950) / (1050 - 950);
    final color = _getPressureColor(_pressure, colorScheme);

    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Stack(
        children: [
          // Gauge background
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.secondaryContainer,
                  colorScheme.tertiaryContainer,
                  colorScheme.errorContainer,
                ],
              ),
            ),
          ),
          // Pressure indicator
          Positioned(
            left: normalizedPressure.clamp(0, 1) * 300 - 15,
            top: 10,
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Iconsax.arrow_down,
                    color: colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Container(width: 2, height: 70, color: color),
              ],
            ),
          ),
          // Labels
          Positioned(
            bottom: 10,
            left: 10,
            child: Text('950', style: TextStyle(color: colorScheme.primary)),
          ),
          Positioned(
            bottom: 10,
            left: 140,
            child: Text('1000', style: TextStyle(color: colorScheme.secondary)),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Text('1050', style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildAltitudeCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Iconsax.location, size: 32, color: colorScheme.primary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Altitude',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
              ),
              Text(
                '${_altitude.toStringAsFixed(2)} meters',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedView(ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Iconsax.warning_2, size: 60, color: colorScheme.error),
        const SizedBox(height: 20),
        Text(
          'Permission Required',
          style: TextStyle(
            fontSize: 18,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Location permission is needed to calculate atmospheric pressure',
          textAlign: TextAlign.center,
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNoSensorView(ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Iconsax.warning_2, size: 60, color: colorScheme.error),
        const SizedBox(height: 20),
        Text(
          'Barometer Not Available',
          style: TextStyle(
            fontSize: 18,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'This device doesn\'t have a barometer sensor',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
        ),
      ],
    );
  }

  Color _getPressureColor(double pressure, ColorScheme colorScheme) {
    if (pressure < 980) return colorScheme.primary;
    if (pressure < 1010) return colorScheme.secondary;
    if (pressure < 1030) return colorScheme.tertiary;
    return colorScheme.error;
  }
}
