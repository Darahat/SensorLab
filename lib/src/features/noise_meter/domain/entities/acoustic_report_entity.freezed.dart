// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'acoustic_report_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AcousticEvent {
  DateTime get timestamp => throw _privateConstructorUsedError;
  double get peakDecibels => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  String get eventType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AcousticEventCopyWith<AcousticEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AcousticEventCopyWith<$Res> {
  factory $AcousticEventCopyWith(
          AcousticEvent value, $Res Function(AcousticEvent) then) =
      _$AcousticEventCopyWithImpl<$Res, AcousticEvent>;
  @useResult
  $Res call(
      {DateTime timestamp,
      double peakDecibels,
      Duration duration,
      String eventType});
}

/// @nodoc
class _$AcousticEventCopyWithImpl<$Res, $Val extends AcousticEvent>
    implements $AcousticEventCopyWith<$Res> {
  _$AcousticEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? peakDecibels = null,
    Object? duration = null,
    Object? eventType = null,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      peakDecibels: null == peakDecibels
          ? _value.peakDecibels
          : peakDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AcousticEventImplCopyWith<$Res>
    implements $AcousticEventCopyWith<$Res> {
  factory _$$AcousticEventImplCopyWith(
          _$AcousticEventImpl value, $Res Function(_$AcousticEventImpl) then) =
      __$$AcousticEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime timestamp,
      double peakDecibels,
      Duration duration,
      String eventType});
}

