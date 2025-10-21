# Custom Lab Feature - Technical Documentation

## Overview

The **Custom Lab** feature transforms SensorLab into a professional multi-sensor data logger, allowing users to create customized sensor combinations for synchronized data collection and analysis.

## Feature Scope

### Core Capabilities

1. **Custom Lab Creation**

   - Users can create custom labs with specific sensor combinations
   - Custom naming and descriptions
   - Icon and color customization
   - Configurable recording intervals (100ms to 10s)

2. **Pre-configured Presets**

   - 6 default lab presets for common use cases
   - Environment Monitor (temp, humidity, light, noise, pressure)
   - Motion Analysis (accelerometer, gyroscope, magnetometer, compass)
   - Indoor Quality (light, noise, temp, humidity)
   - Outdoor Explorer (GPS, altimeter, speed, barometer, compass)
   - Vehicle Dynamics (accelerometer, gyroscope, GPS, speed)
   - Health Tracker (pedometer, heart rate, accelerometer)

3. **Recording Sessions**

   - Start/pause/resume/stop recording
   - Real-time data visualization
   - Session notes and metadata
   - Duration and data point tracking

4. **Data Export**
   - Multi-sensor synchronized CSV export
   - Timestamp-aligned data from all sensors
   - Custom column headers per sensor
   - Session metadata included in export

## Architecture

### Clean Architecture Layers

```
lib/src/features/custom_lab/
├── domain/
│   ├── entities/          # Business models
│   │   ├── sensor_type.dart
│   │   ├── lab.dart
│   │   ├── lab_session.dart
│   │   ├── sensor_data_point.dart
│   │   └── default_lab_presets.dart
│   └── repositories/      # Repository interfaces
│       └── lab_repository.dart
├── data/
│   ├── models/            # Hive models (data layer)
│   │   ├── lab_hive.dart
│   │   ├── lab_session_hive.dart
│   │   └── sensor_data_point_hive.dart
│   └── repositories/      # Repository implementations
│       └── lab_repository_impl.dart
├── application/
│   ├── use_cases/         # Business logic
│   │   ├── create_lab_use_case.dart
│   │   ├── record_session_use_case.dart
│   │   ├── export_csv_use_case.dart
│   │   └── manage_presets_use_case.dart
│   └── providers/         # Riverpod providers
│       ├── lab_provider.dart
│       ├── session_provider.dart
│       └── recording_provider.dart
├── presentation/
│   ├── screens/           # UI screens
│   │   ├── labs_list_screen.dart
│   │   ├── create_lab_screen.dart
│   │   ├── lab_detail_screen.dart
│   │   ├── recording_screen.dart
│   │   └── sessions_history_screen.dart
│   └── widgets/           # Reusable widgets
│       ├── lab_card.dart
│       ├── sensor_selector.dart
│       ├── recording_controls.dart
│       └── real_time_chart.dart
└── docs/
    ├── FEATURE_SPEC.md
    ├── CSV_FORMAT.md
    └── USER_GUIDE.md
```

## Data Models

### SensorType (Enum)

```dart
enum SensorType {
  accelerometer, gyroscope, magnetometer, barometer,
  lightMeter, noiseMeter, gps, proximity, temperature,
  humidity, pedometer, compass, altimeter, speedMeter, heartBeat
}
```

### Lab (Domain Entity)

```dart
class Lab {
  String id;
  String name;
  String description;
  List<SensorType> sensors;
  DateTime createdAt;
  DateTime updatedAt;
  bool isPreset;
  String? iconName;
  int? colorValue;
  int recordingInterval; // milliseconds
}
```

### LabSession (Recording Session)

```dart
class LabSession {
  String id;
  String labId;
  String labName;
  DateTime startTime;
  DateTime? endTime;
  RecordingStatus status; // idle, recording, paused, completed, failed
  int dataPointsCount;
  int duration; // seconds
  String? notes;
  String? exportPath;
  List<String> sensorTypes;
}
```

### SensorDataPoint (Time-series Data)

```dart
class SensorDataPoint {
  String sessionId;
  DateTime timestamp;
  Map<String, dynamic> sensorValues; // Sensor-specific data
  int sequenceNumber;
}
```

## Hive Storage

### Type IDs

- `SensorType`: typeId 20
- `Lab`: typeId 21
- `RecordingStatus`: typeId 22
- `LabSession`: typeId 23
- `SensorDataPoint`: typeId 24

