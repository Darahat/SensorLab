# Noise Meter Screens - Unlocalized Text Audit

## Summary

The acoustic analyzer screens (4 files) contain **~150+ hardcoded English strings** that need localization.

---

## 📋 acoustic_preset_selection_screen.dart

### App Bar

- `'Acoustic Environment Analyzer'`

### Headers & Descriptions

- `'Choose Recording Preset'`
- `'Select a preset to analyze your acoustic environment over time'`

### Sleep Preset Card

- `'Analyze Sleep Environment'`
- `'8 hours'`
- `'Monitor bedroom noise throughout the night to improve sleep quality'`

### Work Preset Card

- `'Monitor Office Environment'`
- `'1 hour'`
- `'Track workplace noise levels and identify distractions'`

### Focus Preset Card

- `'Focus Session Analysis'`
- `'30 minutes'`
- `'Analyze your study or focus session environment'`

### Buttons

- `'View Historical Reports'`

---

## 📋 acoustic_monitoring_screen.dart

### Snackbar Messages

- `'Report generated successfully!'`

### Tooltips

- `'Stop Recording'`

### Preset Titles

- `'Sleep Analysis (8h)'`
- `'Work Environment (1h)'`
- `'Focus Session (30m)'`
- `'Custom Recording'`

### Status Messages

- `'Recording Active'`
- `'Recording Stopped'`
- `'Monitoring acoustic environment...'`
- `'Recording completed'`

### Section Headers

- `'Current Level'`
- `'dB'` (unit)
- `'Progress'`
- `'Live Monitoring'`

### Time Formatting

- Minutes/seconds format (need localized formatters)

### WillPopScope Dialog

- Dialog title
- Dialog message
- Button labels (Continue/Stop)

---

## 📋 acoustic_report_detail_screen.dart

### App Bar

- `'Acoustic Report'`

### Tooltips

- `'Share Report'`

### Section Headers

- `'Environment Quality'`
- `'Average'`
- `'Peak'`
- `'Hourly Breakdown'`
- `'Noise Events'`

### Empty State

- `'No Interruptions Detected'`
- `'Your environment was consistently quiet'`

### Stats Labels

- Duration formatting
- Quality score labels
- Time formatting (e.g., "2h 15m")

### Chart Labels

- Hour labels (0-23)
- dB labels

### Event Types

- Interruption names
- Severity levels

### Recommendations Section

- Title
- Recommendation text (dynamic)

### Share Functionality

- CSV export button
- Share dialog text

---

## 📋 acoustic_reports_list_screen.dart

### App Bar

- `'Acoustic Reports'`
- `'${count} Selected'` (dynamic)

### Tooltips

- `'Export as CSV'`
- `'Delete Selected'`
- `'Filter by Preset'`

### Filter Menu

- `'All Presets'`
- `'Sleep'`
- `'Work'`
- `'Focus'`

### Buttons

- `'Export All'`
- `'Start Analysis'`

### Empty State

- `'No Reports Yet'`
- `'Start an acoustic analysis session to generate your first report'`

### Delete Dialog

- `'Delete Reports?'`
- `'Are you sure you want to delete ${count} report(s)? This action cannot be undone.'`
- `'Cancel'`
- `'Delete'`

### Snackbar Messages

- `'Reports deleted'`
- `'CSV data copied to clipboard!'`
- `'OK'` (action button)

### CSV Headers

- `'ID,Start Time,End Time,Duration (min),Preset,Average dB,Min dB,Max dB,Events,Quality Score,Quality,Recommendation'`

### Preset Names (repeated)

- `'Sleep'`
- `'Work'`
- `'Focus'`
- `'Custom'`

### Preset Descriptions

- `'Sleep Analysis'`
- `'Work Environment'`
- `'Focus Session'`

### List Item Labels

- `'${value} dB'` (average)
- `'${count} events'`
- Quality score display
- Date/time formatting

---

## 🔑 Recommended Localization Keys

### Acoustic Analyzer General

```dart
acousticAnalyzer
acousticAnalyzerTitle
acousticEnvironment
noiseLevel
decibelUnit // 'dB'
```

### Presets

```dart
presetSelectTitle
presetSelectSubtitle
presetSleep
presetSleepTitle
presetSleepDuration // '8 hours'
presetSleepDescription
presetWork
presetWorkTitle
presetWorkDuration // '1 hour'
presetWorkDescription
presetFocus
presetFocusTitle
presetFocusDuration // '30 minutes'
presetFocusDescription
presetCustom
```

