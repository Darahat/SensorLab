// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lab.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Lab _$LabFromJson(Map<String, dynamic> json) {
  return _Lab.fromJson(json);
}

/// @nodoc
mixin _$Lab {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get description => throw _privateConstructorUsedError;
  @HiveField(3)
  List<SensorType> get sensors => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get isPreset => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get iconName => throw _privateConstructorUsedError;
  @HiveField(8)
  int? get colorValue => throw _privateConstructorUsedError;
  @HiveField(9)
  int get recordingInterval => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LabCopyWith<Lab> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabCopyWith<$Res> {
  factory $LabCopyWith(Lab value, $Res Function(Lab) then) =
      _$LabCopyWithImpl<$Res, Lab>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String description,
      @HiveField(3) List<SensorType> sensors,
      @HiveField(4) DateTime createdAt,
      @HiveField(5) DateTime updatedAt,
      @HiveField(6) bool isPreset,
      @HiveField(7) String? iconName,
      @HiveField(8) int? colorValue,
      @HiveField(9) int recordingInterval});
}

/// @nodoc
class _$LabCopyWithImpl<$Res, $Val extends Lab> implements $LabCopyWith<$Res> {
  _$LabCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? sensors = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isPreset = null,
    Object? iconName = freezed,
    Object? colorValue = freezed,
    Object? recordingInterval = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      sensors: null == sensors
          ? _value.sensors
          : sensors // ignore: cast_nullable_to_non_nullable
              as List<SensorType>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isPreset: null == isPreset
          ? _value.isPreset
          : isPreset // ignore: cast_nullable_to_non_nullable
              as bool,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      colorValue: freezed == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int?,
      recordingInterval: null == recordingInterval
          ? _value.recordingInterval
          : recordingInterval // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LabImplCopyWith<$Res> implements $LabCopyWith<$Res> {
  factory _$$LabImplCopyWith(_$LabImpl value, $Res Function(_$LabImpl) then) =
      __$$LabImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String description,
      @HiveField(3) List<SensorType> sensors,
      @HiveField(4) DateTime createdAt,
      @HiveField(5) DateTime updatedAt,
      @HiveField(6) bool isPreset,
      @HiveField(7) String? iconName,
      @HiveField(8) int? colorValue,
      @HiveField(9) int recordingInterval});
}

/// @nodoc
class __$$LabImplCopyWithImpl<$Res> extends _$LabCopyWithImpl<$Res, _$LabImpl>
    implements _$$LabImplCopyWith<$Res> {
  __$$LabImplCopyWithImpl(_$LabImpl _value, $Res Function(_$LabImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? sensors = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isPreset = null,
    Object? iconName = freezed,
    Object? colorValue = freezed,
    Object? recordingInterval = null,
  }) {
    return _then(_$LabImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      sensors: null == sensors
          ? _value._sensors
          : sensors // ignore: cast_nullable_to_non_nullable
              as List<SensorType>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isPreset: null == isPreset
          ? _value.isPreset
          : isPreset // ignore: cast_nullable_to_non_nullable
              as bool,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      colorValue: freezed == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int?,
      recordingInterval: null == recordingInterval
          ? _value.recordingInterval
          : recordingInterval // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LabImpl implements _Lab {
  const _$LabImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.description,
      @HiveField(3) required final List<SensorType> sensors,
      @HiveField(4) required this.createdAt,
      @HiveField(5) required this.updatedAt,
      @HiveField(6) this.isPreset = false,
      @HiveField(7) this.iconName,
      @HiveField(8) this.colorValue,
      @HiveField(9) this.recordingInterval = 100})
      : _sensors = sensors;

  factory _$LabImpl.fromJson(Map<String, dynamic> json) =>
      _$$LabImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String description;
  final List<SensorType> _sensors;
  @override
  @HiveField(3)
  List<SensorType> get sensors {
    if (_sensors is EqualUnmodifiableListView) return _sensors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sensors);
  }

  @override
  @HiveField(4)
  final DateTime createdAt;
  @override
  @HiveField(5)
  final DateTime updatedAt;
  @override
  @JsonKey()
  @HiveField(6)
  final bool isPreset;
  @override
  @HiveField(7)
  final String? iconName;
  @override
  @HiveField(8)
  final int? colorValue;
  @override
  @JsonKey()
  @HiveField(9)
  final int recordingInterval;

  @override
  String toString() {
    return 'Lab(id: $id, name: $name, description: $description, sensors: $sensors, createdAt: $createdAt, updatedAt: $updatedAt, isPreset: $isPreset, iconName: $iconName, colorValue: $colorValue, recordingInterval: $recordingInterval)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._sensors, _sensors) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isPreset, isPreset) ||
                other.isPreset == isPreset) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue) &&
            (identical(other.recordingInterval, recordingInterval) ||
                other.recordingInterval == recordingInterval));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      const DeepCollectionEquality().hash(_sensors),
      createdAt,
      updatedAt,
      isPreset,
      iconName,
      colorValue,
      recordingInterval);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LabImplCopyWith<_$LabImpl> get copyWith =>
      __$$LabImplCopyWithImpl<_$LabImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LabImplToJson(
      this,
    );
  }
}

abstract class _Lab implements Lab {
  const factory _Lab(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) required final String description,
      @HiveField(3) required final List<SensorType> sensors,
      @HiveField(4) required final DateTime createdAt,
      @HiveField(5) required final DateTime updatedAt,
      @HiveField(6) final bool isPreset,
      @HiveField(7) final String? iconName,
      @HiveField(8) final int? colorValue,
      @HiveField(9) final int recordingInterval}) = _$LabImpl;

  factory _Lab.fromJson(Map<String, dynamic> json) = _$LabImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get description;
  @override
  @HiveField(3)
  List<SensorType> get sensors;
  @override
  @HiveField(4)
  DateTime get createdAt;
  @override
  @HiveField(5)
  DateTime get updatedAt;
  @override
  @HiveField(6)
  bool get isPreset;
  @override
  @HiveField(7)
  String? get iconName;
  @override
  @HiveField(8)
  int? get colorValue;
  @override
  @HiveField(9)
  int get recordingInterval;
  @override
  @JsonKey(ignore: true)
  _$$LabImplCopyWith<_$LabImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
