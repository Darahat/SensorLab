// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'acoustic_reports_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AcousticReportsListState {
  List<AcousticReport> get reports => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  RecordingPreset? get filterPreset => throw _privateConstructorUsedError;
  Set<String> get selectedReportIds => throw _privateConstructorUsedError;
  bool get isSelectionMode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AcousticReportsListStateCopyWith<AcousticReportsListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AcousticReportsListStateCopyWith<$Res> {
  factory $AcousticReportsListStateCopyWith(
    AcousticReportsListState value,
    $Res Function(AcousticReportsListState) then,
  ) = _$AcousticReportsListStateCopyWithImpl<$Res, AcousticReportsListState>;
  @useResult
  $Res call({
    List<AcousticReport> reports,
    bool isLoading,
    RecordingPreset? filterPreset,
    Set<String> selectedReportIds,
    bool isSelectionMode,
  });
}

/// @nodoc
class _$AcousticReportsListStateCopyWithImpl<
  $Res,
  $Val extends AcousticReportsListState
>
    implements $AcousticReportsListStateCopyWith<$Res> {
  _$AcousticReportsListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reports = null,
    Object? isLoading = null,
    Object? filterPreset = freezed,
    Object? selectedReportIds = null,
    Object? isSelectionMode = null,
  }) {
    return _then(
      _value.copyWith(
            reports: null == reports
                ? _value.reports
                : reports // ignore: cast_nullable_to_non_nullable
                      as List<AcousticReport>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            filterPreset: freezed == filterPreset
                ? _value.filterPreset
                : filterPreset // ignore: cast_nullable_to_non_nullable
                      as RecordingPreset?,
            selectedReportIds: null == selectedReportIds
                ? _value.selectedReportIds
                : selectedReportIds // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            isSelectionMode: null == isSelectionMode
                ? _value.isSelectionMode
                : isSelectionMode // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AcousticReportsListStateImplCopyWith<$Res>
    implements $AcousticReportsListStateCopyWith<$Res> {
  factory _$$AcousticReportsListStateImplCopyWith(
    _$AcousticReportsListStateImpl value,
    $Res Function(_$AcousticReportsListStateImpl) then,
  ) = __$$AcousticReportsListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<AcousticReport> reports,
    bool isLoading,
    RecordingPreset? filterPreset,
    Set<String> selectedReportIds,
    bool isSelectionMode,
  });
}

/// @nodoc
class __$$AcousticReportsListStateImplCopyWithImpl<$Res>
    extends
        _$AcousticReportsListStateCopyWithImpl<
          $Res,
          _$AcousticReportsListStateImpl
        >
    implements _$$AcousticReportsListStateImplCopyWith<$Res> {
  __$$AcousticReportsListStateImplCopyWithImpl(
    _$AcousticReportsListStateImpl _value,
    $Res Function(_$AcousticReportsListStateImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reports = null,
    Object? isLoading = null,
    Object? filterPreset = freezed,
    Object? selectedReportIds = null,
    Object? isSelectionMode = null,
  }) {
    return _then(
      _$AcousticReportsListStateImpl(
        reports: null == reports
            ? _value._reports
            : reports // ignore: cast_nullable_to_non_nullable
                  as List<AcousticReport>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        filterPreset: freezed == filterPreset
            ? _value.filterPreset
            : filterPreset // ignore: cast_nullable_to_non_nullable
                  as RecordingPreset?,
        selectedReportIds: null == selectedReportIds
            ? _value._selectedReportIds
            : selectedReportIds // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        isSelectionMode: null == isSelectionMode
            ? _value.isSelectionMode
            : isSelectionMode // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$AcousticReportsListStateImpl extends _AcousticReportsListState
    with DiagnosticableTreeMixin {
  const _$AcousticReportsListStateImpl({
    final List<AcousticReport> reports = const [],
    this.isLoading = true,
    this.filterPreset,
    final Set<String> selectedReportIds = const {},
    this.isSelectionMode = false,
  }) : _reports = reports,
       _selectedReportIds = selectedReportIds,
       super._();

  final List<AcousticReport> _reports;
  @override
  @JsonKey()
  List<AcousticReport> get reports {
    if (_reports is EqualUnmodifiableListView) return _reports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reports);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final RecordingPreset? filterPreset;
  final Set<String> _selectedReportIds;
  @override
  @JsonKey()
  Set<String> get selectedReportIds {
    if (_selectedReportIds is EqualUnmodifiableSetView)
      return _selectedReportIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedReportIds);
  }

  @override
  @JsonKey()
  final bool isSelectionMode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AcousticReportsListState(reports: $reports, isLoading: $isLoading, filterPreset: $filterPreset, selectedReportIds: $selectedReportIds, isSelectionMode: $isSelectionMode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AcousticReportsListState'))
      ..add(DiagnosticsProperty('reports', reports))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('filterPreset', filterPreset))
      ..add(DiagnosticsProperty('selectedReportIds', selectedReportIds))
      ..add(DiagnosticsProperty('isSelectionMode', isSelectionMode));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AcousticReportsListStateImpl &&
            const DeepCollectionEquality().equals(other._reports, _reports) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.filterPreset, filterPreset) ||
                other.filterPreset == filterPreset) &&
            const DeepCollectionEquality().equals(
              other._selectedReportIds,
              _selectedReportIds,
            ) &&
            (identical(other.isSelectionMode, isSelectionMode) ||
                other.isSelectionMode == isSelectionMode));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_reports),
    isLoading,
    filterPreset,
    const DeepCollectionEquality().hash(_selectedReportIds),
    isSelectionMode,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AcousticReportsListStateImplCopyWith<_$AcousticReportsListStateImpl>
  get copyWith =>
      __$$AcousticReportsListStateImplCopyWithImpl<
        _$AcousticReportsListStateImpl
      >(this, _$identity);
}

abstract class _AcousticReportsListState extends AcousticReportsListState {
  const factory _AcousticReportsListState({
    final List<AcousticReport> reports,
    final bool isLoading,
    final RecordingPreset? filterPreset,
    final Set<String> selectedReportIds,
    final bool isSelectionMode,
  }) = _$AcousticReportsListStateImpl;
  const _AcousticReportsListState._() : super._();

  @override
  List<AcousticReport> get reports;
  @override
  bool get isLoading;
  @override
  RecordingPreset? get filterPreset;
  @override
  Set<String> get selectedReportIds;
  @override
  bool get isSelectionMode;
  @override
  @JsonKey(ignore: true)
  _$$AcousticReportsListStateImplCopyWith<_$AcousticReportsListStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
