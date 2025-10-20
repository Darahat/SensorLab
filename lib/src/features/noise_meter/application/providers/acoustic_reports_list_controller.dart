import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/noise_meter/application/notifiers/acoustic_reports_list_notifier.dart';
import 'package:sensorlab/src/features/noise_meter/application/state/acoustic_reports_list_state.dart';
import 'package:sensorlab/src/features/noise_meter/data/providers/acoustic_repository_provider.dart';

/// Provider for the AcousticReportsListController
final acousticReportsListProvider =
    StateNotifierProvider.autoDispose<
      AcousticReportsListController,
      AcousticReportsListState
    >((ref) {
      final repository = ref.watch(acousticRepositoryProvider);
      return AcousticReportsListController(repository);
    });
