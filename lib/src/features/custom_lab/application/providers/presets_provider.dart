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

class PresetsInitializationNotifier
    extends StateNotifier<PresetsInitializationState> {
  final InitializePresetsUseCase _useCase;

  PresetsInitializationNotifier(this._useCase)
    : super(const PresetsInitializationState());

  Future<void> initializePresets() async {
    print('🚀 Starting presets initialization...');
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _useCase.initializePresets();
      state = state.copyWith(isInitialized: true, isLoading: false);
      print('✅ Presets initialization completed successfully');
    } catch (e) {
      print('❌ Presets initialization failed: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> checkInitialization() async {
    try {
      final isInitialized = await _useCase.arePresetsInitialized();
      print('🔍 Presets initialization check: $isInitialized');
      state = state.copyWith(isInitialized: isInitialized);
    } catch (e) {
      print('❌ Error checking presets initialization: $e');
      state = state.copyWith(errorMessage: e.toString());
    }
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
