# Custom Lab - Implementation Guide

## Quick Start

This guide will help you implement the Custom Lab feature step-by-step.

## Prerequisites

Before starting, ensure you have:

- ✅ Flutter SDK (latest stable)
- ✅ All sensor features working in SensorLab
- ✅ Hive setup and configured
- ✅ Freezed and build_runner installed
- ✅ UUID package installed

## Step 1: Generate Code

Run code generation for Freezed and Hive:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:

- `sensor_type.g.dart`
- `lab.freezed.dart` & `lab.g.dart`
- `lab_session.freezed.dart` & `lab_session.g.dart`
- `sensor_data_point.freezed.dart` & `sensor_data_point.g.dart`

## Step 2: Register Hive Adapters

Update `lib/src/core/services/hive_service.dart`:

```dart
// Add to init() method

/// Teach Hive about [SensorType] enum (typeId: 20)
if (!Hive.isAdapterRegistered(20)) {
  Hive.registerAdapter(SensorTypeAdapter());
}

/// Teach Hive about [Lab] data model (typeId: 21)
if (!Hive.isAdapterRegistered(21)) {
  Hive.registerAdapter(LabAdapter());
}

/// Teach Hive about [RecordingStatus] enum (typeId: 22)
if (!Hive.isAdapterRegistered(22)) {
  Hive.registerAdapter(RecordingStatusAdapter());
}

/// Teach Hive about [LabSession] data model (typeId: 23)
if (!Hive.isAdapterRegistered(23)) {
  Hive.registerAdapter(LabSessionAdapter());
}

/// Teach Hive about [SensorDataPoint] data model (typeId: 24)
if (!Hive.isAdapterRegistered(24)) {
  Hive.registerAdapter(SensorDataPointAdapter());
}

// Open boxes
await Hive.openBox<Lab>('customLabsBox');
await Hive.openBox<LabSession>('labSessionsBox');
await Hive.openBox<SensorDataPoint>('sensorDataBox');
```

## Step 3: Implement Repository

Create `lib/src/features/custom_lab/data/repositories/lab_repository_impl.dart`:

```dart
class LabRepositoryImpl implements LabRepository {
  final Box<Lab> labsBox;
  final Box<LabSession> sessionsBox;
  final Box<SensorDataPoint> dataBox;

  LabRepositoryImpl(this.labsBox, this.sessionsBox, this.dataBox);

  @override
  Future<List<Lab>> getAllLabs() async {
    return labsBox.values.toList();
  }

  @override
  Future<void> createLab(Lab lab) async {
    await labsBox.put(lab.id, lab);
  }

  // ... implement all methods
}
```

## Step 4: Create Providers

Create `lib/src/features/custom_lab/application/providers/lab_provider.dart`:

```dart
final labRepositoryProvider = Provider<LabRepository>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return LabRepositoryImpl(
    hiveService.labsBox,
    hiveService.sessionsBox,
    hiveService.dataBox,
  );
});

final labListProvider = FutureProvider<List<Lab>>((ref) async {
  final repository = ref.watch(labRepositoryProvider);
  return repository.getAllLabs();
});

final activeSessionProvider = StateProvider<LabSession?>((ref) => null);
```

## Step 5: Build UI Screens

### Labs List Screen

Create `lib/src/features/custom_lab/presentation/screens/labs_list_screen.dart`:

```dart
class LabsListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labsAsync = ref.watch(labListProvider);

    return Scaffold(
      appBar: AppBar(title: Text('My Labs')),
      body: labsAsync.when(
        data: (labs) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: labs.length,
          itemBuilder: (context, index) => LabCard(lab: labs[index]),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, st) => ErrorWidget(e),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(...),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

## Step 6: Add to Navigation

Update `lib/src/shared/widgets/sensors.dart` to include Custom Lab:

```dart
SensorCard(
  name: 'Custom Lab',
  icon: Icons.science,
  category: 'Utilities',
  available: true,
  screen: LabsListScreen(),
),
```

## Step 7: Implement Recording Logic

Create `lib/src/features/custom_lab/application/providers/recording_provider.dart`:

```dart
class RecordingNotifier extends StateNotifier<RecordingState> {
  final LabRepository repository;
  Timer? _recordingTimer;
  int _sequenceNumber = 0;