/// @nodoc
class __$$AcousticEventImplCopyWithImpl<$Res>
    extends _$AcousticEventCopyWithImpl<$Res, _$AcousticEventImpl>
    implements _$$AcousticEventImplCopyWith<$Res> {
  __$$AcousticEventImplCopyWithImpl(
      _$AcousticEventImpl _value, $Res Function(_$AcousticEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? peakDecibels = null,
    Object? duration = null,
    Object? eventType = null,
  }) {
    return _then(_$AcousticEventImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      peakDecibels: null == peakDecibels
          ? _value.peakDecibels
          : peakDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AcousticEventImpl implements _AcousticEvent {
  const _$AcousticEventImpl(
      {required this.timestamp,
      required this.peakDecibels,
      required this.duration,
      required this.eventType});

  @override
  final DateTime timestamp;
  @override
  final double peakDecibels;
  @override
  final Duration duration;
  @override
  final String eventType;

  @override
  String toString() {
    return 'AcousticEvent(timestamp: $timestamp, peakDecibels: $peakDecibels, duration: $duration, eventType: $eventType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AcousticEventImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.peakDecibels, peakDecibels) ||
                other.peakDecibels == peakDecibels) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, timestamp, peakDecibels, duration, eventType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AcousticEventImplCopyWith<_$AcousticEventImpl> get copyWith =>
      __$$AcousticEventImplCopyWithImpl<_$AcousticEventImpl>(this, _$identity);
}

abstract class _AcousticEvent implements AcousticEvent {
  const factory _AcousticEvent(
      {required final DateTime timestamp,
      required final double peakDecibels,
      required final Duration duration,
      required final String eventType}) = _$AcousticEventImpl;

  @override
  DateTime get timestamp;
  @override
  double get peakDecibels;
  @override
  Duration get duration;
  @override
  String get eventType;
  @override
  @JsonKey(ignore: true)
  _$$AcousticEventImplCopyWith<_$AcousticEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AcousticReport {
  String get id => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  RecordingPreset get preset => throw _privateConstructorUsedError;
  double get averageDecibels => throw _privateConstructorUsedError;
  double get minDecibels => throw _privateConstructorUsedError;
  double get maxDecibels => throw _privateConstructorUsedError;
  List<AcousticEvent> get events => throw _privateConstructorUsedError;
  Map<String, int> get timeInLevels => throw _privateConstructorUsedError;
  List<double> get hourlyAverages => throw _privateConstructorUsedError;
  String get environmentQuality => throw _privateConstructorUsedError;
  String get recommendation => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AcousticReportCopyWith<AcousticReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AcousticReportCopyWith<$Res> {
  factory $AcousticReportCopyWith(
          AcousticReport value, $Res Function(AcousticReport) then) =
      _$AcousticReportCopyWithImpl<$Res, AcousticReport>;
  @useResult
  $Res call(
      {String id,
      DateTime startTime,
      DateTime endTime,
      Duration duration,
      RecordingPreset preset,
      double averageDecibels,
      double minDecibels,
      double maxDecibels,
      List<AcousticEvent> events,
      Map<String, int> timeInLevels,
      List<double> hourlyAverages,
      String environmentQuality,
      String recommendation});
}

/// @nodoc
class _$AcousticReportCopyWithImpl<$Res, $Val extends AcousticReport>
    implements $AcousticReportCopyWith<$Res> {
  _$AcousticReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? duration = null,
    Object? preset = null,
    Object? averageDecibels = null,
    Object? minDecibels = null,
    Object? maxDecibels = null,
    Object? events = null,
    Object? timeInLevels = null,
    Object? hourlyAverages = null,
    Object? environmentQuality = null,
    Object? recommendation = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      preset: null == preset
          ? _value.preset
          : preset // ignore: cast_nullable_to_non_nullable
              as RecordingPreset,
      averageDecibels: null == averageDecibels
          ? _value.averageDecibels
          : averageDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      minDecibels: null == minDecibels
          ? _value.minDecibels
          : minDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      maxDecibels: null == maxDecibels
          ? _value.maxDecibels
          : maxDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<AcousticEvent>,
      timeInLevels: null == timeInLevels
          ? _value.timeInLevels
          : timeInLevels // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      hourlyAverages: null == hourlyAverages
          ? _value.hourlyAverages
          : hourlyAverages // ignore: cast_nullable_to_non_nullable
              as List<double>,
      environmentQuality: null == environmentQuality
          ? _value.environmentQuality
          : environmentQuality // ignore: cast_nullable_to_non_nullable
              as String,
      recommendation: null == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AcousticReportImplCopyWith<$Res>
    implements $AcousticReportCopyWith<$Res> {
  factory _$$AcousticReportImplCopyWith(_$AcousticReportImpl value,
          $Res Function(_$AcousticReportImpl) then) =
      __$$AcousticReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime startTime,
      DateTime endTime,
      Duration duration,
      RecordingPreset preset,
      double averageDecibels,
      double minDecibels,
      double maxDecibels,
      List<AcousticEvent> events,
      Map<String, int> timeInLevels,
      List<double> hourlyAverages,
      String environmentQuality,
      String recommendation});
}

/// @nodoc
class __$$AcousticReportImplCopyWithImpl<$Res>
    extends _$AcousticReportCopyWithImpl<$Res, _$AcousticReportImpl>
    implements _$$AcousticReportImplCopyWith<$Res> {
  __$$AcousticReportImplCopyWithImpl(
      _$AcousticReportImpl _value, $Res Function(_$AcousticReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? duration = null,
    Object? preset = null,
    Object? averageDecibels = null,
    Object? minDecibels = null,
    Object? maxDecibels = null,
    Object? events = null,
    Object? timeInLevels = null,
    Object? hourlyAverages = null,
    Object? environmentQuality = null,
    Object? recommendation = null,
  }) {
    return _then(_$AcousticReportImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      preset: null == preset
          ? _value.preset
          : preset // ignore: cast_nullable_to_non_nullable
              as RecordingPreset,
      averageDecibels: null == averageDecibels
          ? _value.averageDecibels
          : averageDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      minDecibels: null == minDecibels
          ? _value.minDecibels
          : minDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      maxDecibels: null == maxDecibels
          ? _value.maxDecibels
          : maxDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<AcousticEvent>,
      timeInLevels: null == timeInLevels
          ? _value._timeInLevels
          : timeInLevels // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      hourlyAverages: null == hourlyAverages
          ? _value._hourlyAverages
          : hourlyAverages // ignore: cast_nullable_to_non_nullable
              as List<double>,
      environmentQuality: null == environmentQuality
          ? _value.environmentQuality
          : environmentQuality // ignore: cast_nullable_to_non_nullable
              as String,
      recommendation: null == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AcousticReportImpl extends _AcousticReport {
  const _$AcousticReportImpl(
      {required this.id,
      required this.startTime,
      required this.endTime,
      required this.duration,
      required this.preset,
      required this.averageDecibels,
      required this.minDecibels,
      required this.maxDecibels,
      required final List<AcousticEvent> events,
      required final Map<String, int> timeInLevels,
      required final List<double> hourlyAverages,
      required this.environmentQuality,
      required this.recommendation})
      : _events = events,
        _timeInLevels = timeInLevels,
        _hourlyAverages = hourlyAverages,
        super._();

  @override
  final String id;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final Duration duration;
  @override
  final RecordingPreset preset;
  @override
  final double averageDecibels;
  @override
  final double minDecibels;
  @override
  final double maxDecibels;
  final List<AcousticEvent> _events;
  @override
  List<AcousticEvent> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  final Map<String, int> _timeInLevels;
  @override
  Map<String, int> get timeInLevels {
    if (_timeInLevels is EqualUnmodifiableMapView) return _timeInLevels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_timeInLevels);
  }

  final List<double> _hourlyAverages;
  @override
  List<double> get hourlyAverages {
    if (_hourlyAverages is EqualUnmodifiableListView) return _hourlyAverages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hourlyAverages);
  }

  @override
  final String environmentQuality;
  @override
  final String recommendation;

  @override
  String toString() {
    return 'AcousticReport(id: $id, startTime: $startTime, endTime: $endTime, duration: $duration, preset: $preset, averageDecibels: $averageDecibels, minDecibels: $minDecibels, maxDecibels: $maxDecibels, events: $events, timeInLevels: $timeInLevels, hourlyAverages: $hourlyAverages, environmentQuality: $environmentQuality, recommendation: $recommendation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AcousticReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.preset, preset) || other.preset == preset) &&
            (identical(other.averageDecibels, averageDecibels) ||
                other.averageDecibels == averageDecibels) &&
            (identical(other.minDecibels, minDecibels) ||
                other.minDecibels == minDecibels) &&
            (identical(other.maxDecibels, maxDecibels) ||
                other.maxDecibels == maxDecibels) &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            const DeepCollectionEquality()
                .equals(other._timeInLevels, _timeInLevels) &&
            const DeepCollectionEquality()
                .equals(other._hourlyAverages, _hourlyAverages) &&
            (identical(other.environmentQuality, environmentQuality) ||
                other.environmentQuality == environmentQuality) &&
            (identical(other.recommendation, recommendation) ||
                other.recommendation == recommendation));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      startTime,
      endTime,
      duration,
      preset,
      averageDecibels,
      minDecibels,
      maxDecibels,
      const DeepCollectionEquality().hash(_events),
      const DeepCollectionEquality().hash(_timeInLevels),
      const DeepCollectionEquality().hash(_hourlyAverages),
      environmentQuality,
      recommendation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AcousticReportImplCopyWith<_$AcousticReportImpl> get copyWith =>
      __$$AcousticReportImplCopyWithImpl<_$AcousticReportImpl>(
          this, _$identity);
}

abstract class _AcousticReport extends AcousticReport {
  const factory _AcousticReport(
      {required final String id,
      required final DateTime startTime,
      required final DateTime endTime,
      required final Duration duration,
      required final RecordingPreset preset,
      required final double averageDecibels,
      required final double minDecibels,
      required final double maxDecibels,
      required final List<AcousticEvent> events,
      required final Map<String, int> timeInLevels,
      required final List<double> hourlyAverages,
      required final String environmentQuality,
      required final String recommendation}) = _$AcousticReportImpl;
  const _AcousticReport._() : super._();

  @override
  String get id;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  Duration get duration;
  @override
  RecordingPreset get preset;
  @override
  double get averageDecibels;
  @override
  double get minDecibels;
  @override
  double get maxDecibels;
  @override
  List<AcousticEvent> get events;
  @override
  Map<String, int> get timeInLevels;
  @override
  List<double> get hourlyAverages;
  @override
  String get environmentQuality;
  @override
  String get recommendation;
  @override
  @JsonKey(ignore: true)
  _$$AcousticReportImplCopyWith<_$AcousticReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
