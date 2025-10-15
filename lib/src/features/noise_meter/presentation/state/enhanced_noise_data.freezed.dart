// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enhanced_noise_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EnhancedNoiseMeterData {
  double get currentDecibels => throw _privateConstructorUsedError;
  double get minDecibels => throw _privateConstructorUsedError;
  double get maxDecibels => throw _privateConstructorUsedError;
  double get averageDecibels => throw _privateConstructorUsedError;
  bool get isRecording => throw _privateConstructorUsedError;
  NoiseLevel get noiseLevel => throw _privateConstructorUsedError;
  List<double> get recentReadings => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get hasPermission => throw _privateConstructorUsedError;
  int get totalReadings => throw _privateConstructorUsedError;
  Duration get sessionDuration => throw _privateConstructorUsedError;
  DateTime? get sessionStartTime => throw _privateConstructorUsedError;
  RecordingPreset? get activePreset => throw _privateConstructorUsedError;
  List<AcousticEvent> get events => throw _privateConstructorUsedError;
  Map<String, int> get timeInLevels => throw _privateConstructorUsedError;
  List<double> get allReadings =>
      throw _privateConstructorUsedError; // Store all readings for report
  List<AcousticReport> get savedReports => throw _privateConstructorUsedError;
  bool get isAnalyzing => throw _privateConstructorUsedError;
  List<double> get decibelHistory =>
      throw _privateConstructorUsedError; // For real-time chart
  AcousticReport? get lastGeneratedReport => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EnhancedNoiseMeterDataCopyWith<EnhancedNoiseMeterData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnhancedNoiseMeterDataCopyWith<$Res> {
  factory $EnhancedNoiseMeterDataCopyWith(EnhancedNoiseMeterData value,
          $Res Function(EnhancedNoiseMeterData) then) =
      _$EnhancedNoiseMeterDataCopyWithImpl<$Res, EnhancedNoiseMeterData>;
  @useResult
  $Res call(
      {double currentDecibels,
      double minDecibels,
      double maxDecibels,
      double averageDecibels,
      bool isRecording,
      NoiseLevel noiseLevel,
      List<double> recentReadings,
      String? errorMessage,
      bool hasPermission,
      int totalReadings,
      Duration sessionDuration,
      DateTime? sessionStartTime,
      RecordingPreset? activePreset,
      List<AcousticEvent> events,
      Map<String, int> timeInLevels,
      List<double> allReadings,
      List<AcousticReport> savedReports,
      bool isAnalyzing,
      List<double> decibelHistory,
      AcousticReport? lastGeneratedReport});

  $AcousticReportCopyWith<$Res>? get lastGeneratedReport;
}

