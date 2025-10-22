import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_repository_provider.dart';
import 'package:sensorlab/src/features/custom_lab/application/use_cases/initialize_presets_use_case.dart';

/// Provider for InitializePresetsUseCase
final initializePresetsUseCaseProvider = Provider<InitializePresetsUseCase>((
  ref,
) {
  final repository = ref.watch(labRepositoryProvider);
  return InitializePresetsUseCase(repository);
});

/// State for presets initialization
class PresetsInitializationState {
  final bool isInitialized;
  final bool isLoading;
  final String? errorMessage;

  const PresetsInitializationState({
    this.isInitialized = false,
    this.isLoading = false,
    this.errorMessage,
  });

  PresetsInitializationState copyWith({
    bool? isInitialized,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PresetsInitializationState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// StateNotifier for presets initialization
class PresetsInitializationNotifier
    extends StateNotifier<PresetsInitializationState> {
  final InitializePresetsUseCase _useCase;

  PresetsInitializationNotifier(this._useCase)
    : super(const PresetsInitializationState());

  /// Initialize presets if they don't exist
  Future<void> initializePresets() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _useCase.initializePresets();
      state = state.copyWith(isInitialized: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Check if presets are initialized
  Future<void> checkInitialization() async {
    try {
      final isInitialized = await _useCase.arePresetsInitialized();
      state = state.copyWith(isInitialized: isInitialized);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Reset all presets
  Future<bool> resetPresets() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _useCase.resetPresets();
      state = state.copyWith(isInitialized: true, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for presets initialization state
final presetsInitializationProvider =
    StateNotifierProvider<
      PresetsInitializationNotifier,
      PresetsInitializationState
    >((ref) {
      final useCase = ref.watch(initializePresetsUseCaseProvider);
      return PresetsInitializationNotifier(useCase);
    });

/// Provider to check if presets are initialized
final arePresetsInitializedProvider = FutureProvider<bool>((ref) async {
  final useCase = ref.watch(initializePresetsUseCaseProvider);
  return useCase.arePresetsInitialized();
});
