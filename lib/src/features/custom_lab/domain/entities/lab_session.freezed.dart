// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lab_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LabSession _$LabSessionFromJson(Map<String, dynamic> json) {
  return _LabSession.fromJson(json);
}

/// @nodoc
mixin _$LabSession {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get labId => throw _privateConstructorUsedError;
  @HiveField(2)
  String get labName => throw _privateConstructorUsedError;
  @HiveField(3)
  DateTime get startTime => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime? get endTime => throw _privateConstructorUsedError;
  @HiveField(5)
  RecordingStatus get status => throw _privateConstructorUsedError;
  @HiveField(6)
  int get dataPointsCount => throw _privateConstructorUsedError;
  @HiveField(7)
  int get duration => throw _privateConstructorUsedError; // seconds
  @HiveField(8)
  String? get notes => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get exportPath =>
      throw _privateConstructorUsedError; // Path to exported CSV file
  @HiveField(10)
  List<SensorType> get sensorTypes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LabSessionCopyWith<LabSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabSessionCopyWith<$Res> {
  factory $LabSessionCopyWith(
          LabSession value, $Res Function(LabSession) then) =
      _$LabSessionCopyWithImpl<$Res, LabSession>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String labId,
      @HiveField(2) String labName,
      @HiveField(3) DateTime startTime,
      @HiveField(4) DateTime? endTime,
      @HiveField(5) RecordingStatus status,
      @HiveField(6) int dataPointsCount,
      @HiveField(7) int duration,
      @HiveField(8) String? notes,
      @HiveField(9) String? exportPath,
      @HiveField(10) List<SensorType> sensorTypes});
}

/// @nodoc
class _$LabSessionCopyWithImpl<$Res, $Val extends LabSession>
    implements $LabSessionCopyWith<$Res> {
  _$LabSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? labId = null,
    Object? labName = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? status = null,
    Object? dataPointsCount = null,
    Object? duration = null,
    Object? notes = freezed,
    Object? exportPath = freezed,
    Object? sensorTypes = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      labId: null == labId
          ? _value.labId
          : labId // ignore: cast_nullable_to_non_nullable
              as String,
      labName: null == labName
          ? _value.labName
          : labName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecordingStatus,
      dataPointsCount: null == dataPointsCount
          ? _value.dataPointsCount
          : dataPointsCount // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      exportPath: freezed == exportPath
          ? _value.exportPath
          : exportPath // ignore: cast_nullable_to_non_nullable
              as String?,
      sensorTypes: null == sensorTypes
          ? _value.sensorTypes
          : sensorTypes // ignore: cast_nullable_to_non_nullable
              as List<SensorType>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LabSessionImplCopyWith<$Res>
    implements $LabSessionCopyWith<$Res> {
  factory _$$LabSessionImplCopyWith(
          _$LabSessionImpl value, $Res Function(_$LabSessionImpl) then) =
      __$$LabSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String labId,
      @HiveField(2) String labName,
      @HiveField(3) DateTime startTime,
      @HiveField(4) DateTime? endTime,
      @HiveField(5) RecordingStatus status,
      @HiveField(6) int dataPointsCount,
      @HiveField(7) int duration,
      @HiveField(8) String? notes,
      @HiveField(9) String? exportPath,
      @HiveField(10) List<SensorType> sensorTypes});
}

