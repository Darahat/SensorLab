// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lab_monitoring_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LabMonitoringState {
  bool get isRecording => throw _privateConstructorUsedError;
  bool get isPaused => throw _privateConstructorUsedError;
  bool get isAnalyzing => throw _privateConstructorUsedError;
  Lab? get activeLab => throw _privateConstructorUsedError;
  LabSession? get activeSession => throw _privateConstructorUsedError;
  int get elapsedSeconds => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LabMonitoringStateCopyWith<LabMonitoringState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabMonitoringStateCopyWith<$Res> {
  factory $LabMonitoringStateCopyWith(
          LabMonitoringState value, $Res Function(LabMonitoringState) then) =
      _$LabMonitoringStateCopyWithImpl<$Res, LabMonitoringState>;
  @useResult
  $Res call(
      {bool isRecording,
      bool isPaused,
      bool isAnalyzing,
      Lab? activeLab,
      LabSession? activeSession,
      int elapsedSeconds,
      String? errorMessage});

  $LabCopyWith<$Res>? get activeLab;
  $LabSessionCopyWith<$Res>? get activeSession;
}

/// @nodoc
class _$LabMonitoringStateCopyWithImpl<$Res, $Val extends LabMonitoringState>
    implements $LabMonitoringStateCopyWith<$Res> {
  _$LabMonitoringStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRecording = null,
    Object? isPaused = null,
    Object? isAnalyzing = null,
    Object? activeLab = freezed,
    Object? activeSession = freezed,
    Object? elapsedSeconds = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      isRecording: null == isRecording
          ? _value.isRecording
          : isRecording // ignore: cast_nullable_to_non_nullable
              as bool,
      isPaused: null == isPaused
          ? _value.isPaused
          : isPaused // ignore: cast_nullable_to_non_nullable
              as bool,
      isAnalyzing: null == isAnalyzing
          ? _value.isAnalyzing
          : isAnalyzing // ignore: cast_nullable_to_non_nullable
              as bool,
      activeLab: freezed == activeLab
          ? _value.activeLab
          : activeLab // ignore: cast_nullable_to_non_nullable
              as Lab?,
      activeSession: freezed == activeSession
          ? _value.activeSession
          : activeSession // ignore: cast_nullable_to_non_nullable
              as LabSession?,
      elapsedSeconds: null == elapsedSeconds
          ? _value.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LabCopyWith<$Res>? get activeLab {
    if (_value.activeLab == null) {
      return null;
    }

    return $LabCopyWith<$Res>(_value.activeLab!, (value) {
      return _then(_value.copyWith(activeLab: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LabSessionCopyWith<$Res>? get activeSession {
    if (_value.activeSession == null) {
      return null;
    }

    return $LabSessionCopyWith<$Res>(_value.activeSession!, (value) {
      return _then(_value.copyWith(activeSession: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LabMonitoringStateImplCopyWith<$Res>
    implements $LabMonitoringStateCopyWith<$Res> {
  factory _$$LabMonitoringStateImplCopyWith(_$LabMonitoringStateImpl value,
          $Res Function(_$LabMonitoringStateImpl) then) =
      __$$LabMonitoringStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isRecording,
      bool isPaused,
      bool isAnalyzing,
      Lab? activeLab,
      LabSession? activeSession,
      int elapsedSeconds,
      String? errorMessage});

  @override
  $LabCopyWith<$Res>? get activeLab;
  @override
  $LabSessionCopyWith<$Res>? get activeSession;
}

/// @nodoc
class __$$LabMonitoringStateImplCopyWithImpl<$Res>
    extends _$LabMonitoringStateCopyWithImpl<$Res, _$LabMonitoringStateImpl>
    implements _$$LabMonitoringStateImplCopyWith<$Res> {
  __$$LabMonitoringStateImplCopyWithImpl(_$LabMonitoringStateImpl _value,
      $Res Function(_$LabMonitoringStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRecording = null,
    Object? isPaused = null,
    Object? isAnalyzing = null,
    Object? activeLab = freezed,
    Object? activeSession = freezed,
    Object? elapsedSeconds = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$LabMonitoringStateImpl(
      isRecording: null == isRecording
          ? _value.isRecording
          : isRecording // ignore: cast_nullable_to_non_nullable
              as bool,
      isPaused: null == isPaused
          ? _value.isPaused
          : isPaused // ignore: cast_nullable_to_non_nullable
              as bool,
      isAnalyzing: null == isAnalyzing
          ? _value.isAnalyzing
          : isAnalyzing // ignore: cast_nullable_to_non_nullable
              as bool,
      activeLab: freezed == activeLab
          ? _value.activeLab
          : activeLab // ignore: cast_nullable_to_non_nullable
              as Lab?,
      activeSession: freezed == activeSession
          ? _value.activeSession
          : activeSession // ignore: cast_nullable_to_non_nullable
              as LabSession?,
      elapsedSeconds: null == elapsedSeconds
          ? _value.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LabMonitoringStateImpl implements _LabMonitoringState {
  const _$LabMonitoringStateImpl(
      {this.isRecording = false,
      this.isPaused = false,
      this.isAnalyzing = false,
      this.activeLab,
      this.activeSession,
      this.elapsedSeconds = 0,
      this.errorMessage});

  @override
  @JsonKey()
  final bool isRecording;
  @override
  @JsonKey()
  final bool isPaused;
  @override
  @JsonKey()
  final bool isAnalyzing;
  @override
  final Lab? activeLab;
  @override
  final LabSession? activeSession;
  @override
  @JsonKey()
  final int elapsedSeconds;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'LabMonitoringState(isRecording: $isRecording, isPaused: $isPaused, isAnalyzing: $isAnalyzing, activeLab: $activeLab, activeSession: $activeSession, elapsedSeconds: $elapsedSeconds, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabMonitoringStateImpl &&
            (identical(other.isRecording, isRecording) ||
                other.isRecording == isRecording) &&
            (identical(other.isPaused, isPaused) ||
                other.isPaused == isPaused) &&
            (identical(other.isAnalyzing, isAnalyzing) ||
                other.isAnalyzing == isAnalyzing) &&
            (identical(other.activeLab, activeLab) ||
                other.activeLab == activeLab) &&
            (identical(other.activeSession, activeSession) ||
                other.activeSession == activeSession) &&
            (identical(other.elapsedSeconds, elapsedSeconds) ||
                other.elapsedSeconds == elapsedSeconds) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isRecording, isPaused,
      isAnalyzing, activeLab, activeSession, elapsedSeconds, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LabMonitoringStateImplCopyWith<_$LabMonitoringStateImpl> get copyWith =>
      __$$LabMonitoringStateImplCopyWithImpl<_$LabMonitoringStateImpl>(
          this, _$identity);
}

abstract class _LabMonitoringState implements LabMonitoringState {
  const factory _LabMonitoringState(
      {final bool isRecording,
      final bool isPaused,
      final bool isAnalyzing,
      final Lab? activeLab,
      final LabSession? activeSession,
      final int elapsedSeconds,
      final String? errorMessage}) = _$LabMonitoringStateImpl;

  @override
  bool get isRecording;
  @override
  bool get isPaused;
  @override
  bool get isAnalyzing;
  @override
  Lab? get activeLab;
  @override
  LabSession? get activeSession;
  @override
  int get elapsedSeconds;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$LabMonitoringStateImplCopyWith<_$LabMonitoringStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
