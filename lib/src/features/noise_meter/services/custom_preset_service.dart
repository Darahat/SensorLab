import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:sensorlab/src/core/constants/hive_constants.dart';
import 'package:sensorlab/src/features/noise_meter/data/models/custom_preset_hive.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';

/// Service for managing custom acoustic analysis presets with Hive storage
class CustomPresetService {
  static Box<CustomPresetHive>? _box;

  /// Initialize the custom presets box
  static Future<void> init() async {
    debugPrint('🔧 CustomPresetService.init() called');
    if (!Hive.isBoxOpen(HiveConstants.customPresetsBox)) {
      debugPrint('📦 Opening box: ${HiveConstants.customPresetsBox}');
      _box = await Hive.openBox<CustomPresetHive>(
        HiveConstants.customPresetsBox,
      );
      debugPrint('✅ Box opened successfully. Contains ${_box!.length} items');
    } else {
      debugPrint('📦 Box already open');
      _box = Hive.box<CustomPresetHive>(HiveConstants.customPresetsBox);
      debugPrint('✅ Retrieved existing box. Contains ${_box!.length} items');
    }
  }

  /// Ensure box is initialized
  static Future<Box<CustomPresetHive>> _getBox() async {
    if (_box == null || !_box!.isOpen) {
      debugPrint('⚠️ Box not initialized, calling init()');
      await init();
    }
    return _box!;
  }

  /// Save a new custom preset
  static Future<String> savePreset(CustomPresetConfig config) async {
    debugPrint('💾 savePreset() called for: ${config.title}');
    final box = await _getBox();
    final hiveModel = CustomPresetHive.fromConfig(config);
    debugPrint('📝 Generated ID: ${hiveModel.id}');
    await box.put(hiveModel.id, hiveModel);
    debugPrint('✅ Saved to Hive. Box now contains ${box.length} items');
    debugPrint('📋 All keys in box: ${box.keys.toList()}');
    return hiveModel.id;
  }

  /// Get all custom presets
  static Future<List<CustomPresetConfig>> getAllPresets() async {
    debugPrint('📖 getAllPresets() called');
    final box = await _getBox();
    debugPrint('📦 Box contains ${box.length} items');
    final presets = box.values
        .map((hiveModel) => hiveModel.toConfig())
        .toList();
    debugPrint('✅ Returning ${presets.length} presets');
    return presets;
  }

  /// Get all custom presets with their IDs
  static Future<Map<String, CustomPresetConfig>> getAllPresetsWithIds() async {
    debugPrint('📖 getAllPresetsWithIds() called');
    final box = await _getBox();
    debugPrint('📦 Box contains ${box.length} items');
    debugPrint('🔑 Keys: ${box.keys.toList()}');
    final Map<String, CustomPresetConfig> presets = {};
    for (var key in box.keys) {
      final hiveModel = box.get(key);
      if (hiveModel != null) {
        presets[key.toString()] = hiveModel.toConfig();
        debugPrint('  ✓ Loaded: $key -> ${hiveModel.title}');
      }
    }
    return presets;
  }

  /// Update an existing preset
  static Future<void> updatePreset(String id, CustomPresetConfig config) async {
    final box = await _getBox();
    final existing = box.get(id);
    if (existing != null) {
      final updated = CustomPresetHive(
        id: id,
        title: config.title,
        description: config.description,
        durationInMinutes: config.duration.inMinutes,
        iconCodePoint: config.icon.codePoint,
        colorValue: config.color.value,
        createdAt: existing.createdAt,
      );
      await box.put(id, updated);
    }
  }

  /// Delete a preset by ID
  static Future<void> deletePreset(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  /// Delete all presets
  static Future<void> deleteAllPresets() async {
    final box = await _getBox();
    await box.clear();
  }

  /// Get preset by ID
  static Future<CustomPresetConfig?> getPresetById(String id) async {
    final box = await _getBox();
    final hiveModel = box.get(id);
    return hiveModel?.toConfig();
  }

  /// Check if preset exists
  static Future<bool> presetExists(String id) async {
    final box = await _getBox();
    return box.containsKey(id);
  }

  /// Get count of presets
  static Future<int> getPresetCount() async {
    final box = await _getBox();
    return box.length;
  }
}