### Boxes

- `customLabsBox`: Stores Lab entities
- `labSessionsBox`: Stores LabSession entities
- `sensorDataBox`: Stores SensorDataPoint entities (bulk storage)

## CSV Export Format

### File Naming

```
[LabName]_[YYYY-MM-DD]_[HH-MM-SS].csv
Example: Environment_Monitor_2025-10-21_14-30-45.csv
```

### CSV Structure

```csv
Timestamp,Sequence,Temperature,Humidity,Light,Noise,Pressure
2025-10-21 14:30:45.123,1,22.5,45.2,350,42.3,1013.25
2025-10-21 14:30:46.123,2,22.6,45.1,352,43.1,1013.26
```

#### Header Row

- `Timestamp`: ISO 8601 format with milliseconds
- `Sequence`: Sequential number (1, 2, 3...)
- [Sensor-specific columns]: Dynamic based on lab configuration

#### Metadata (Comment Lines)

```csv
# Lab Name: Environment Monitor
# Session ID: abc123...
# Start Time: 2025-10-21 14:30:45
# End Time: 2025-10-21 14:35:50
# Duration: 305 seconds
# Data Points: 305
# Recording Interval: 1000ms
# Sensors: temperature, humidity, lightMeter, noiseMeter, barometer
```

## Use Cases

### 1. Create Custom Lab

```dart
Future<void> createCustomLab({
  required String name,
  required String description,
  required List<SensorType> sensors,
  int recordingInterval = 1000,
}) async {
  final lab = Lab(
    id: Uuid().v4(),
    name: name,
    description: description,
    sensors: sensors,
    recordingInterval: recordingInterval,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  await labRepository.createLab(lab);
}
```

### 2. Start Recording Session

```dart
Future<LabSession> startRecordingSession(String labId) async {
  final lab = await labRepository.getLabById(labId);
  final session = LabSession(
    id: Uuid().v4(),
    labId: lab.id,
    labName: lab.name,
    startTime: DateTime.now(),
    status: RecordingStatus.recording,
    sensorTypes: lab.sensors.map((s) => s.name).toList(),
  );
  await labRepository.createSession(session);
  // Initialize sensor listeners
  return session;
}
```

### 3. Record Data Point

```dart
Future<void> recordDataPoint({
  required String sessionId,
  required Map<String, dynamic> sensorValues,
  required int sequence,
}) async {
  final dataPoint = SensorDataPoint(
    sessionId: sessionId,
    timestamp: DateTime.now(),
    sensorValues: sensorValues,
    sequenceNumber: sequence,
  );
  await labRepository.saveDataPoint(dataPoint);
}
```

### 4. Export Session to CSV

```dart
Future<String> exportSessionToCSV(String sessionId) async {
  final session = await labRepository.getSessionById(sessionId);
  final dataPoints = await labRepository.getDataPointsBySessionId(sessionId);

  // Generate CSV content
  final csvPath = await csvGenerator.generateCSV(
    session: session,
    dataPoints: dataPoints,
  );

  // Update session with export path
  await labRepository.updateSession(
    session.copyWith(exportPath: csvPath),
  );

  return csvPath;
}
```

## UI Screens

### 1. Labs List Screen

- Grid/List view of all labs (custom + presets)
- Quick action: Start recording
- Navigation to lab detail
- Create new lab FAB

### 2. Create Lab Screen

- Name and description inputs
- Sensor multi-select with visual chips
- Icon and color picker
- Recording interval slider (100ms - 10s)
- Save button

### 3. Lab Detail Screen

- Lab information and configuration
- Edit lab button
- Session history list
- Start new recording button
- Delete lab option

### 4. Recording Screen

- Real-time sensor values display
- Live charts for each sensor
- Recording controls (pause/resume/stop)
- Timer and data points counter
- Add notes field

### 5. Sessions History Screen

- List of all completed sessions
- Filter by lab
- Export to CSV button
- Share option
- Delete session

## State Management

### Riverpod Providers

```dart
// Lab management
final labListProvider = StateNotifierProvider<LabListNotifier, AsyncValue<List<Lab>>>(...);
final selectedLabProvider = StateProvider<Lab?>(...);

// Session management
final activeSessionProvider = StateNotifierProvider<SessionNotifier, LabSession?>(...);
final sessionHistoryProvider = FutureProvider<List<LabSession>>(...);

// Recording state
final isRecordingProvider = StateProvider<bool>(...);
final recordedDataPointsProvider = StateProvider<int>(...);
final recordingTimerProvider = StreamProvider<int>(...);

// Sensor data streams
final sensorDataStreamProvider = StreamProvider.family<Map<String, dynamic>, SensorType>(...);
```

