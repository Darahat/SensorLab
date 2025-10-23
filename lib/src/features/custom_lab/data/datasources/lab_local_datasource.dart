import 'package:hive/hive.dart';
import 'package:sensorlab/src/core/services/hive_service.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';

/// Data source responsible for Lab CRUD operations in local storage
class LabLocalDataSource {
  static const String _labsBoxName = HiveService.customLabsBoxName;
  static const String _legacyBoxName = 'labs';

  /// Opens the labs box, performing migration if needed
  Future<Box<Lab>> _openLabsBox() async {
    await _migrateLabsBoxIfNeeded();
    return await Hive.openBox<Lab>(_labsBoxName);
  }

  /// One-time migration from legacy 'labs' box to canonical name
  Future<void> _migrateLabsBoxIfNeeded() async {
    if (_legacyBoxName == _labsBoxName) return;

    try {
      final legacyExists = await Hive.boxExists(_legacyBoxName);
      if (!legacyExists) return;

      final legacyBox = await Hive.openBox<Lab>(_legacyBoxName);
      final newBox = await Hive.openBox<Lab>(_labsBoxName);

      // Copy missing entries to new box
      for (final key in legacyBox.keys) {
        if (!newBox.containsKey(key)) {
          final value = legacyBox.get(key);
          if (value != null) {
            await newBox.put(key, value);
          }
        }
      }

      await legacyBox.close();
      await Hive.deleteBoxFromDisk(_legacyBoxName);

      AppLogger.log(
        'Migrated legacy labs box to $_labsBoxName',
        level: LogLevel.info,
      );
    } catch (e) {
      AppLogger.log(
        'Labs box migration skipped/failed: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Creates a new lab
  Future<Lab> create(Lab lab) async {
    final box = await _openLabsBox();
    await box.put(lab.id, lab);
    return lab;
  }

  /// Updates an existing lab
  Future<Lab> update(Lab lab) async {
    final box = await _openLabsBox();
    await box.put(lab.id, lab);
    return lab;
  }

  /// Retrieves a lab by ID
  Future<Lab?> getById(String labId) async {
    final box = await _openLabsBox();
    return box.get(labId);
  }

  /// Retrieves all labs sorted by updated date
  Future<List<Lab>> getAll() async {
    final box = await _openLabsBox();
    final labs = box.values.toList();
    labs.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return labs;
  }

  /// Deletes a lab by ID
  Future<void> delete(String labId) async {
    final box = await _openLabsBox();
    await box.delete(labId);
  }
}