/// @nodoc
class _$EnhancedNoiseMeterDataCopyWithImpl<$Res,
        $Val extends EnhancedNoiseMeterData>
    implements $EnhancedNoiseMeterDataCopyWith<$Res> {
  _$EnhancedNoiseMeterDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentDecibels = null,
    Object? minDecibels = null,
    Object? maxDecibels = null,
    Object? averageDecibels = null,
    Object? isRecording = null,
    Object? noiseLevel = null,
    Object? recentReadings = null,
    Object? errorMessage = freezed,
    Object? hasPermission = null,
    Object? totalReadings = null,
    Object? sessionDuration = null,
    Object? sessionStartTime = freezed,
    Object? activePreset = freezed,
    Object? events = null,
    Object? timeInLevels = null,
    Object? allReadings = null,
    Object? savedReports = null,
    Object? isAnalyzing = null,
    Object? decibelHistory = null,
    Object? lastGeneratedReport = freezed,
  }) {
    return _then(_value.copyWith(
      currentDecibels: null == currentDecibels
          ? _value.currentDecibels
          : currentDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      minDecibels: null == minDecibels
          ? _value.minDecibels
          : minDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      maxDecibels: null == maxDecibels
          ? _value.maxDecibels
          : maxDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      averageDecibels: null == averageDecibels
          ? _value.averageDecibels
          : averageDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      isRecording: null == isRecording
          ? _value.isRecording
          : isRecording // ignore: cast_nullable_to_non_nullable
              as bool,
      noiseLevel: null == noiseLevel
          ? _value.noiseLevel
          : noiseLevel // ignore: cast_nullable_to_non_nullable
              as NoiseLevel,
      recentReadings: null == recentReadings
          ? _value.recentReadings
          : recentReadings // ignore: cast_nullable_to_non_nullable
              as List<double>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      hasPermission: null == hasPermission
          ? _value.hasPermission
          : hasPermission // ignore: cast_nullable_to_non_nullable
              as bool,
      totalReadings: null == totalReadings
          ? _value.totalReadings
          : totalReadings // ignore: cast_nullable_to_non_nullable
              as int,
      sessionDuration: null == sessionDuration
          ? _value.sessionDuration
          : sessionDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      sessionStartTime: freezed == sessionStartTime
          ? _value.sessionStartTime
          : sessionStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      activePreset: freezed == activePreset
          ? _value.activePreset
          : activePreset // ignore: cast_nullable_to_non_nullable
              as RecordingPreset?,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<AcousticEvent>,
      timeInLevels: null == timeInLevels
          ? _value.timeInLevels
          : timeInLevels // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      allReadings: null == allReadings
          ? _value.allReadings
          : allReadings // ignore: cast_nullable_to_non_nullable
              as List<double>,
      savedReports: null == savedReports
          ? _value.savedReports
          : savedReports // ignore: cast_nullable_to_non_nullable
              as List<AcousticReport>,
      isAnalyzing: null == isAnalyzing
          ? _value.isAnalyzing
          : isAnalyzing // ignore: cast_nullable_to_non_nullable
              as bool,
      decibelHistory: null == decibelHistory
          ? _value.decibelHistory
          : decibelHistory // ignore: cast_nullable_to_non_nullable
              as List<double>,
      lastGeneratedReport: freezed == lastGeneratedReport
          ? _value.lastGeneratedReport
          : lastGeneratedReport // ignore: cast_nullable_to_non_nullable
              as AcousticReport?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AcousticReportCopyWith<$Res>? get lastGeneratedReport {
    if (_value.lastGeneratedReport == null) {
      return null;
    }

    return $AcousticReportCopyWith<$Res>(_value.lastGeneratedReport!, (value) {
      return _then(_value.copyWith(lastGeneratedReport: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EnhancedNoiseMeterDataImplCopyWith<$Res>
    implements $EnhancedNoiseMeterDataCopyWith<$Res> {
  factory _$$EnhancedNoiseMeterDataImplCopyWith(
          _$EnhancedNoiseMeterDataImpl value,
          $Res Function(_$EnhancedNoiseMeterDataImpl) then) =
      __$$EnhancedNoiseMeterDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double currentDecibels,
      double minDecibels,
      double maxDecibels,
      double averageDecibels,
      bool isRecording,
      NoiseLevel noiseLevel,
      List<double> recentReadings,
      String? errorMessage,
      bool hasPermission,
      int totalReadings,
      Duration sessionDuration,
      DateTime? sessionStartTime,
      RecordingPreset? activePreset,
      List<AcousticEvent> events,
      Map<String, int> timeInLevels,
      List<double> allReadings,
      List<AcousticReport> savedReports,
      bool isAnalyzing,
      List<double> decibelHistory,
      AcousticReport? lastGeneratedReport});

  @override
  $AcousticReportCopyWith<$Res>? get lastGeneratedReport;
}

/// @nodoc
class __$$EnhancedNoiseMeterDataImplCopyWithImpl<$Res>
    extends _$EnhancedNoiseMeterDataCopyWithImpl<$Res,
        _$EnhancedNoiseMeterDataImpl>
    implements _$$EnhancedNoiseMeterDataImplCopyWith<$Res> {
  __$$EnhancedNoiseMeterDataImplCopyWithImpl(
      _$EnhancedNoiseMeterDataImpl _value,
      $Res Function(_$EnhancedNoiseMeterDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentDecibels = null,
    Object? minDecibels = null,
    Object? maxDecibels = null,
    Object? averageDecibels = null,
    Object? isRecording = null,
    Object? noiseLevel = null,
    Object? recentReadings = null,
    Object? errorMessage = freezed,
    Object? hasPermission = null,
    Object? totalReadings = null,
    Object? sessionDuration = null,
    Object? sessionStartTime = freezed,
    Object? activePreset = freezed,
    Object? events = null,
    Object? timeInLevels = null,
    Object? allReadings = null,
    Object? savedReports = null,
    Object? isAnalyzing = null,
    Object? decibelHistory = null,
    Object? lastGeneratedReport = freezed,
  }) {
    return _then(_$EnhancedNoiseMeterDataImpl(
      currentDecibels: null == currentDecibels
          ? _value.currentDecibels
          : currentDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      minDecibels: null == minDecibels
          ? _value.minDecibels
          : minDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      maxDecibels: null == maxDecibels
          ? _value.maxDecibels
          : maxDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      averageDecibels: null == averageDecibels
          ? _value.averageDecibels
          : averageDecibels // ignore: cast_nullable_to_non_nullable
              as double,
      isRecording: null == isRecording
          ? _value.isRecording
          : isRecording // ignore: cast_nullable_to_non_nullable
              as bool,
      noiseLevel: null == noiseLevel
          ? _value.noiseLevel
          : noiseLevel // ignore: cast_nullable_to_non_nullable
              as NoiseLevel,
      recentReadings: null == recentReadings
          ? _value._recentReadings
          : recentReadings // ignore: cast_nullable_to_non_nullable
              as List<double>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      hasPermission: null == hasPermission
          ? _value.hasPermission
          : hasPermission // ignore: cast_nullable_to_non_nullable
              as bool,
      totalReadings: null == totalReadings
          ? _value.totalReadings
          : totalReadings // ignore: cast_nullable_to_non_nullable
              as int,
      sessionDuration: null == sessionDuration
          ? _value.sessionDuration
          : sessionDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      sessionStartTime: freezed == sessionStartTime
          ? _value.sessionStartTime
          : sessionStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      activePreset: freezed == activePreset
          ? _value.activePreset
          : activePreset // ignore: cast_nullable_to_non_nullable
              as RecordingPreset?,
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<AcousticEvent>,
      timeInLevels: null == timeInLevels
          ? _value._timeInLevels
          : timeInLevels // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      allReadings: null == allReadings
          ? _value._allReadings
          : allReadings // ignore: cast_nullable_to_non_nullable
              as List<double>,
      savedReports: null == savedReports
          ? _value._savedReports
          : savedReports // ignore: cast_nullable_to_non_nullable
              as List<AcousticReport>,
      isAnalyzing: null == isAnalyzing
          ? _value.isAnalyzing
          : isAnalyzing // ignore: cast_nullable_to_non_nullable
              as bool,
      decibelHistory: null == decibelHistory
          ? _value._decibelHistory
          : decibelHistory // ignore: cast_nullable_to_non_nullable
              as List<double>,
      lastGeneratedReport: freezed == lastGeneratedReport
          ? _value.lastGeneratedReport
          : lastGeneratedReport // ignore: cast_nullable_to_non_nullable
              as AcousticReport?,
    ));
  }
}

/// @nodoc

class _$EnhancedNoiseMeterDataImpl implements _EnhancedNoiseMeterData {
  const _$EnhancedNoiseMeterDataImpl(
      {this.currentDecibels = 0.0,
      this.minDecibels = double.infinity,
      this.maxDecibels = double.negativeInfinity,
      this.averageDecibels = 0.0,
      this.isRecording = false,
      this.noiseLevel = NoiseLevel.quiet,
      final List<double> recentReadings = const [],
      this.errorMessage,
      this.hasPermission = false,
      this.totalReadings = 0,
      this.sessionDuration = Duration.zero,
      this.sessionStartTime,
      this.activePreset,
      final List<AcousticEvent> events = const [],
      final Map<String, int> timeInLevels = const {},
      final List<double> allReadings = const [],
      final List<AcousticReport> savedReports = const [],
      this.isAnalyzing = false,
      final List<double> decibelHistory = const [],
      this.lastGeneratedReport})
      : _recentReadings = recentReadings,
        _events = events,
        _timeInLevels = timeInLevels,
        _allReadings = allReadings,
        _savedReports = savedReports,
        _decibelHistory = decibelHistory;

  @override
  @JsonKey()
  final double currentDecibels;
  @override
  @JsonKey()
  final double minDecibels;
  @override
  @JsonKey()
  final double maxDecibels;
  @override
  @JsonKey()
  final double averageDecibels;
  @override
  @JsonKey()
  final bool isRecording;
  @override
  @JsonKey()
  final NoiseLevel noiseLevel;
  final List<double> _recentReadings;
  @override
  @JsonKey()
  List<double> get recentReadings {
    if (_recentReadings is EqualUnmodifiableListView) return _recentReadings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentReadings);
  }

  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool hasPermission;
  @override
  @JsonKey()
  final int totalReadings;
  @override
  @JsonKey()
  final Duration sessionDuration;
  @override
  final DateTime? sessionStartTime;
  @override
  final RecordingPreset? activePreset;
  final List<AcousticEvent> _events;
  @override
  @JsonKey()
  List<AcousticEvent> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  final Map<String, int> _timeInLevels;
  @override
  @JsonKey()
  Map<String, int> get timeInLevels {
    if (_timeInLevels is EqualUnmodifiableMapView) return _timeInLevels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_timeInLevels);
  }

  final List<double> _allReadings;
  @override
  @JsonKey()
  List<double> get allReadings {
    if (_allReadings is EqualUnmodifiableListView) return _allReadings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allReadings);
  }

// Store all readings for report
  final List<AcousticReport> _savedReports;
// Store all readings for report
  @override
  @JsonKey()
  List<AcousticReport> get savedReports {
    if (_savedReports is EqualUnmodifiableListView) return _savedReports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_savedReports);
  }

  @override
  @JsonKey()
  final bool isAnalyzing;
  final List<double> _decibelHistory;
  @override
  @JsonKey()
  List<double> get decibelHistory {
    if (_decibelHistory is EqualUnmodifiableListView) return _decibelHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_decibelHistory);
  }

// For real-time chart
  @override
  final AcousticReport? lastGeneratedReport;

  @override
  String toString() {
    return 'EnhancedNoiseMeterData(currentDecibels: $currentDecibels, minDecibels: $minDecibels, maxDecibels: $maxDecibels, averageDecibels: $averageDecibels, isRecording: $isRecording, noiseLevel: $noiseLevel, recentReadings: $recentReadings, errorMessage: $errorMessage, hasPermission: $hasPermission, totalReadings: $totalReadings, sessionDuration: $sessionDuration, sessionStartTime: $sessionStartTime, activePreset: $activePreset, events: $events, timeInLevels: $timeInLevels, allReadings: $allReadings, savedReports: $savedReports, isAnalyzing: $isAnalyzing, decibelHistory: $decibelHistory, lastGeneratedReport: $lastGeneratedReport)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnhancedNoiseMeterDataImpl &&
            (identical(other.currentDecibels, currentDecibels) ||
                other.currentDecibels == currentDecibels) &&
            (identical(other.minDecibels, minDecibels) ||
                other.minDecibels == minDecibels) &&
            (identical(other.maxDecibels, maxDecibels) ||
                other.maxDecibels == maxDecibels) &&
            (identical(other.averageDecibels, averageDecibels) ||
                other.averageDecibels == averageDecibels) &&
            (identical(other.isRecording, isRecording) ||
                other.isRecording == isRecording) &&
            (identical(other.noiseLevel, noiseLevel) ||
                other.noiseLevel == noiseLevel) &&
            const DeepCollectionEquality()
                .equals(other._recentReadings, _recentReadings) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.hasPermission, hasPermission) ||
                other.hasPermission == hasPermission) &&
            (identical(other.totalReadings, totalReadings) ||
                other.totalReadings == totalReadings) &&
            (identical(other.sessionDuration, sessionDuration) ||
                other.sessionDuration == sessionDuration) &&
            (identical(other.sessionStartTime, sessionStartTime) ||
                other.sessionStartTime == sessionStartTime) &&
            (identical(other.activePreset, activePreset) ||
                other.activePreset == activePreset) &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            const DeepCollectionEquality()
                .equals(other._timeInLevels, _timeInLevels) &&
            const DeepCollectionEquality()
                .equals(other._allReadings, _allReadings) &&
            const DeepCollectionEquality()
                .equals(other._savedReports, _savedReports) &&
            (identical(other.isAnalyzing, isAnalyzing) ||
                other.isAnalyzing == isAnalyzing) &&
            const DeepCollectionEquality()
                .equals(other._decibelHistory, _decibelHistory) &&
            (identical(other.lastGeneratedReport, lastGeneratedReport) ||
                other.lastGeneratedReport == lastGeneratedReport));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        currentDecibels,
        minDecibels,
        maxDecibels,
        averageDecibels,
        isRecording,
        noiseLevel,
        const DeepCollectionEquality().hash(_recentReadings),
        errorMessage,
        hasPermission,
        totalReadings,
        sessionDuration,
        sessionStartTime,
        activePreset,
        const DeepCollectionEquality().hash(_events),
        const DeepCollectionEquality().hash(_timeInLevels),
        const DeepCollectionEquality().hash(_allReadings),
        const DeepCollectionEquality().hash(_savedReports),
        isAnalyzing,
        const DeepCollectionEquality().hash(_decibelHistory),
        lastGeneratedReport
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EnhancedNoiseMeterDataImplCopyWith<_$EnhancedNoiseMeterDataImpl>
      get copyWith => __$$EnhancedNoiseMeterDataImplCopyWithImpl<
          _$EnhancedNoiseMeterDataImpl>(this, _$identity);
}