### Monitoring

```dart
monitoringTitle
monitoringActive
monitoringStopped
monitoringProgress
monitoringCurrentLevel
monitoringLiveChart
recordingStart
recordingStop
recordingCompleted
reportGeneratedSuccess
stopRecordingTooltip
```

### Reports List

```dart
reportsTitle
reportsEmpty
reportsEmptyDescription
reportsSelectedCount // '{count} Selected'
reportExportCSV
reportExportAll
reportDelete
reportDeleteConfirmTitle
reportDeleteConfirmMessage // 'Are you sure you want to delete {count} report(s)?'
reportDeleteSuccess
reportFilterByPreset
reportFilterAll
reportStartAnalysis
csvCopiedToClipboard
```

### Report Detail

```dart
reportDetailTitle
reportQualityTitle
reportQualityScore
reportAverage
reportPeak
reportHourlyBreakdown
reportNoiseEvents
reportNoEventsTitle
reportNoEventsMessage
reportShare
reportRecommendations
```

### Time & Dates

```dart
durationHours // '{hours}h'
durationMinutes // '{minutes}m'
durationSeconds // '{seconds}s'
timeFormat24Hour
dateTimeFormat
```

### Quality Levels

```dart
qualityExcellent
qualityGood
qualityFair
qualityPoor
```

### Units

```dart
unitDecibels // 'dB'
unitHours // 'hours'
unitMinutes // 'minutes'
unitSeconds // 'seconds'
```

### Actions

```dart
actionCancel
actionDelete
actionExport
actionShare
actionOk
actionContinue
actionStop
actionStart
actionView
```

### CSV Export

```dart
csvHeaderID
csvHeaderStartTime
csvHeaderEndTime
csvHeaderDuration
csvHeaderPreset
csvHeaderAverageDB
csvHeaderMinDB
csvHeaderMaxDB
csvHeaderEvents
csvHeaderQualityScore
csvHeaderQuality
csvHeaderRecommendation
```

---

## 📊 Statistics

- **Total Screens**: 4
- **Approximate Hardcoded Strings**: 150+
- **Localization Keys Needed**: ~80 unique keys
- **CSV Headers**: 11 keys
- **Preset Variations**: 4 × 4 keys = 16 keys
- **Status Messages**: ~15 keys
- **Action Buttons**: ~12 keys
- **Tooltips**: ~8 keys

---

## 🚀 Implementation Priority

### High Priority (User-Facing Text)

1. App bar titles
2. Preset names and descriptions
3. Button labels
4. Empty state messages
5. Dialog messages

### Medium Priority

6. Section headers
7. Status messages
8. Tooltips
9. Snackbar messages

### Low Priority

10. CSV headers (technical, but still should be localized)
11. Unit abbreviations
12. Chart labels

---

## 💡 Additional Recommendations

### Dynamic Text Handling

Some strings contain dynamic values (e.g., `'${count} Selected'`). Use parameterized localization:

```dart
// English
'reportsSelectedCount': '{count} Selected'

// Usage
AppLocalizations.of(context).reportsSelectedCount.replaceAll('{count}', count.toString())
```

### Number Formatting

Use `NumberFormat` for locale-specific number formatting:

```dart
NumberFormat.decimalPattern(locale).format(decibels)
```

### Date/Time Formatting

Use `DateFormat` from `intl` package:

```dart
DateFormat.yMMMd(locale).format(dateTime)
DateFormat.jm(locale).format(dateTime) // Time
```

### Plural Handling

For count-based strings (events, reports), use plural forms:

```dart
// English
'eventsCount': {
  'zero': 'No events',
  'one': '1 event',
  'other': '{count} events'
}
```

---

## 📝 Next Steps

1. **Add keys to `.arb` files** (app_en.arb, app_es.arb, etc.)
2. **Replace hardcoded strings** with `AppLocalizations.of(context).keyName`
3. **Test with different locales** to ensure proper rendering
4. **Handle edge cases** (long text, RTL languages)
5. **Update CSV export** to use localized headers

---

## Example Refactoring

### Before:

```dart
title: const Text('Acoustic Environment Analyzer'),
```

### After:

```dart
title: Text(AppLocalizations.of(context).acousticAnalyzerTitle),
```

### Before:

```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Report generated successfully!')),
);
```

### After:

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(AppLocalizations.of(context).reportGeneratedSuccess)),
);
```

---

**Total Estimated Localization Work**: 2-3 hours for all 4 screens + testing
