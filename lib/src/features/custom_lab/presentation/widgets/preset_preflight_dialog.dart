import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:light/light.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensors_plus/sensors_plus.dart';

class PresetPreflightDialog extends StatefulWidget {
  final Lab lab;
  const PresetPreflightDialog({super.key, required this.lab});

  @override
  State<PresetPreflightDialog> createState() => _PresetPreflightDialogState();
}

class _PresetPreflightDialogState extends State<PresetPreflightDialog> {
  late Future<_PreflightResult> _preflight;

  @override
  void initState() {
    super.initState();
    _preflight = _runPreflight(widget.lab.sensors);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Checking requirements'),
      content: FutureBuilder<_PreflightResult>(
        future: _preflight,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 96,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final result = snapshot.data!;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PermissionList(
                required: result.requiredPermissions,
                statuses: result.permissionStatuses,
              ),
              const SizedBox(height: 12),
              if (result.unavailableSensors.isNotEmpty)
                _UnavailableSensorsList(unavailable: result.unavailableSensors),
              if (result.uncheckedSensors.isNotEmpty)
                const _Note(
                  text: 'Some sensors may not be available on your device.',
                ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FutureBuilder<_PreflightResult>(
          future: _preflight,
          builder: (context, snapshot) {
            final canContinue = snapshot.hasData;
            return FilledButton(
              onPressed: !canContinue
                  ? null
                  : () async {
                      final res = snapshot.data!;
                      final allGranted = await _requestMissingPermissions(
                        res.permissionStatuses,
                      );
                      if (allGranted) {
                        if (!context.mounted) return;
                        Navigator.of(context).pop(true);
                      } else {
                        if (!context.mounted) return;
                        _showPermissionsHelp(context);
                      }
                    },
              child: const Text('Continue'),
            );
          },
        ),
      ],
    );
  }

  Future<_PreflightResult> _runPreflight(List<SensorType> sensors) async {
    // Map sensors to permissions
    final required = _mapSensorsToPermissions(sensors);
    final permissionStatuses = <Permission, PermissionStatus>{};
    for (final p in required) {
      try {
        permissionStatuses[p] = await p.status;
      } catch (e) {
        permissionStatuses[p] = PermissionStatus.denied;
      }
    }

    // Best-effort availability checks for a few sensors
    final unavailable = <SensorType>[];
    final unchecked = <SensorType>[];

    Future<void> check<T>(SensorType type, Future<T> fut) async {
      try {
        await fut.timeout(const Duration(milliseconds: 500));
      } catch (e) {
        unavailable.add(type);
      }
    }

    for (final s in sensors) {
      switch (s) {
        case SensorType.barometer:
          await check(s, barometerEventStream().first);
          break;
        case SensorType.compass:
          // If events is null, sensor not present
          final events = FlutterCompass.events;
          if (events == null) unavailable.add(s);
          break;
        case SensorType.lightMeter:
          await check(s, Light().lightSensorStream.first);
          break;
        case SensorType.accelerometer:
          await check(s, accelerometerEventStream().first);
          break;
        case SensorType.gyroscope:
          await check(s, gyroscopeEventStream().first);
          break;
        case SensorType.magnetometer:
          await check(s, magnetometerEventStream().first);
          break;
        case SensorType.noiseMeter:
        case SensorType.pedometer:
        case SensorType.gps:
        case SensorType.altimeter:
        case SensorType.speedMeter:
        case SensorType.temperature:
        case SensorType.humidity:
        case SensorType.proximity:
        case SensorType.heartBeat:
          unchecked.add(s);
          break;
      }
    }

    return _PreflightResult(
      requiredPermissions: required,
      permissionStatuses: permissionStatuses,
      unavailableSensors: unavailable,
      uncheckedSensors: unchecked,
    );
  }

  Set<Permission> _mapSensorsToPermissions(List<SensorType> sensors) {
    final set = <Permission>{};
    for (final s in sensors) {
      switch (s) {
        case SensorType.noiseMeter:
          set.add(Permission.microphone);
          break;
        case SensorType.pedometer:
          set.add(Permission.activityRecognition);
          break;
        case SensorType.gps:
        case SensorType.speedMeter:
          set.add(Permission.locationWhenInUse);
          break;
        case SensorType.heartBeat:
          set.add(Permission.camera);
          break;
        default:
          break;
      }
    }
    return set;
  }

  Future<bool> _requestMissingPermissions(
    Map<Permission, PermissionStatus> statuses,
  ) async {
    var allGranted = true;
    for (final entry in statuses.entries) {
      if (!entry.value.isGranted) {
        try {
          final result = await entry.key.request();
          if (!result.isGranted) allGranted = false;
        } catch (e) {
          AppLogger.log(
            'Permission request failed: ${entry.key} $e',
            level: LogLevel.warning,
          );
          allGranted = false;
        }
      }
    }
    return allGranted;
  }

  void _showPermissionsHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Permissions required'),
        content: const Text('Please grant permissions in system settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await openAppSettings();
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Open settings'),
          ),
        ],
      ),
    );
  }
}

class _PreflightResult {
  final Set<Permission> requiredPermissions;
  final Map<Permission, PermissionStatus> permissionStatuses;
  final List<SensorType> unavailableSensors;
  final List<SensorType> uncheckedSensors;
  _PreflightResult({
    required this.requiredPermissions,
    required this.permissionStatuses,
    required this.unavailableSensors,
    required this.uncheckedSensors,
  });
}

class _PermissionList extends StatelessWidget {
  final Set<Permission> required;
  final Map<Permission, PermissionStatus> statuses;
  const _PermissionList({required this.required, required this.statuses});

  @override
  Widget build(BuildContext context) {
    if (required.isEmpty) {
      return const _Note(text: 'No permissions needed');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Required permissions',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ...required.map((p) {
          final st = statuses[p];
          final granted = st?.isGranted == true;
          return Row(
            children: [
              Icon(
                granted ? Icons.check_circle : Icons.error_outline,
                size: 18,
                color: granted ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(_permissionLabel(p))),
              Text(
                granted ? 'Granted' : 'Not granted',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        }),
      ],
    );
  }

  String _permissionLabel(Permission p) {
    if (p == Permission.microphone) return 'Microphone';
    if (p == Permission.activityRecognition) return 'Activity recognition';
    if (p == Permission.locationWhenInUse) return 'Location';
    if (p == Permission.camera) return 'Camera';
    return p.toString();
  }
}

class _UnavailableSensorsList extends StatelessWidget {
  final List<SensorType> unavailable;
  const _UnavailableSensorsList({required this.unavailable});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unavailable sensors',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ...unavailable.map(
          (s) => Row(
            children: [
              const Icon(Icons.block, size: 18, color: Colors.redAccent),
              const SizedBox(width: 8),
              Expanded(child: Text(s.name)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  final String text;
  const _Note({required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}
