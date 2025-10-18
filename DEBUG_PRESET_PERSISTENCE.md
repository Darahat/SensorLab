# Debug Guide: Custom Preset Persistence

## Issue

Custom presets not showing after app refresh/restart.

## Debug Logging Added

I've added comprehensive debug logging to help identify the issue. The logs will show:

### Service Layer (`custom_preset_service.dart`)

- 🔧 When service initializes
- 📦 Box opening/status
- 💾 When presets are saved (with ID and count)
- 📖 When presets are loaded
- 🔑 All keys in the box
- ✓ Each preset loaded with its ID and title

### UI Layer (`acoustic_preset_selection_screen.dart`)

- 🚀 When screen initializes
- 🔄 When loading starts
- ✅ Number of presets retrieved
- 🎨 When creating new preset
- 💾 Preset saved with ID
- ❌ Any errors with full stack traces

## Testing Steps

1. **Clear existing data (optional, for clean test):**

   - Delete app data or uninstall/reinstall the app

2. **Run the app and check initial logs:**

   ```
   flutter run
   ```

   - Look for: `🚀 AcousticPresetSelectionScreen.initState() called`
   - Look for: `📦 Box contains X items`

3. **Create a custom preset:**

   - Navigate to Acoustic Analyzer
   - Tap "+" button
   - Fill in preset details
   - Save
   - **Expected logs:**
     ```
     🎨 _createCustomPreset() called
     💾 savePreset() called for: [Your Title]
     📝 Generated ID: [timestamp]
     ✅ Saved to Hive. Box now contains 1 items
     📋 All keys in box: [list of IDs]
     💾 Preset saved with ID: [timestamp]
     ✅ Local state updated
     ```

4. **Verify preset appears immediately:**

   - Should see the preset in the list below "Custom Presets" divider
   - If NOT visible: Check logs for errors

5. **Hot restart (not hot reload):**

   - Press `R` in terminal or use restart button
   - **Expected logs:**
     ```
     🚀 AcousticPresetSelectionScreen.initState() called
     🔄 _loadCustomPresets() started
     📖 getAllPresetsWithIds() called
     📦 Box contains 1 items
     🔑 Keys: [list of IDs]
     ✓ Loaded: [ID] -> [Title]
     ✅ Retrieved 1 presets from service
     ✅ State updated with presets
     ```

6. **Full app restart:**
   - Stop the app completely (Shift+F5 or stop button)
   - Run again: `flutter run`
   - Navigate to Acoustic Analyzer screen
   - **Expected:** Same logs as hot restart above

## What to Check in Logs

### ✅ Success Indicators:

- `✅ Saved to Hive. Box now contains X items` after saving
- `📋 All keys in box: [your-preset-id]` showing your preset ID
- `✓ Loaded: [ID] -> [Title]` when loading
- `✅ Retrieved X presets from service` with X > 0

### ❌ Problem Indicators:

- `📦 Box contains 0 items` after saving (save failed)
- `📦 Box contains X items` but no `✓ Loaded:` messages (keys don't match)
- `❌ Error loading custom presets:` with error message
- Box opens but items are 0 after restart (persistence failed)

## Common Issues & Solutions

### Issue 1: Box opens but no items after restart

**Cause:** Hive not properly initialized before UI loads
**Check:** Look for `🔧 CustomPresetService.init() called` BEFORE `🚀 AcousticPresetSelectionScreen.initState()`

### Issue 2: Items saved but can't be retrieved

**Cause:** Type adapter not registered or key mismatch
**Check:**

- Verify build_runner generated `.g.dart` files
- Check if keys match between save and load

### Issue 3: Items persist but don't show in UI

**Cause:** UI state not updating
**Check:**

- Look for `✅ State updated with presets`
- Verify `_customPresets` map is populated

## Quick Verification Script

Run this in your terminal while app is running to check Hive data:

```bash
# Android
adb shell run-as [your.package.name] ls -la /data/data/[your.package.name]/app_flutter/

# iOS
# Hive data is in app's Documents directory
```

## Expected File Structure

After saving a preset, you should see:

```
app_flutter/
  └── customPresetsBox.hive
  └── customPresetsBox.lock
```

## Next Steps Based on Logs

1. **If box opens but shows 0 items after restart:**

   - Check if Hive.initFlutter() is called in main()
   - Verify adapter is registered before opening box

2. **If items save but keys are empty:**

   - Check CustomPresetHive.id generation
   - Verify box.keys returns the correct keys

3. **If logs show errors:**

   - Share the error message and stack trace
   - Check if adapter version matches model

4. **If everything looks good in logs but UI doesn't show:**
   - Check if `_customPresets` map is being used in build()
   - Verify divider and section are rendering

---

**Let me know what the logs show and we'll debug from there!** 🔍