/// @nodoc
class __$$LabSessionImplCopyWithImpl<$Res>
    extends _$LabSessionCopyWithImpl<$Res, _$LabSessionImpl>
    implements _$$LabSessionImplCopyWith<$Res> {
  __$$LabSessionImplCopyWithImpl(
      _$LabSessionImpl _value, $Res Function(_$LabSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? labId = null,
    Object? labName = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? status = null,
    Object? dataPointsCount = null,
    Object? duration = null,
    Object? notes = freezed,
    Object? exportPath = freezed,
    Object? sensorTypes = null,
  }) {
    return _then(_$LabSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      labId: null == labId
          ? _value.labId
          : labId // ignore: cast_nullable_to_non_nullable
              as String,
      labName: null == labName
          ? _value.labName
          : labName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecordingStatus,
      dataPointsCount: null == dataPointsCount
          ? _value.dataPointsCount
          : dataPointsCount // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      exportPath: freezed == exportPath
          ? _value.exportPath
          : exportPath // ignore: cast_nullable_to_non_nullable
              as String?,
      sensorTypes: null == sensorTypes
          ? _value._sensorTypes
          : sensorTypes // ignore: cast_nullable_to_non_nullable
              as List<SensorType>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LabSessionImpl implements _LabSession {
  const _$LabSessionImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.labId,
      @HiveField(2) required this.labName,
      @HiveField(3) required this.startTime,
      @HiveField(4) this.endTime,
      @HiveField(5) required this.status,
      @HiveField(6) this.dataPointsCount = 0,
      @HiveField(7) this.duration = 0,
      @HiveField(8) this.notes,
      @HiveField(9) this.exportPath,
      @HiveField(10) final List<SensorType> sensorTypes = const []})
      : _sensorTypes = sensorTypes;

  factory _$LabSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$LabSessionImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String labId;
  @override
  @HiveField(2)
  final String labName;
  @override
  @HiveField(3)
  final DateTime startTime;
  @override
  @HiveField(4)
  final DateTime? endTime;
  @override
  @HiveField(5)
  final RecordingStatus status;
  @override
  @JsonKey()
  @HiveField(6)
  final int dataPointsCount;
  @override
  @JsonKey()
  @HiveField(7)
  final int duration;
// seconds
  @override
  @HiveField(8)
  final String? notes;
  @override
  @HiveField(9)
  final String? exportPath;
// Path to exported CSV file
  final List<SensorType> _sensorTypes;
// Path to exported CSV file
  @override
  @JsonKey()
  @HiveField(10)
  List<SensorType> get sensorTypes {
    if (_sensorTypes is EqualUnmodifiableListView) return _sensorTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sensorTypes);
  }

  @override
  String toString() {
    return 'LabSession(id: $id, labId: $labId, labName: $labName, startTime: $startTime, endTime: $endTime, status: $status, dataPointsCount: $dataPointsCount, duration: $duration, notes: $notes, exportPath: $exportPath, sensorTypes: $sensorTypes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.labId, labId) || other.labId == labId) &&
            (identical(other.labName, labName) || other.labName == labName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dataPointsCount, dataPointsCount) ||
                other.dataPointsCount == dataPointsCount) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.exportPath, exportPath) ||
                other.exportPath == exportPath) &&
            const DeepCollectionEquality()
                .equals(other._sensorTypes, _sensorTypes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      labId,
      labName,
      startTime,
      endTime,
      status,
      dataPointsCount,
      duration,
      notes,
      exportPath,
      const DeepCollectionEquality().hash(_sensorTypes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LabSessionImplCopyWith<_$LabSessionImpl> get copyWith =>
      __$$LabSessionImplCopyWithImpl<_$LabSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LabSessionImplToJson(
      this,
    );
  }
}

abstract class _LabSession implements LabSession {
  const factory _LabSession(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String labId,
      @HiveField(2) required final String labName,
      @HiveField(3) required final DateTime startTime,
      @HiveField(4) final DateTime? endTime,
      @HiveField(5) required final RecordingStatus status,
      @HiveField(6) final int dataPointsCount,
      @HiveField(7) final int duration,
      @HiveField(8) final String? notes,
      @HiveField(9) final String? exportPath,
      @HiveField(10) final List<SensorType> sensorTypes}) = _$LabSessionImpl;

  factory _LabSession.fromJson(Map<String, dynamic> json) =
      _$LabSessionImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get labId;
  @override
  @HiveField(2)
  String get labName;
  @override
  @HiveField(3)
  DateTime get startTime;
  @override
  @HiveField(4)
  DateTime? get endTime;
  @override
  @HiveField(5)
  RecordingStatus get status;
  @override
  @HiveField(6)
  int get dataPointsCount;
  @override
  @HiveField(7)
  int get duration;
  @override // seconds
  @HiveField(8)
  String? get notes;
  @override
  @HiveField(9)
  String? get exportPath;
  @override // Path to exported CSV file
  @HiveField(10)
  List<SensorType> get sensorTypes;
  @override
  @JsonKey(ignore: true)
  _$$LabSessionImplCopyWith<_$LabSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
