// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sensor_data_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SensorDataPoint _$SensorDataPointFromJson(Map<String, dynamic> json) {
  return _SensorDataPoint.fromJson(json);
}

/// @nodoc
mixin _$SensorDataPoint {
  @HiveField(0)
  String get sessionId => throw _privateConstructorUsedError;
  @HiveField(1)
  DateTime get timestamp => throw _privateConstructorUsedError;
  @HiveField(2)
  @JsonKey(fromJson: _sensorValuesFromJson, toJson: _sensorValuesToJson)
  Map<SensorType, dynamic> get sensorValues =>
      throw _privateConstructorUsedError;
  @HiveField(3)
  int get sequenceNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SensorDataPointCopyWith<SensorDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SensorDataPointCopyWith<$Res> {
  factory $SensorDataPointCopyWith(
          SensorDataPoint value, $Res Function(SensorDataPoint) then) =
      _$SensorDataPointCopyWithImpl<$Res, SensorDataPoint>;
  @useResult
  $Res call(
      {@HiveField(0) String sessionId,
      @HiveField(1) DateTime timestamp,
      @HiveField(2)
      @JsonKey(fromJson: _sensorValuesFromJson, toJson: _sensorValuesToJson)
      Map<SensorType, dynamic> sensorValues,
      @HiveField(3) int sequenceNumber});
}

/// @nodoc
class _$SensorDataPointCopyWithImpl<$Res, $Val extends SensorDataPoint>
    implements $SensorDataPointCopyWith<$Res> {
  _$SensorDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? timestamp = null,
    Object? sensorValues = null,
    Object? sequenceNumber = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sensorValues: null == sensorValues
          ? _value.sensorValues
          : sensorValues // ignore: cast_nullable_to_non_nullable
              as Map<SensorType, dynamic>,
      sequenceNumber: null == sequenceNumber
          ? _value.sequenceNumber
          : sequenceNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SensorDataPointImplCopyWith<$Res>
    implements $SensorDataPointCopyWith<$Res> {
  factory _$$SensorDataPointImplCopyWith(_$SensorDataPointImpl value,
          $Res Function(_$SensorDataPointImpl) then) =
      __$$SensorDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String sessionId,
      @HiveField(1) DateTime timestamp,
      @HiveField(2)
      @JsonKey(fromJson: _sensorValuesFromJson, toJson: _sensorValuesToJson)
      Map<SensorType, dynamic> sensorValues,
      @HiveField(3) int sequenceNumber});
}

/// @nodoc
class __$$SensorDataPointImplCopyWithImpl<$Res>
    extends _$SensorDataPointCopyWithImpl<$Res, _$SensorDataPointImpl>
    implements _$$SensorDataPointImplCopyWith<$Res> {
  __$$SensorDataPointImplCopyWithImpl(
      _$SensorDataPointImpl _value, $Res Function(_$SensorDataPointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? timestamp = null,
    Object? sensorValues = null,
    Object? sequenceNumber = null,
  }) {
    return _then(_$SensorDataPointImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sensorValues: null == sensorValues
          ? _value._sensorValues
          : sensorValues // ignore: cast_nullable_to_non_nullable
              as Map<SensorType, dynamic>,
      sequenceNumber: null == sequenceNumber
          ? _value.sequenceNumber
          : sequenceNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SensorDataPointImpl implements _SensorDataPoint {
  const _$SensorDataPointImpl(
      {@HiveField(0) required this.sessionId,
      @HiveField(1) required this.timestamp,
      @HiveField(2)
      @JsonKey(fromJson: _sensorValuesFromJson, toJson: _sensorValuesToJson)
      required final Map<SensorType, dynamic> sensorValues,
      @HiveField(3) this.sequenceNumber = 0})
      : _sensorValues = sensorValues;

  factory _$SensorDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$SensorDataPointImplFromJson(json);

  @override
  @HiveField(0)
  final String sessionId;
  @override
  @HiveField(1)
  final DateTime timestamp;
  final Map<SensorType, dynamic> _sensorValues;
  @override
  @HiveField(2)
  @JsonKey(fromJson: _sensorValuesFromJson, toJson: _sensorValuesToJson)
  Map<SensorType, dynamic> get sensorValues {
    if (_sensorValues is EqualUnmodifiableMapView) return _sensorValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sensorValues);
  }

  @override
  @JsonKey()
  @HiveField(3)
  final int sequenceNumber;

  @override
  String toString() {
    return 'SensorDataPoint(sessionId: $sessionId, timestamp: $timestamp, sensorValues: $sensorValues, sequenceNumber: $sequenceNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SensorDataPointImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality()
                .equals(other._sensorValues, _sensorValues) &&
            (identical(other.sequenceNumber, sequenceNumber) ||
                other.sequenceNumber == sequenceNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sessionId, timestamp,
      const DeepCollectionEquality().hash(_sensorValues), sequenceNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SensorDataPointImplCopyWith<_$SensorDataPointImpl> get copyWith =>
      __$$SensorDataPointImplCopyWithImpl<_$SensorDataPointImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SensorDataPointImplToJson(
      this,
    );
  }
}

abstract class _SensorDataPoint implements SensorDataPoint {
  const factory _SensorDataPoint(
      {@HiveField(0) required final String sessionId,
      @HiveField(1) required final DateTime timestamp,
      @HiveField(2)
      @JsonKey(fromJson: _sensorValuesFromJson, toJson: _sensorValuesToJson)
      required final Map<SensorType, dynamic> sensorValues,
      @HiveField(3) final int sequenceNumber}) = _$SensorDataPointImpl;

  factory _SensorDataPoint.fromJson(Map<String, dynamic> json) =
      _$SensorDataPointImpl.fromJson;

  @override
  @HiveField(0)
  String get sessionId;
  @override
  @HiveField(1)
  DateTime get timestamp;
  @override
  @HiveField(2)
  @JsonKey(fromJson: _sensorValuesFromJson, toJson: _sensorValuesToJson)
  Map<SensorType, dynamic> get sensorValues;
  @override
  @HiveField(3)
  int get sequenceNumber;
  @override
  @JsonKey(ignore: true)
  _$$SensorDataPointImplCopyWith<_$SensorDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
