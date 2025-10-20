# Noise Meter Feature - Localization Status

## Summary

All hardcoded strings in the `lib/src/features/noise_meter` directory need to be localized using `AppLocalizations`.

## Completed Files

1. ✅ **reports_actions_helper.dart** - Localized export and delete dialogs
   - Export Reports dialog
   - CSV clipboard success message
   - Export success dialog
   - Delete confirmation dialog

## Files Requiring Localization

### Widgets - High Priority

#### noise_meter_screen/

1. **noise_meter_guide_section.dart**

   - `'Noise Meter Guide'` → Use `l10n.noiseMeterGuide`

2. **noise_meter_feature_cards.dart**

   - `'Environment Analyzer'` → Use `l10n.environmentAnalyzer`
   - `'Preset-based acoustic analysis'` → Use `l10n.environmentAnalyzerSubtitle`
   - `'Acoustic Reports'` → Use `l10n.reportsTitle`
   - `'View saved analyses and history'` → Use `l10n.acousticReportsSubtitle`

3. **noise_meter_statistics_section.dart**

   - `'Decibel Statistics'` → Use `l10n.decibelStatistics`
   - `'Minimum'` → Use `l10n.minimum`
   - `'Average'` → Use `l10n.average`
   - `'Maximum'` → Use `l10n.maximum`
   - `'Quiet Environment'` → Use `l10n.quietEnvironment`
   - `'Moderate Noise'` → Use `l10n.moderateNoise`
   - `'Loud Environment'` → Use `l10n.loudEnvironment`
   - `'Very Loud - Caution'` → Use `l10n.veryLoudCaution`
   - `'Dangerous Levels'` → Use `l10n.dangerousLevels`

4. **noise_meter_current_reading.dart**

   - `'Current'` → Use `l10n.current`
   - `'Level'` → Use `l10n.level`
   - `'Avg'` → Use `l10n.avg`

5. **noise_meter_chart_section.dart**

   - `'Real-time Noise Levels'` → Use `l10n.realtimeNoiseLevels`

6. **noise_meter_permission_section.dart**

   - `'Grant microphone permission to measure noise levels'` → Use `l10n.grantMicrophonePermission`

7. **noise_meter_error_section.dart**
   - `'An error occurred.'` → Use `l10n.anErrorOccurred`

#### report/

8. **hourly_breakdown_chart.dart**

   - `'Hourly Breakdown'` → Use `l10n.hourlyBreakdown`

9. **event_timeline_card.dart**

   - `'Event Timeline'` → Use `l10n.eventTimeline`
   - `'No events recorded'` (default param) → Use `l10n.noEventsRecorded`

10. **quality_metrics_row.dart**
    - `'Consistency'` → Use `l10n.consistency`
    - `'Peak Mgmt'` → Use `l10n.peakManagement`

#### acoustic_report_detail/

11. **session_info_section.dart**

    - `'Session Details'` → Use `l10n.sessionDetails`
    - `'Date'` → Use `l10n.date`
    - `'Duration'` → Use `l10n.duration`
    - `'Preset'` → Use `l10n.preset`

12. **recommendation_section.dart**

    - `'Recommendation'` → Use `l10n.recommendation`

13. **quality_score_card.dart**

    - `'Environment Quality'` → Use `l10n.reportQualityTitle`

14. **events_section.dart**

    - `'No Interruptions Detected'` → Use `l10n.reportNoEventsTitle`
    - `'Your environment was consistently quiet'` → Use `l10n.reportNoEventsMessage`
    - `'Noise Events'` → Use `l10n.reportNoiseEvents`

15. **report_statistics.dart**
    - `'Average'` → Use `l10n.average`
    - `'Peak'` → Use `l10n.reportPeak`

#### acoustic_reports_list/

16. **filter_menu.dart**

    - `'All Presets'` → Use `l10n.allPresets`

17. **export_dialog.dart**

    - `'Export Reports'` → Use `l10n.exportReports`
    - `'Choose how you want to export...'` → Use `l10n.exportChooseMethod`
    - `'Copy to Clipboard'` → Use `l10n.exportCopyToClipboard`
    - `'Save as File'` → Use `l10n.exportSaveAsFile`

18. **export_success_dialog.dart**
    - `'Export Successful'` → Use `l10n.exportSuccess`
    - `'report(s) exported successfully!'` → Use `l10n.exportSuccessMessage(count)`
    - `'OK'` → Use `l10n.actionOk`

#### acoustic_preset_selection/

19. **preset_list_widget.dart**
    - `'Delete Preset?'` → Use `l10n.deletePreset`
    - `'Delete "..."? This cannot be undone.'` → Use `l10n.deletePresetMessage(title)`
    - `'CANCEL'` → Use `l10n.cancel.toUpperCase()`
    - `'DELETE'` → Use `l10n.delete.toUpperCase()`

### Screens

20. **acoustic_report_detail_screen.dart**

    - `'Acoustic Report'` → Use `l10n.acousticReport`

21. **custom_preset_creation_screen.dart**

    - `'Create Custom Preset'` → Use `l10n.createCustomPreset`
    - `'Duration must be greater than 0'` → Use `l10n.durationMustBeGreaterThanZero`

22. **acoustic_monitoring_screen.dart**
    - `'No Interruptions'` → Use `l10n.noInterruptions`

### Utils

23. **noise_formatters.dart**

    - `'Quiet (0-30 dB)'` → Use `l10n.quietQuiet`
    - `'Moderate (30-60 dB)'` → Use `l10n.quietModerate`
    - `'Loud (60-85 dB)'` → Use `l10n.quietLoud`
    - `'Very Loud (85-100 dB)'` → Use `l10n.quietVeryLoud`
    - `'Dangerous (100+ dB)'` → Use `l10n.quietDangerous`

24. **context_extensions.dart**

    - `'OK'` default button → Use `l10n.actionOk`

25. **acoustic_preset_selection_utils.dart**
    - `'Failed to load presets: $e'` → Use `l10n.failedToLoadPresets(e.toString())`
    - `'Created "$title"!'` → Use `l10n.createdPreset(title)`
    - `'Failed to save preset: $e'` → Use `l10n.failedToSavePreset(e.toString())`

## Localization Keys Added to app_en.arb

All required keys have been added to `lib/l10n/app_en.arb`:

- Export-related keys
- Delete-related keys
- UI element labels (Minimum, Maximum, Average, etc.)
- Status messages
- Dialog titles and messages
- Noise level descriptions
- Error messages

## Next Steps

1. ✅ Add all required keys to `app_en.arb`
2. ⏳ Run `flutter gen-l10n` to regenerate localization files
3. ⏳ Update each file listed above to use `AppLocalizations.of(context)!`
4. ⏳ Add corresponding translations to `app_es.arb`, `app_ja.arb`, and `app_km.arb`
5. ⏳ Test all screens to verify localizations work correctly
6. ⏳ Remove any remaining hardcoded strings

## Translation Requirements

After English localization is complete, add translations for:

- Spanish (es)
- Japanese (ja)
- Khmer (km)

All new keys from lines 728-803 in app_en.arb need translations.