abstract class _EnhancedNoiseMeterData implements EnhancedNoiseMeterData {
  const factory _EnhancedNoiseMeterData(
          {final double currentDecibels,
          final double minDecibels,
          final double maxDecibels,
          final double averageDecibels,
          final bool isRecording,
          final NoiseLevel noiseLevel,
          final List<double> recentReadings,
          final String? errorMessage,
          final bool hasPermission,
          final int totalReadings,
          final Duration sessionDuration,
          final DateTime? sessionStartTime,
          final RecordingPreset? activePreset,
          final List<AcousticEvent> events,
          final Map<String, int> timeInLevels,
          final List<double> allReadings,
          final List<AcousticReport> savedReports,
          final bool isAnalyzing,
          final List<double> decibelHistory,
          final AcousticReport? lastGeneratedReport}) =
      _$EnhancedNoiseMeterDataImpl;

  @override
  double get currentDecibels;
  @override
  double get minDecibels;
  @override
  double get maxDecibels;
  @override
  double get averageDecibels;
  @override
  bool get isRecording;
  @override
  NoiseLevel get noiseLevel;
  @override
  List<double> get recentReadings;
  @override
  String? get errorMessage;
  @override
  bool get hasPermission;
  @override
  int get totalReadings;
  @override
  Duration get sessionDuration;
  @override
  DateTime? get sessionStartTime;
  @override
  RecordingPreset? get activePreset;
  @override
  List<AcousticEvent> get events;
  @override
  Map<String, int> get timeInLevels;
  @override
  List<double> get allReadings;
  @override // Store all readings for report
  List<AcousticReport> get savedReports;
  @override
  bool get isAnalyzing;
  @override
  List<double> get decibelHistory;
  @override // For real-time chart
  AcousticReport? get lastGeneratedReport;
  @override
  @JsonKey(ignore: true)
  _$$EnhancedNoiseMeterDataImplCopyWith<_$EnhancedNoiseMeterDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
