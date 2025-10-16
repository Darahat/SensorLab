import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/enhanced_noise_data.dart';
import '../entities/noise_data.dart';

/// Abstract repository for all acoustic-related data operations.
///
/// This contract defines the boundary between the domain and data layers for the
/// entire noise meter feature. It ensures that the application logic (Controllers/
/// Notifiers) is completely decoupled from the implementation of data sources,
/// such as the microphone or the Hive database.
abstract class AcousticRepository {
  /// A stream of [NoiseData] from the data source.
  Stream<NoiseData> get noiseStream;

  /// Checks if the required microphone permission has been granted.
  Future<bool> checkPermission();

  /// Requests microphone permission from the user.
  Future<bool> requestPermission();

  /// Saves an [AcousticReport] to the persistent storage.
  Future<void> saveReport(AcousticReport report);

  /// Retrieves a sorted list of all saved [AcousticReport]s.
  Future<List<AcousticReport>> getReports();

  /// Deletes a specific report by its ID.
  Future<void> deleteReport(String reportId);

  /// Deletes all saved reports.
  Future<void> deleteAllReports();
}
