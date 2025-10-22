import 'dart:async';
import 'dart:io';

// import 'package:csv/csv.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:hive/hive.dart';
import 'package:light/light.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/custom_lab/data/models/lab_session_hive.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_data_point.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';
import 'package:sensors_plus/sensors_plus.dart';

class LabRepositoryImpl implements LabRepository {
  static const String _labSessionsBox = 'labSessions';
  static const String _labsBox = 'labs';
  static const String _sensorDataBoxPrefix = 'sensorData_';

  // Map to hold active sensor streams for a session
  final Map<String, StreamController<Map<String, dynamic>>>
  _activeSensorStreams = {};
  final Map<String, StreamSubscription> _sensorSubscriptions = {};
  NoiseMeter? _noiseMeter;

  Future<Box<LabSessionHive>> _openLabSessionsBox() async {
    return await Hive.openBox<LabSessionHive>(_labSessionsBox);
  }

  Future<Box<Map<String, dynamic>>> _openSensorDataBox(String sessionId) async {
    return await Hive.openBox<Map<String, dynamic>>(
      '$_sensorDataBoxPrefix$sessionId',
    );
  }

  @override
  Future<void> saveLabSession(LabSession session) async {
    final box = await _openLabSessionsBox();
    await box.put(session.id, LabSessionHive.fromEntity(session));
  }

  @override
  Future<void> updateLabSession(LabSession session) async {
    final box = await _openLabSessionsBox();
    await box.put(session.id, LabSessionHive.fromEntity(session));
  }

