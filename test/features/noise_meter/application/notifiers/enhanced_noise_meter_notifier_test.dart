import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/noise_meter/application/notifiers/enhanced_noise_meter_notifier.dart';
import 'package:sensorlab/src/features/noise_meter/application/state/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/domain/repositories/acoustic_repository.dart';
import 'dart:async'; // For StreamController
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:sensorlab/src/features/noise_meter/application/providers/enhanced_noise_meter_provider.dart'; // Import the provider

import 'enhanced_noise_meter_notifier_test.mocks.dart';

@GenerateMocks([AcousticRepository])
void main() {
  group('EnhancedNoiseMeterNotifier', () {
    late MockAcousticRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockAcousticRepository();
      // Mock permission checks to always return true for simplicity in most tests
      when(mockRepository.checkPermission()).thenAnswer((_) async => true);
      when(mockRepository.requestPermission()).thenAnswer((_) async => true);
      // Mock save and get reports
      when(mockRepository.saveReport(any)).thenAnswer((_) async => {});
      when(mockRepository.getReports()).thenAnswer((_) async => []);

      container = ProviderContainer(
        overrides: [
          enhancedNoiseMeterProvider.overrideWith(
            (ref) => EnhancedNoiseMeterNotifier(mockRepository),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is correct', () {
      debugPrint('Test: initial state is correct');
      final state = container.read(enhancedNoiseMeterProvider);
      expect(state, const EnhancedNoiseMeterData());
      debugPrint('Initial state: $state');
    });

    test('startRecordingWithPreset updates state and permission', () async {
      debugPrint('Test: startRecordingWithPreset updates state and permission');
      final notifier = container.read(enhancedNoiseMeterProvider.notifier);

      // Mock noise stream
      final noiseStreamController = StreamController<NoiseData>();
      when(mockRepository.noiseStream).thenAnswer((_) => noiseStreamController.stream);

      await notifier.startRecordingWithPreset(RecordingPreset.custom);

      final state = container.read(enhancedNoiseMeterProvider);
      expect(state.isRecording, true);
      expect(state.hasPermission, true);
      expect(state.activePreset, RecordingPreset.custom);
      expect(state.sessionStartTime, isNotNull);
      debugPrint('State after startRecordingWithPreset: $state');

      // Clean up stream controller
      await noiseStreamController.close();
    });

    test('startRecordingWithPreset requests permission if not granted', () async {
      debugPrint('Test: startRecordingWithPreset requests permission if not granted');
      when(mockRepository.checkPermission()).thenAnswer((_) async => false);
      when(mockRepository.requestPermission()).thenAnswer((_) async => true);

      final notifier = container.read(enhancedNoiseMeterProvider.notifier);
      final noiseStreamController = StreamController<NoiseData>();
      when(mockRepository.noiseStream).thenAnswer((_) => noiseStreamController.stream);

      await notifier.startRecordingWithPreset(RecordingPreset.work);

      verify(mockRepository.requestPermission()).called(1);
      expect(container.read(enhancedNoiseMeterProvider).hasPermission, true);
      debugPrint('State after permission request: ${container.read(enhancedNoiseMeterProvider)}');

      await noiseStreamController.close();
    });

    test('startRecordingWithPreset sets error message if permission denied', () async {
      debugPrint('Test: startRecordingWithPreset sets error message if permission denied');
      when(mockRepository.checkPermission()).thenAnswer((_) async => false);
      when(mockRepository.requestPermission()).thenAnswer((_) async => false);

      final notifier = container.read(enhancedNoiseMeterProvider.notifier);
      await notifier.startRecordingWithPreset(RecordingPreset.focus);

      expect(container.read(enhancedNoiseMeterProvider).errorMessage, 'Microphone permission required');
      expect(container.read(enhancedNoiseMeterProvider).hasPermission, false);
      debugPrint('State after permission denied: ${container.read(enhancedNoiseMeterProvider)}');
    });

    test('noise readings update current, min, max, and average decibels', () async {
      debugPrint('Test: noise readings update current, min, max, and average decibels');
      final notifier = container.read(enhancedNoiseMeterProvider.notifier);
      final noiseStreamController = StreamController<NoiseData>();
      when(mockRepository.noiseStream).thenAnswer((_) => noiseStreamController.stream);

      await notifier.startRecordingWithPreset(RecordingPreset.custom);

      // Simulate noise readings
      noiseStreamController.add(const NoiseData(meanDecibel: 50.0));
      await Future.delayed(const Duration(milliseconds: 150)); // Allow UI update throttle
      noiseStreamController.add(const NoiseData(meanDecibel: 60.0));
      await Future.delayed(const Duration(milliseconds: 150));
      noiseStreamController.add(const NoiseData(meanDecibel: 40.0));
      await Future.delayed(const Duration(milliseconds: 150));

      final state = container.read(enhancedNoiseMeterProvider);
      expect(state.currentDecibels, closeTo(40.0, 0.1));
      expect(state.minDecibels, closeTo(40.0, 0.1));
      expect(state.maxDecibels, closeTo(60.0, 0.1));
      expect(state.averageDecibels, closeTo(50.0, 0.1)); // (50+60+40)/3
      expect(state.totalReadings, 3);
      debugPrint('State after noise readings: $state');

      await noiseStreamController.close();
    });

    test('noise readings handle infinite or NaN values gracefully', () async {
      debugPrint('Test: noise readings handle infinite or NaN values gracefully');
      final notifier = container.read(enhancedNoiseMeterProvider.notifier);
      final noiseStreamController = StreamController<NoiseData>();
      when(mockRepository.noiseStream).thenAnswer((_) => noiseStreamController.stream);

      await notifier.startRecordingWithPreset(RecordingPreset.custom);

      noiseStreamController.add(const NoiseData(meanDecibel: 50.0));
      await Future.delayed(const Duration(milliseconds: 150));
      noiseStreamController.add(const NoiseData(meanDecibel: double.infinity)); // Invalid reading
      await Future.delayed(const Duration(milliseconds: 150));
      noiseStreamController.add(const NoiseData(meanDecibel: 60.0));
      await Future.delayed(const Duration(milliseconds: 150));
      noiseStreamController.add(const NoiseData(meanDecibel: double.nan)); // Invalid reading
      await Future.delayed(const Duration(milliseconds: 150));
      noiseStreamController.add(const NoiseData(meanDecibel: 40.0));
      await Future.delayed(const Duration(milliseconds: 150));

      final state = container.read(enhancedNoiseMeterProvider);
      // Only valid readings should affect stats
      expect(state.currentDecibels, closeTo(40.0, 0.1));
      expect(state.minDecibels, closeTo(40.0, 0.1));
      expect(state.maxDecibels, closeTo(60.0, 0.1));
      expect(state.averageDecibels, closeTo(50.0, 0.1)); // (50+60+40)/3
      expect(state.totalReadings, 3); // Only 3 valid readings processed
      debugPrint('State after invalid noise readings: $state');

      await noiseStreamController.close();
    });

    test('stopRecording generates and saves report', () async {
      debugPrint('Test: stopRecording generates and saves report');
      final notifier = container.read(enhancedNoiseMeterProvider.notifier);
      final noiseStreamController = StreamController<NoiseData>();
      when(mockRepository.noiseStream).thenAnswer((_) => noiseStreamController.stream);

      await notifier.startRecordingWithPreset(RecordingPreset.work);
      noiseStreamController.add(const NoiseData(meanDecibel: 50.0));
      await Future.delayed(const Duration(milliseconds: 150));
      noiseStreamController.add(const NoiseData(meanDecibel: 60.0));
      await Future.delayed(const Duration(milliseconds: 150));

      final report = await notifier.stopRecording();

      expect(report, isNotNull);
      expect(report!.averageDecibels, closeTo(55.0, 0.1));
      expect(container.read(enhancedNoiseMeterProvider).isRecording, false);
      expect(container.read(enhancedNoiseMeterProvider).isAnalyzing, false);
      verify(mockRepository.saveReport(any)).called(1);
      debugPrint('Report generated: ${report.toString()}');
      debugPrint('State after stopRecording: ${container.read(enhancedNoiseMeterProvider)}');

      await noiseStreamController.close();
    });

    test('loadSavedReports populates savedReports state', () async {
      debugPrint('Test: loadSavedReports populates savedReports state');
      final notifier = container.read(enhancedNoiseMeterProvider.notifier);
      final mockReport = AcousticReport(
        id: '1',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        duration: const Duration(minutes: 10),
        preset: RecordingPreset.sleep,
        averageDecibels: 40.0,
        minDecibels: 30.0,
        maxDecibels: 50.0,
        events: [],
        timeInLevels: {},
        hourlyAverages: [],
        environmentQuality: 'good',
        recommendation: 'Good sleep environment!',
        qualityScore: 75,
        interruptionCount: 0,
      );
      when(mockRepository.getReports()).thenAnswer((_) async => [mockReport]);

      await notifier.loadSavedReports();

      expect(container.read(enhancedNoiseMeterProvider).savedReports, [mockReport]);
      debugPrint('Saved reports loaded: ${container.read(enhancedNoiseMeterProvider).savedReports}');
    });

    test('deleteReport removes report from savedReports state', () async {
      debugPrint('Test: deleteReport removes report from savedReports state');
      final notifier = container.read(enhancedNoiseMeterProvider.notifier);
      final mockReport1 = AcousticReport(
        id: '1',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        duration: const Duration(minutes: 10),
        preset: RecordingPreset.sleep,
        averageDecibels: 40.0,
        minDecibels: 30.0,
        maxDecibels: 50.0,
        events: [],
        timeInLevels: {},
        hourlyAverages: [],
        environmentQuality: 'good',
        recommendation: 'Good sleep environment!',
        qualityScore: 75,
        interruptionCount: 0,
      );
      final mockReport2 = AcousticReport(
        id: '2',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        duration: const Duration(minutes: 20),
        preset: RecordingPreset.work,
        averageDecibels: 60.0,
        minDecibels: 55.0,
        maxDecibels: 65.0,
        events: [],
        timeInLevels: {},
        hourlyAverages: [],
        environmentQuality: 'fair',
        recommendation: 'Too loud for focused work.',
        qualityScore: 50,
        interruptionCount: 0,
      );
      when(mockRepository.getReports()).thenAnswer((_) async => [mockReport1, mockReport2]);
      when(mockRepository.deleteReport('1')).thenAnswer((_) async => {});

      await notifier.loadSavedReports(); // Load initial reports
      expect(container.read(enhancedNoiseMeterProvider).savedReports.length, 2);
      debugPrint('Reports before deletion: ${container.read(enhancedNoiseMeterProvider).savedReports}');

      await notifier.deleteReport('1');

      expect(container.read(enhancedNoiseMeterProvider).savedReports.length, 1);
      expect(container.read(enhancedNoiseMeterProvider).savedReports.first.id, '2');
      verify(mockRepository.deleteReport('1')).called(1);
      debugPrint('Reports after deletion: ${container.read(enhancedNoiseMeterProvider).savedReports}');
    });

    test('session timer stops recording after preset duration', () async {
      debugPrint('Test: session timer stops recording after preset duration');
      final notifier = container.read(enhancedNoiseMeterProvider.notifier);
      final noiseStreamController = StreamController<NoiseData>();
      when(mockRepository.noiseStream).thenAnswer((_) => noiseStreamController.stream);

      // Use a short custom duration for testing
      await notifier.startRecordingWithPreset(
        RecordingPreset.custom,
        customDuration: const Duration(seconds: 2),
      );

      expect(container.read(enhancedNoiseMeterProvider).isRecording, true);
      debugPrint('Recording started. State: ${container.read(enhancedNoiseMeterProvider)}');

      // Wait for the duration to pass
      await Future.delayed(const Duration(seconds: 3));

      expect(container.read(enhancedNoiseMeterProvider).isRecording, false);
      debugPrint('Recording stopped by timer. State: ${container.read(enhancedNoiseMeterProvider)}');

      await noiseStreamController.close();
    });

    test('event detection works correctly', () async {
      debugPrint('Test: event detection works correctly');
      final notifier = container.read(enhancedNoiseMeterProvider.notifier);
      final noiseStreamController = StreamController<NoiseData>();
      when(mockRepository.noiseStream).thenAnswer((_) => noiseStreamController.stream);

      await notifier.startRecordingWithPreset(RecordingPreset.custom);

      // Simulate quiet period
      noiseStreamController.add(const NoiseData(meanDecibel: 40.0));
      await Future.delayed(const Duration(milliseconds: 600)); // Pass event detection timer interval

      // Simulate loud event (above 65dB for >3 seconds)
      noiseStreamController.add(const NoiseData(meanDecibel: 70.0));
      await Future.delayed(const Duration(milliseconds: 1000)); // 1.0s
      noiseStreamController.add(const NoiseData(meanDecibel: 75.0)); // Peak
      await Future.delayed(const Duration(milliseconds: 1000)); // 2.0s
      noiseStreamController.add(const NoiseData(meanDecibel: 72.0));
      await Future.delayed(const Duration(milliseconds: 1000)); // 3.0s
      noiseStreamController.add(const NoiseData(meanDecibel: 68.0));
      await Future.delayed(const Duration(milliseconds: 500)); // 3.5s
      noiseStreamController.add(const NoiseData(meanDecibel: 60.0)); // Below threshold, event ends
      await Future.delayed(const Duration(milliseconds: 600));

      final state = container.read(enhancedNoiseMeterProvider);
      expect(state.events.length, 1);
      expect(state.events.first.peakDecibels, closeTo(75.0, 0.1));
      expect(state.events.first.eventType, 'intermittent'); // Duration was ~1.8s, so intermittent
      debugPrint('Events detected: ${state.events}');

      await noiseStreamController.close();
    });
  });
}