  Future<void> startRecording(Lab lab) async {
    final session = LabSession(/* ... */);
    await repository.createSession(session);

    _recordingTimer = Timer.periodic(
      Duration(milliseconds: lab.recordingInterval),
      (_) => _recordDataPoint(session.id, lab.sensors),
    );
  }

  Future<void> _recordDataPoint(String sessionId, List<SensorType> sensors) async {
    final sensorValues = await _collectSensorData(sensors);
    final dataPoint = SensorDataPoint(
      sessionId: sessionId,
      timestamp: DateTime.now(),
      sensorValues: sensorValues,
      sequenceNumber: ++_sequenceNumber,
    );
    await repository.saveDataPoint(dataPoint);
  }

  Future<Map<String, dynamic>> _collectSensorData(List<SensorType> sensors) async {
    // Collect data from all sensors
    // Return map with sensor names as keys
  }
}
```

## Step 8: Implement CSV Export

Create `lib/src/features/custom_lab/application/use_cases/export_csv_use_case.dart`:

```dart
class ExportCSVUseCase {
  Future<String> execute(String sessionId) async {
    final session = await repository.getSessionById(sessionId);
    final dataPoints = await repository.getDataPointsBySessionId(sessionId);

    final csv = StringBuffer();

    // Write metadata
    csv.writeln('# Lab Name: ${session.labName}');
    csv.writeln('# Session ID: ${session.id}');
    // ... more metadata

    // Write headers
    csv.writeln('Timestamp,Sequence,...sensor columns');

    // Write data
    for (final point in dataPoints) {
      csv.writeln('${point.timestamp},${point.sequenceNumber},...');
    }

    // Save to file
    final file = File('path/to/export.csv');
    await file.writeAsString(csv.toString());

    return file.path;
  }
}
```

## Step 9: Add Localization

Update `lib/l10n/app_en.arb`:

```json
{
  "customLab": "Custom Lab",
  "myLabs": "My Labs",
  "createLab": "Create Lab",
  "labName": "Lab Name",
  "selectSensors": "Select Sensors",
  "startRecording": "Start Recording",
  "stopRecording": "Stop Recording",
  "exportToCSV": "Export to CSV"
  // ... add all keys from FEATURE_SPEC.md
}
```

## Step 10: Testing

Run tests:

```bash
# Unit tests
flutter test test/features/custom_lab/

# Integration tests
flutter test integration_test/
```

## Step 11: Initial Data Setup

On first launch, load default presets:

```dart
Future<void> initializeDefaultPresets() async {
  final repository = ref.read(labRepositoryProvider);
  final existingLabs = await repository.getAllLabs();

  if (existingLabs.isEmpty) {
    final presets = DefaultLabPresets.getDefaultPresets();
    for (final preset in presets) {
      await repository.createLab(preset);
    }
  }
}
```

## Common Issues & Solutions

### Issue: Hive TypeId Conflict

**Solution**: Ensure typeIds 20-24 are not used elsewhere. Check `HiveConstants`.

### Issue: Freezed Not Generating

**Solution**: Run `flutter pub run build_runner clean && flutter pub run build_runner build`

### Issue: Sensor Data Not Synchronizing

**Solution**: Use a single timestamp source for all sensors in a data point.

### Issue: CSV Export Fails

**Solution**: Check file permissions and use `path_provider` for correct directory.

## Next Steps

1. ✅ Generate code with build_runner
2. ✅ Register Hive adapters
3. ✅ Implement repository
4. ✅ Create providers
5. ✅ Build UI screens
6. ✅ Add to navigation
7. ✅ Implement recording
8. ✅ Add CSV export
9. ✅ Add localization
10. ✅ Test and polish

## Resources

- [Feature Specification](./FEATURE_SPEC.md)
- [CSV Format Guide](./CSV_FORMAT.md)
- [Hive Documentation](https://docs.hivedb.dev/)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Riverpod Documentation](https://riverpod.dev/)

## Support

For issues or questions:

1. Check the feature specification
2. Review existing sensor implementations
3. Check Hive and Freezed documentation
4. Create a GitHub issue with details
