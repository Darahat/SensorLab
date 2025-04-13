import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class ProximityScreen extends StatefulWidget {
  const ProximityScreen({super.key});

  @override
  State<ProximityScreen> createState() => _ProximityScreenState();
}

class _ProximityScreenState extends State<ProximityScreen> {
  bool _isNear = false;
  bool _hasSensor = true;
  bool _permissionGranted = false;
  late StreamSubscription<dynamic> _proximitySubscription;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    // Check if we have permission
    var status = await Permission.sensors.status;

    if (!status.isGranted) {
      // Request permission if not granted
      status = await Permission.sensors.request();
    }

    if (status.isGranted) {
      setState(() => _permissionGranted = true);
      _initProximitySensor();
    } else {
      setState(() => _permissionGranted = false);
    }
  }

  Future<void> _initProximitySensor() async {
    try {
      _proximitySubscription = ProximitySensor.events.listen((int event) {
        if (mounted) {
          setState(() {
            _isNear = event > 0; // 1 or higher indicates near
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() => _hasSensor = false);
      }
    }
  }

  @override
  void dispose() {
    _proximitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proximity Sensor'),
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
            'Please grant sensor permission to use this feature',
            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => openAppSettings(),
            child: const Text('Open Settings'),
          ),
        ],
      );
    }

    if (!_hasSensor) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.warning_2, size: 60, color: colorScheme.error),
          const SizedBox(height: 20),
          Text(
            'Proximity Sensor Not Available',
            style: TextStyle(
              fontSize: 18,
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'This device doesn\'t have a proximity sensor',
            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Proximity Indicator
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _isNear
                    ? colorScheme.errorContainer
                    : colorScheme.primaryContainer,
            boxShadow: [
              BoxShadow(
                color:
                    _isNear
                        ? colorScheme.error.withOpacity(0.3)
                        : colorScheme.primary.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
            border: Border.all(
              color: _isNear ? colorScheme.error : colorScheme.primary,
              width: 2,
            ),
          ),
          child: Icon(
            _isNear ? Iconsax.close_circle : Iconsax.tick_circle,
            size: 60,
            color:
                _isNear
                    ? colorScheme.onErrorContainer
                    : colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 40),
        // Status Indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color:
                _isNear
                    ? colorScheme.error.withOpacity(0.1)
                    : colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isNear ? colorScheme.error : colorScheme.primary,
              width: 1,
            ),
          ),
          child: Text(
            _isNear ? 'OBJECT NEAR' : 'NO OBJECT DETECTED',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _isNear ? colorScheme.error : colorScheme.primary,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _isNear
              ? 'Move your hand away from the sensor'
              : 'Bring your hand near the top of the device',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