## Localization Keys

### New l10n Keys Needed

```dart
// Screen titles
customLab
myLabs
createLab
recordingSession
sessionsHistory

// Lab creation
labName
labDescription
selectSensors
recordingInterval
chooseIcon
chooseColor
createLabButton
editLabButton

// Presets
defaultPresets
environmentMonitor
motionAnalysis
indoorQuality
outdoorExplorer
vehicleDynamics
healthTracker

// Recording
startRecording
pauseRecording
resumeRecording
stopRecording
recordingInProgress
dataPointsRecorded
sessionDuration
addNotes

// Export
exportToCSV
exportSuccess
exportFailed
shareSession
csvExported

// Actions
deletelab
deleteLab
deleteSession
confirmDelete
```

## Implementation Phases

### Phase 1: Domain & Data Layer ✅

- [x] Create domain entities
- [x] Define repository interface
- [x] Create default presets
- [ ] Implement Hive models
- [ ] Implement repository

### Phase 2: Application Layer

- [ ] Create use cases
- [ ] Setup Riverpod providers
- [ ] Implement CSV export logic

### Phase 3: Presentation Layer

- [ ] Create Labs List screen
- [ ] Create Lab Creation screen
- [ ] Create Recording screen
- [ ] Create Session History screen

### Phase 4: Integration

- [ ] Add to main navigation
- [ ] Integrate with existing sensors
- [ ] Add localization
- [ ] Testing and polish

### Phase 5: Premium Features (Optional)

- [ ] Cloud sync for sessions
- [ ] Advanced analytics dashboard
- [ ] Automated reports
- [ ] Collaboration features

## Technical Considerations

### Performance

- Use batch inserts for data points (every 10 points)
- Implement lazy loading for session history
- Limit in-memory data points (write to disk periodically)
- Background isolate for CSV generation

### Storage

- Estimate: ~100 bytes per data point
- 1 hour @ 1Hz = 3,600 points = ~360KB
- Implement auto-cleanup for old sessions
- Add storage limits and warnings

### Permissions

- Requires all sensor permissions based on selected sensors
- Request permissions dynamically on lab creation
- Inform users about missing permissions

### Error Handling

- Sensor unavailable handling
- Storage full scenarios
- Export failures
- Session recovery after app crash

## Testing Strategy

### Unit Tests

- Domain entities validation
- Use cases logic
- CSV generation
- Data transformations

### Widget Tests

- Lab creation flow
- Recording controls
- Session list display

### Integration Tests

- End-to-end recording flow
- Export and share
- Multi-sensor synchronization

## Future Enhancements

1. **Data Analysis Dashboard**

   - Statistical summaries
   - Comparison between sessions
   - Trend analysis

2. **Cloud Backup**

   - Auto-sync to cloud storage
   - Cross-device access
   - Collaboration features

3. **Advanced Export Formats**

   - JSON export
   - MATLAB format
   - Python NumPy arrays
   - Excel with charts

4. **Lab Templates Marketplace**

   - Share custom labs with community
   - Download community-created labs
   - Rating and reviews

5. **AI-Powered Insights**
   - Pattern recognition
   - Anomaly detection
   - Predictive analytics

## Competitive Advantage

### Unique Features Not Found in Competitors

1. **Visual Lab Presets** - Pre-configured templates with beautiful UI
2. **Custom Organization** - User-created labs with custom naming
3. **Synchronized Multi-Sensor Recording** - All sensors timestamped together
4. **Modern Material Design 3** - Best-in-class UI/UX
5. **Comprehensive Export** - CSV with metadata and proper formatting
6. **Session Management** - Full history and replay capabilities

### Market Positioning

- **Target Users**: Students, researchers, hobbyists, professionals
- **Use Cases**: Science experiments, environmental monitoring, motion analysis, vehicle testing
- **Monetization**: Premium feature or one-time IAP unlock ($4.99 - $9.99)

## Success Metrics

- Number of custom labs created per user
- Recording session duration average
- CSV export usage rate
- User retention after using Custom Lab
- Premium conversion rate (if monetized)
