import 'dart:async';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:light/light.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Service responsible for managing sensor streams
class SensorStreamService {
  final Map<String, StreamController<Map<String, dynamic>>> _activeStreams = {};
  final Map<String, StreamSubscription> _subscriptions = {};

  // Noise meter specific management
  NoiseMeter? _noiseMeter;
  StreamSubscription? _noiseMeterSubscription;

  /// Gets or creates a sensor stream for the specified sensor type
  Stream<Map<String, dynamic>> getStream(SensorType sensorType) {
    final sensorKey = sensorType.name;

    // Return existing stream if available
    if (_activeStreams.containsKey(sensorKey)) {
      return _activeStreams[sensorKey]!.stream;
    }

    // Create new stream
    final controller = StreamController<Map<String, dynamic>>.broadcast();
    _activeStreams[sensorKey] = controller;

    _initializeSensor(sensorType, controller);

    return controller.stream;
  }

  /// Initializes the appropriate sensor based on type
  void _initializeSensor(
    SensorType sensorType,
    StreamController<Map<String, dynamic>> controller,
  ) {
    final sensorKey = sensorType.name;

    try {
      switch (sensorType) {
        case SensorType.lightMeter:
          _initializeLightSensor(sensorKey, controller);
          break;
        case SensorType.noiseMeter:
          _initializeNoiseMeter(sensorKey, controller);
          break;
        case SensorType.accelerometer:
          _initializeAccelerometer(sensorKey, controller);
          break;
        case SensorType.gyroscope:
          _initializeGyroscope(sensorKey, controller);
          break;
        case SensorType.magnetometer:
          _initializeMagnetometer(sensorKey, controller);
          break;
        case SensorType.barometer:
          _initializeBarometer(sensorKey, controller);
          break;
        case SensorType.compass:
          _initializeCompass(sensorKey, controller);
          break;
        case SensorType.proximity:
          _initializeProximity(sensorKey, controller);
          break;
        case SensorType.pedometer:
          _initializePedometer(sensorKey, controller);
          break;
        case SensorType.temperature:
        case SensorType.humidity:
        case SensorType.gps:
        case SensorType.altimeter:
        case SensorType.speedMeter:
        case SensorType.heartBeat:
          _handleUnsupportedSensor(sensorType, controller);
          break;
      }
    } catch (e) {
      AppLogger.log(
        'Error initializing ${sensorType.name}: $e',
        level: LogLevel.error,
      );
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  void _initializeLightSensor(
    String sensorKey,
    StreamController<Map<String, dynamic>> controller,
  ) {
    _subscriptions[sensorKey] = Light().lightSensorStream.listen(
      (lux) {
        if (!controller.isClosed) {
          controller.add({'lightMeter': lux.toDouble()});
        }
      },
      onError: (error) {
        AppLogger.log('Light sensor error: $error', level: LogLevel.error);
        if (!controller.isClosed) {
          controller.addError(error);
        }
      },
    );
  }

  void _initializeNoiseMeter(
    String sensorKey,
    StreamController<Map<String, dynamic>> controller,
  ) async {
    // Clean up any existing noise meter instance first to prevent conflicts
    await _cleanupNoiseMeter();

    final hasPermission = await _checkMicrophonePermission();
    if (!hasPermission) {
      AppLogger.log('Microphone permission denied', level: LogLevel.warning);
      if (!controller.isClosed) {
        controller.addError('Microphone permission denied');
      }
      return;
    }

    try {
      // Create NoiseMeter instance
      _noiseMeter = NoiseMeter();

      // Listen to the noise stream and forward to the controller
      // Using the same pattern as noise_meter feature for stability
      _noiseMeterSubscription = _noiseMeter!.noise.listen(
        (noiseReading) {
          // Check if controller is still open before adding data
          if (!controller.isClosed) {
            final db = noiseReading.meanDecibel;
            // Validate the reading before forwarding
            if (!db.isNaN && !db.isInfinite) {
              controller.add({'noiseMeter': db});
            } else {
              AppLogger.log(
                'Invalid noise reading: $db',
                level: LogLevel.warning,
              );
            }
          }
        },
        onError: (error) {
          AppLogger.log('Noise meter error: $error', level: LogLevel.error);
          if (!controller.isClosed) {
            controller.addError(error);
          }
        },
        onDone: () {
          AppLogger.log('Noise meter stream completed', level: LogLevel.info);
        },
        cancelOnError: false,
      );

      // Store subscription for cleanup
      _subscriptions[sensorKey] = _noiseMeterSubscription!;

      AppLogger.log(
        'Noise meter initialized successfully',
        level: LogLevel.info,
      );
    } catch (e) {
      AppLogger.log(
        'Failed to initialize noise meter: $e',
        level: LogLevel.error,
      );
      if (!controller.isClosed) {
        controller.addError(e);
      }
      // Ensure cleanup even on failure
      await _cleanupNoiseMeter();
    }
  }

  Future<void> _cleanupNoiseMeter() async {
    try {
      if (_noiseMeterSubscription != null) {
        await _noiseMeterSubscription!.cancel();
        _noiseMeterSubscription = null;
      }
      _noiseMeter = null;
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      AppLogger.log(
        'Error cleaning up noise meter: $e',
        level: LogLevel.warning,
      );
    }
  }

  Future<bool> _checkMicrophonePermission() async {
    try {
      final status = await Permission.microphone.status;
      if (status.isGranted) return true;

      final result = await Permission.microphone.request();
      return result.isGranted;
    } catch (e) {
      AppLogger.log(
        'Error checking microphone permission: $e',
        level: LogLevel.error,
      );
      return false;
    }
  }

  void _initializeAccelerometer(
    String sensorKey,
    StreamController<Map<String, dynamic>> controller,
  ) {
    _subscriptions[sensorKey] = accelerometerEventStream().listen(
      (event) {
        if (!controller.isClosed) {
          controller.add({
            'accelerometer': {'x': event.x, 'y': event.y, 'z': event.z},
          });
        }
      },
      onError: (error) {
        AppLogger.log('Accelerometer error: $error', level: LogLevel.error);
        if (!controller.isClosed) {
          controller.addError(error);
        }
      },
    );
  }

  void _initializeGyroscope(
    String sensorKey,
    StreamController<Map<String, dynamic>> controller,
  ) {
    _subscriptions[sensorKey] = gyroscopeEventStream().listen(
      (event) {
        if (!controller.isClosed) {
          controller.add({
            'gyroscope': {'x': event.x, 'y': event.y, 'z': event.z},
          });
        }
      },
      onError: (error) {
        AppLogger.log('Gyroscope error: $error', level: LogLevel.error);
        if (!controller.isClosed) {
          controller.addError(error);
        }
      },
    );
  }

  void _initializeMagnetometer(
    String sensorKey,
    StreamController<Map<String, dynamic>> controller,
  ) {
    _subscriptions[sensorKey] = magnetometerEventStream().listen(
      (event) {
        if (!controller.isClosed) {
          controller.add({
            'magnetometer': {'x': event.x, 'y': event.y, 'z': event.z},
          });
        }
      },
      onError: (error) {
        AppLogger.log('Magnetometer error: $error', level: LogLevel.error);
        if (!controller.isClosed) {
          controller.addError(error);
        }
      },
    );
  }

  void _initializeBarometer(
    String sensorKey,
    StreamController<Map<String, dynamic>> controller,
  ) {
    _subscriptions[sensorKey] = barometerEventStream().listen(
      (event) {
        if (!controller.isClosed) {
          controller.add({'barometer': event.pressure});
        }
      },
      onError: (error) {
        AppLogger.log('Barometer error: $error', level: LogLevel.error);
        if (!controller.isClosed) {
          controller.addError(error);
        }
      },
    );
  }

  void _initializeCompass(
    String sensorKey,
    StreamController<Map<String, dynamic>> controller,
  ) {
    final compassEvents = FlutterCompass.events;
    if (compassEvents == null) {
      AppLogger.log(
        'Compass sensor not available on this device',
        level: LogLevel.warning,
      );
      if (!controller.isClosed) {
        controller.addError('Compass sensor not available');
      }
      return;
    }

    _subscriptions[sensorKey] = compassEvents.listen(
      (event) {
        if (!controller.isClosed) {
          controller.add({'compass': event.heading ?? 0.0});
        }
      },
      onError: (error) {
        AppLogger.log('Compass error: $error', level: LogLevel.error);
        if (!controller.isClosed) {
          controller.addError(error);
        }
      },
    );
  }

  void _initializeProximity(
    String sensorKey,
    StreamController<Map<String, dynamic>> controller,
  ) {
    _subscriptions[sensorKey] = ProximitySensor.events.listen(
      (event) {
        if (!controller.isClosed) {
          final isNear = event > 0;
          controller.add({'proximity': isNear ? 1.0 : 0.0});
        }
      },
      onError: (error) {
        AppLogger.log('Proximity sensor error: $error', level: LogLevel.error);
        if (!controller.isClosed) {
          controller.addError(error);
        }
      },
    );
  }

  void _initializePedometer(
    String sensorKey,
    StreamController<Map<String, dynamic>> controller,
  ) {
    _subscriptions[sensorKey] = Pedometer.stepCountStream.listen(
      (event) {
        if (!controller.isClosed) {
          controller.add({'pedometer': event.steps.toDouble()});
        }
      },
      onError: (error) {
        AppLogger.log('Pedometer error: $error', level: LogLevel.error);
        if (!controller.isClosed) {
          controller.addError(error);
        }
      },
    );
  }

  void _handleUnsupportedSensor(
    SensorType sensorType,
    StreamController<Map<String, dynamic>> controller,
  ) {
    final message =
        'Sensor ${sensorType.name} not supported or stream not implemented';
    AppLogger.log(
      'Warning: ${sensorType.name} does not have direct hardware sensor support on most devices.',
      level: LogLevel.warning,
    );
    if (!controller.isClosed) {
      controller.addError(message);
    }
  }

  /// Disposes all active sensor streams and subscriptions
  void dispose() {
    // Cancel all subscriptions
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();

    // Close all stream controllers
    for (final controller in _activeStreams.values) {
      controller.close();
    }
    _activeStreams.clear();

    // Clean up noise meter
    _noiseMeterSubscription?.cancel();
    _noiseMeterSubscription = null;
    _noiseMeter = null;
  }
}
