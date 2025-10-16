# Widget Library Quick Reference

## Import Statement

```dart
// Feature-specific widgets
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/index.dart';

// Shared widgets (available app-wide)
import 'package:sensorlab/src/shared/widgets/common_cards.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';
```

## Common Patterns

### 1. Status Display with Animated Indicator

```dart
StatusCard(
  isActive: isRecording,
  title: isRecording ? "Active" : "Stopped",
  subtitle: isRecording ? "Recording data..." : "Ready to start",
)
```

### 2. Statistics Grid

```dart
Row(
  children: [
    Expanded(
      child: StatCard(
        icon: Iconsax.chart,
        label: "Average",
        value: "65.3 dB",
        color: Colors.blue,
        onTap: () => showDetails(),
      ),
    ),
    SizedBox(width: 12),
    Expanded(
      child: StatCard(
        icon: Iconsax.warning_2,
        label: "Events",
        value: "8",
        color: Colors.orange,
      ),
    ),
  ],
)
```

### 3. Inline Stats with Chips

```dart
Wrap(
  spacing: 8,
  children: [
    StatChip(icon: Iconsax.timer, label: "15m 30s", color: Colors.blue),
    StatChip(icon: Iconsax.calendar, label: "Today", color: Colors.purple),
    StatChip(icon: Iconsax.location, label: "Office", color: Colors.green),
  ],
)
```

### 4. Quality Score Display

```dart
QualityScoreGauge(
  score: 85,        // Auto-colors: green (80+), blue (60+), orange (40+), red (<40)
  size: 120,        // Diameter in pixels
  showLabel: true,  // Shows text: Excellent, Good, Fair, Poor
)
```

### 5. Section Headers

```dart
SectionHeader(
  title: "Recent Activity",
  subtitle: "Last 7 days",
  trailing: TextButton(
    onPressed: () => viewAll(),
    child: Text("View All"),
  ),
)
```

### 6. Empty States

```dart
EmptyStateWidget(
  icon: Iconsax.note_1,
  title: "No Data Yet",
  message: "Start recording to see your results here",
  actionLabel: "Start Recording",
  onAction: () => startRecording(),
)
```

### 7. Real-time Line Charts

```dart
RealtimeLineChart(
  dataPoints: [45.2, 48.1, 52.3, 49.8, 51.0, ...],
  title: "Live Readings",
  lineColor: Colors.blue,
  minY: 0,
  maxY: 100,
  horizontalInterval: 20,  // Y-axis grid spacing
)
```

### 8. Action Buttons

```dart
Row(
  children: [
    Expanded(
      child: ActionButton(
        icon: Iconsax.play,
        label: "Start",
        onPressed: () => start(),
        color: Colors.green,
      ),
    ),
    SizedBox(width: 12),
    Expanded(
      child: ActionButton(
        icon: Iconsax.stop,
        label: "Stop",
        onPressed: () => stop(),
        color: Colors.red,
        isOutlined: true,  // Outlined style
      ),
    ),
  ],
)
```

### 9. Info Rows

```dart
Column(
  children: [
    InfoRow(
      label: "Duration",
      value: "15m 30s",
      icon: Iconsax.timer,
    ),
    InfoRow(
      label: "Average",
      value: "65.3 dB",
      icon: Iconsax.chart,
      valueColor: Colors.blue,
    ),
    InfoRow(
      label: "Peak",
      value: "88.5 dB",
      icon: Iconsax.warning_2,
      valueColor: Colors.red,
    ),
  ],
)
```

### 10. Badges

```dart
Wrap(
  spacing: 8,
  children: [
    BadgeWidget(
      label: "Sleep Mode",
      color: Colors.purple,
      icon: Iconsax.moon,
    ),
    BadgeWidget(
      label: "High Quality",
      color: Colors.green,
      icon: Iconsax.star,
    ),
  ],
)
```

## Noise Meter Specific Widgets

### Decibel Display

```dart
DecibelDisplay(
  decibels: currentDecibels,
  noiseLevel: "Moderate",  // Very Quiet, Quiet, Moderate, Loud, Very Loud
  unit: "dB",
)
```

### Session Progress

```dart
SessionProgressIndicator(
  progress: 0.65,              // 0.0 to 1.0
  remainingTime: "5m 30s",
  label: "Recording Progress",
  color: Colors.blue,
)
```

### Noise Event Item

```dart
NoiseEventItem(
  timestamp: DateTime.now(),
  peakDecibels: 85.5,
  duration: Duration(seconds: 15),
  eventType: "Spike",  // Auto-icons: Spike, Sustained, Intermittent
)
```

### Preset Card

```dart
PresetCard(
  preset: RecordingPreset.sleep,
  title: "Sleep Analysis",
  duration: "8 hours",
  description: "Monitor nighttime noise levels",
  onTap: () => selectPreset(),
)
```