  @override
  Future<List<LabSession>> getLabSessions() async {
    final box = await _openLabSessionsBox();
    return box.values.map((hive) => hive.toEntity()).toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  @override
  Future<LabSession?> getLabSessionById(String sessionId) async {
    final box = await _openLabSessionsBox();
    final hiveSession = box.get(sessionId);
    return hiveSession?.toEntity();
  }

  @override
  Future<void> deleteLabSession(String sessionId) async {
    final sessionsBox = await _openLabSessionsBox();
    await sessionsBox.delete(sessionId);
    // Also delete the associated sensor data box
    await Hive.deleteBoxFromDisk('$_sensorDataBoxPrefix$sessionId');
  }

  @override
  Future<void> deleteAllLabSessions() async {
    final sessionsBox = await _openLabSessionsBox();
    await sessionsBox.clear();
    // Iterate and delete all sensor data boxes
    for (var key in Hive.box(_labSessionsBox).keys) {
      await Hive.deleteBoxFromDisk('$_sensorDataBoxPrefix$key');
    }
  }

  @override
  Future<void> addSensorDataPoint({
    required String sessionId,
    required Map<String, dynamic> dataPoint,
  }) async {
    final box = await _openSensorDataBox(sessionId);
    await box.add(dataPoint);
  }

  @override
  Future<List<Map<String, dynamic>>> getSensorDataPoints(
    String sessionId,
  ) async {
    final box = await _openSensorDataBox(sessionId);
    return box.values.toList();
  }

  @override
  Stream<Map<String, dynamic>> getSensorStream(SensorType sensorType) {
    final sensorKey = sensorType.name;
    if (_activeSensorStreams.containsKey(sensorKey)) {
      return _activeSensorStreams[sensorKey]!.stream;
    }

    final controller = StreamController<Map<String, dynamic>>.broadcast();
    _activeSensorStreams[sensorKey] = controller;

    try {
      switch (sensorType) {
        case SensorType.lightMeter:
          _sensorSubscriptions[sensorKey] = Light().lightSensorStream.listen(
            (lux) {
              controller.add({'lightMeter': lux.toDouble()});
            },
            onError: (error) {
              AppLogger.log(
                'Light sensor error: $error',
                level: LogLevel.error,
              );
              controller.addError(error);
            },
          );
          break;

        case SensorType.noiseMeter:
          _initializeNoiseMeter(sensorType, controller);
          break;

        case SensorType.accelerometer:
          _sensorSubscriptions[sensorKey] = accelerometerEventStream().listen(
            (event) {
              controller.add({
                'accelerometer': {'x': event.x, 'y': event.y, 'z': event.z},
              });
            },
            onError: (error) {
              AppLogger.log(
                'Accelerometer error: $error',
                level: LogLevel.error,
              );
              controller.addError(error);
            },
          );
          break;

        case SensorType.gyroscope:
          _sensorSubscriptions[sensorKey] = gyroscopeEventStream().listen(
            (event) {
              controller.add({
                'gyroscope': {'x': event.x, 'y': event.y, 'z': event.z},
              });
            },
            onError: (error) {
              AppLogger.log('Gyroscope error: $error', level: LogLevel.error);
              controller.addError(error);
            },
          );
          break;

        case SensorType.magnetometer:
          _sensorSubscriptions[sensorKey] = magnetometerEventStream().listen(
            (event) {
              controller.add({
                'magnetometer': {'x': event.x, 'y': event.y, 'z': event.z},
              });
            },
            onError: (error) {
              AppLogger.log(
                'Magnetometer error: $error',
                level: LogLevel.error,
              );
              controller.addError(error);
            },
          );
          break;

        case SensorType.barometer:
          _sensorSubscriptions[sensorKey] = barometerEventStream().listen(
            (event) {
              controller.add({'barometer': event.pressure});
            },
            onError: (error) {
              AppLogger.log('Barometer error: $error', level: LogLevel.error);
              controller.addError(error);
            },
          );
          break;

        case SensorType.compass:
          final compassEvents = FlutterCompass.events;
          if (compassEvents != null) {
            _sensorSubscriptions[sensorKey] = compassEvents.listen(
              (event) {
                controller.add({'compass': event.heading ?? 0.0});
              },
              onError: (error) {
                AppLogger.log('Compass error: $error', level: LogLevel.error);
                controller.addError(error);
              },
            );
          } else {
            AppLogger.log(
              'Compass sensor not available on this device',
              level: LogLevel.warning,
            );
            controller.addError('Compass sensor not available');
          }
          break;

        case SensorType.proximity:
          _sensorSubscriptions[sensorKey] = ProximitySensor.events.listen(
            (event) {
              final isNear = event > 0;
              controller.add({'proximity': isNear ? 1.0 : 0.0});
            },
            onError: (error) {
              AppLogger.log(
                'Proximity sensor error: $error',
                level: LogLevel.error,
              );
              controller.addError(error);
            },
          );
          break;

        case SensorType.pedometer:
          _sensorSubscriptions[sensorKey] = Pedometer.stepCountStream.listen(
            (event) {
              controller.add({'pedometer': event.steps.toDouble()});
            },
            onError: (error) {
              AppLogger.log('Pedometer error: $error', level: LogLevel.error);
              controller.addError(error);
            },
          );
          break;

        case SensorType.temperature:
        case SensorType.humidity:
        case SensorType.gps:
        case SensorType.altimeter:
        case SensorType.speedMeter:
        case SensorType.heartBeat:
          AppLogger.log(
            'Warning: ${sensorType.name} does not have direct hardware sensor support on most devices or stream not implemented.',
            level: LogLevel.warning,
          );
          controller.addError(
            'Sensor ${sensorType.name} not supported or stream not implemented',
          );
          break;
      }
    } catch (e) {
      AppLogger.log(
        'Error subscribing to ${sensorType.name}: $e',
        level: LogLevel.error,
      );
      controller.addError(e);
    }

    return controller.stream;
  }

  Future<void> _initializeNoiseMeter(
    SensorType sensorType,
    StreamController<Map<String, dynamic>> controller,
  ) async {
    final sensorKey = sensorType.name;
    final hasPermission = await _checkAndRequestMicrophonePermission();
    if (hasPermission) {
      try {
        _noiseMeter = NoiseMeter();
        _sensorSubscriptions[sensorKey] = _noiseMeter!.noise.listen(
          (noiseReading) {
            controller.add({'noiseMeter': noiseReading.meanDecibel});
          },
          onError: (error) {
            AppLogger.log('Noise meter error: $error', level: LogLevel.error);
            controller.addError(error);
          },
        );
      } catch (e) {
        AppLogger.log(
          'Failed to initialize noise meter: $e',
          level: LogLevel.error,
        );
        controller.addError(e);
      }
    } else {
      AppLogger.log('Microphone permission denied', level: LogLevel.warning);
      controller.addError('Microphone permission denied');
    }
  }

  Future<bool> _checkAndRequestMicrophonePermission() async {
    try {
      final status = await Permission.microphone.status;
      if (status.isGranted) {
        return true;
      }

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

  void disposeSensorStreams() {
    for (final subscription in _sensorSubscriptions.values) {
      subscription.cancel();
    }
    _sensorSubscriptions.clear();
    for (final controller in _activeSensorStreams.values) {
      controller.close();
    }
    _activeSensorStreams.clear();
    _noiseMeter = null;
  }

  @override
  Future<String> exportSessionToCSV(
    String sessionId,
    List<Map<String, dynamic>> dataPoints,
  ) async {
    if (dataPoints.isEmpty) {
      throw Exception('No data points to export for session $sessionId');
    }

    // Determine all unique keys (column headers)
    final Set<String> headers = {};
    for (final dp in dataPoints) {
      headers.addAll(dp.keys);
    }
    final sortedHeaders = headers.toList()
      ..sort(); // Sort headers for consistent order

    // Build CSV manually
    final csvLines = <String>[];

    // Add header row
    csvLines.add('timestamp,${sortedHeaders.join(',')}');

    // Add data rows
    for (var i = 0; i < dataPoints.length; i++) {
      final dp = dataPoints[i];
      final row = <String>[
        i.toString(),
        ...sortedHeaders.map((header) => _escapeCsvValue(dp[header])),
      ];
      csvLines.add(row.join(','));
    }

    final csv = csvLines.join('\n');

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/lab_session_$sessionId.csv';
    final file = File(path);
    await file.writeAsString(csv);

    return path;
  }

  /// Escapes CSV value to handle commas, quotes, and newlines
  String _escapeCsvValue(dynamic value) {
    if (value == null) return '';
    final str = value.toString();
    if (str.contains(',') || str.contains('"') || str.contains('\n')) {
      return '"${str.replaceAll('"', '""')}"';
    }
    return str;
  }

  // Lab CRUD operations
  @override
  Future<Lab> createLab(Lab lab) {
    throw UnimplementedError('createLab not yet implemented');
  }

  @override
  Future<Lab> updateLab(Lab lab) {
    throw UnimplementedError('updateLab not yet implemented');
  }

  @override
  Future<Lab?> getLabById(String labId) {
    throw UnimplementedError('getLabById not yet implemented');
  }

  @override
  Future<List<Lab>> getAllLabs() {
    throw UnimplementedError('getAllLabs not yet implemented');
  }

  @override
  Future<void> deleteLab(String labId) {
    throw UnimplementedError('deleteLab not yet implemented');
  }

  // Session CRUD operations
  @override
  Future<LabSession> createSession(LabSession session) async {
    await saveLabSession(session);
    return session;
  }

  @override
  Future<LabSession> updateSession(LabSession session) async {
    await updateLabSession(session);
    return session;
  }

  @override
  Future<LabSession?> getSessionById(String sessionId) async {
    final box = await _openLabSessionsBox();
    final hiveSession = box.get(sessionId);
    return hiveSession?.toEntity();
  }

  @override
  Future<List<LabSession>> getSessionsByLabId(String labId) async {
    final sessions = await getLabSessions();
    return sessions.where((s) => s.labId == labId).toList();
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await deleteLabSession(sessionId);
  }

  // Data point operations
  @override
  Future<void> saveDataPoint(
    String sessionId,
    SensorDataPoint dataPoint,
  ) async {
    await addSensorDataPoint(
      sessionId: sessionId,
      dataPoint: {
        'timestamp': dataPoint.timestamp.toIso8601String(),
        'sequenceNumber': dataPoint.sequenceNumber,
        'sensorValues': dataPoint.sensorValues.map(
          (key, value) => MapEntry(key.name, value),
        ),
      },
    );
  }

  @override
  Future<void> saveBatchDataPoints(
    String sessionId,
    List<SensorDataPoint> dataPoints,
  ) async {
    for (final dataPoint in dataPoints) {
      await saveDataPoint(sessionId, dataPoint);
    }
  }

  @override
  Future<List<SensorDataPoint>> getDataPointsBySessionId(
    String sessionId,
  ) async {
    final rawData = await getSensorDataPoints(sessionId);
    return rawData.map((data) {
      return SensorDataPoint(
        sessionId: sessionId,
        timestamp: DateTime.parse(data['timestamp'] as String),
        sequenceNumber: data['sequenceNumber'] as int,
        sensorValues: (data['sensorValues'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            SensorType.values.firstWhere((e) => e.name == key),
            value,
          ),
        ),
      );
    }).toList();
  }
}
