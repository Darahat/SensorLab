import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import 'sensor_type.dart';

part 'sensor_data_point.freezed.dart';
part 'sensor_data_point.g.dart';

/// Represents a single data point recorded from all sensors at a specific time
@freezed
@HiveType(typeId: 24)
class SensorDataPoint with _$SensorDataPoint {
  const factory SensorDataPoint({
    @HiveField(0) required String sessionId,
    @HiveField(1) required DateTime timestamp,
    @HiveField(2)
    @JsonKey(
      fromJson: _sensorValuesFromJson,
      toJson: _sensorValuesToJson,
    )
    required Map<SensorType, dynamic> sensorValues,
    @HiveField(3) @Default(0) int sequenceNumber,
  }) = _SensorDataPoint;

  factory SensorDataPoint.fromJson(Map<String, dynamic> json) =>
      _$SensorDataPointFromJson(json);
}

Map<SensorType, dynamic> _sensorValuesFromJson(Map<String, dynamic> json) {
  return json.map((key, value) {
    return MapEntry(
        SensorType.values.firstWhere((e) => e.name == key), value);
  });
}

Map<String, dynamic> _sensorValuesToJson(Map<SensorType, dynamic> map) {
  return map.map((key, value) {
    return MapEntry(key.name, value);
  });
}