### Preset Badge

```dart
PresetBadge(
  preset: RecordingPreset.work,
  label: "Work",
)
```

## Report-Specific Widgets

### Quality Metrics Row

```dart
QualityMetricsRow(
  overallScore: 85.0,
  consistencyScore: 78.0,
  peakManagementScore: 92.0,
)
```

### Hourly Breakdown Chart

```dart
HourlyBreakdownChart(
  hourlyAverages: [45, 52, 48, 51, ...],  // 24 values for 24 hours
  maxY: 100,
)
```

### Recommendation Card

```dart
RecommendationCard(
  recommendation: "Consider using noise-cancelling headphones during peak hours",
  icon: Iconsax.headphone,
  color: Colors.orange,
  onTap: () => viewDetails(),
)
```

### Event Timeline

```dart
EventTimelineCard(
  events: [
    EventItem(
      timestamp: DateTime.now(),
      peakDecibels: 85.5,
      duration: Duration(seconds: 15),
      description: "Loud noise detected",
      severity: EventSeverity.high,
    ),
    // ... more events
  ],
  emptyMessage: "No events recorded during this session",
)
```

### Report Summary Card

```dart
ReportSummaryCard(
  title: "Evening Work Session",
  date: "Oct 14, 2025",
  avgDecibels: 52.3,
  qualityScore: 85,
  eventCount: 3,
  presetName: "Work",
  onTap: () => viewReport(),
)
```

## Usage in Light Meter

The shared widgets can be used in the Light Meter feature:

```dart
// Status indicator
StatusCard(
  isActive: isTracking,
  title: "Plant Tracking Active",
  subtitle: "Accumulating DLI for Snake Plant",
)

// Statistics
Row(
  children: [
    Expanded(
      child: StatCard(
        icon: Iconsax.sun_1,
        label: "Current Lux",
        value: "2,450",
        color: Colors.amber,
      ),
    ),
    Expanded(
      child: StatCard(
        icon: Iconsax.chart,
        label: "DLI Today",
        value: "4.2",
        color: Colors.green,
      ),
    ),
  ],
)

// Progress gauge
QualityScoreGauge(
  score: dliProgress,  // 0-100
  size: 150,
  showLabel: true,
)

// Real-time chart
RealtimeLineChart(
  dataPoints: luxHistory,
  title: "Light Levels",
  lineColor: Colors.amber,
  maxY: 10000,
)

// Info rows
InfoRow(
  label: "Plant Type",
  value: "Snake Plant",
  icon: Iconsax.tree,
)

// Badges
BadgeWidget(
  label: "Plant Mode",
  color: Colors.green,
  icon: Iconsax.tree,
)
```

## Color Coding Reference

### Decibel Levels

- **0-30 dB**: Blue (very quiet)
- **30-50 dB**: Green (quiet)
- **50-70 dB**: Orange (moderate)
- **70-85 dB**: Deep Orange (loud)
- **85+ dB**: Red (very loud/harmful)

### Quality Scores

- **80-100**: Green (excellent)
- **60-79**: Blue (good)
- **40-59**: Orange (fair)
- **0-39**: Red (poor)

### Event Severity

- **Low**: Blue
- **Medium**: Orange
- **High**: Red

## Design Tokens

### Spacing

```dart
const spacing = {
  'xs': 4.0,
  'sm': 8.0,
  'md': 12.0,
  'lg': 16.0,
  'xl': 20.0,
  'xxl': 24.0,
  '3xl': 32.0,
};
```

### Border Radius

```dart
const borderRadius = {
  'sm': 8.0,
  'md': 12.0,
  'lg': 16.0,
  'xl': 20.0,
};
```

### Elevation

```dart
const elevation = {
  'low': 2.0,
  'medium': 4.0,
  'high': 8.0,
};
```

## Best Practices

1. **Always use const constructors** when widget parameters are compile-time constants
2. **Prefer composition** over creating new custom widgets
3. **Use themed colors** instead of hardcoded colors when possible
4. **Provide meaningful labels** for accessibility
5. **Keep widgets small** and focused on single responsibility
6. **Test widgets independently** before using in screens

## Testing Example

```dart
testWidgets('StatCard displays correct values', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: StatCard(
          icon: Icons.star,
          label: 'Test',
          value: '123',
          color: Colors.blue,
        ),
      ),
    ),
  );

  expect(find.text('Test'), findsOneWidget);
  expect(find.text('123'), findsOneWidget);
  expect(find.byIcon(Icons.star), findsOneWidget);
});
```

---

**Last Updated**: October 14, 2025
**Widget Count**: 22 reusable components
**Analyzer Status**: ✅ 0 issues
