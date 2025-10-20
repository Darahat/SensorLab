# 🏗️ Noise Meter Clean Architecture Refactoring Plan

**Project:** All-in-One-Sensor-Toolkit  
**Feature:** noise_meter  
**Date:** October 20, 2025  
**Goal:** Transform current structure to proper Clean Architecture

---

## 📊 Current Structure Analysis

```
lib/src/features/noise_meter/
├── data/
│   ├── models/
│   │   ├── acoustic_event_hive.dart
│   │   ├── acoustic_event_hive.g.dart
│   │   ├── acoustic_report_hive.dart
│   │   └── acoustic_report_hive.g.dart
│   └── repositories/
│       └── acoustic_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── acoustic_report_entity.dart
│   │   ├── acoustic_report_entity.freezed.dart
│   │   └── noise_data.dart
│   └── repositories/
│       └── acoustic_repository.dart
├── presentation/
│   ├── models/
│   │   ├── custom_preset_config.dart
│   │   └── custom_preset_config.freezed.dart
│   ├── providers/          ❌ WRONG LAYER (should be in application/)
│   │   ├── acoustic_reports_list_controller.dart
│   │   ├── custom_preset_provider.dart
│   │   └── enhanced_noise_meter_provider.dart
│   ├── screens/
│   │   ├── acoustic_monitoring_screen.dart
│   │   ├── acoustic_preset_selection_screen.dart
│   │   ├── acoustic_report_detail_screen.dart
│   │   ├── acoustic_reports_list_screen.dart
│   │   └── noise_meter_screen.dart
│   ├── state/              ⚠️ PARTIAL (UI state OK, business logic should move)
│   │   ├── acoustic_reports_list_state.dart
│   │   ├── acoustic_reports_list_state.freezed.dart
│   │   ├── enhanced_noise_data.dart
│   │   └── enhanced_noise_data.freezed.dart
│   └── widgets/
│       ├── acoustic_monitoring/
│       ├── acoustic_preset_selection/
│       ├── acoustic_report_detail/
│       ├── acoustic_reports_list/
│       ├── acoustic_reports_list_screen/
│       ├── common/
│       ├── noise_meter_screen/
│       └── widgets_index.dart
├── services/               ❌ WRONG LOCATION (should be in application/)
│   ├── acoustic_report_service.dart
│   ├── noise_analysis_service.dart
│   ├── noise_event_detector_service.dart
│   └── report_export_service.dart
└── utils/
    ├── acoustic_preset_selection_utils.dart
    ├── noise_level_formatter.dart
    └── utils_index.dart
```

---

## 🎯 Target Structure (Clean Architecture)

```
lib/src/features/noise_meter/
├── data/
│   ├── datasources/        ✨ NEW - Raw data access
│   │   └── noise_meter_datasource.dart
│   ├── models/             ✅ KEEP - DTOs for Hive
│   │   ├── acoustic_event_hive.dart
│   │   ├── acoustic_event_hive.g.dart
│   │   ├── acoustic_report_hive.dart
│   │   └── acoustic_report_hive.g.dart
│   ├── providers/          ✨ NEW - Data layer providers
│   │   └── acoustic_repository_provider.dart
│   └── repositories/       ✅ KEEP - Repository implementations
│       └── acoustic_repository_impl.dart
├── domain/                 ✅ PERFECT - No changes needed
│   ├── entities/
│   │   ├── acoustic_report_entity.dart
│   │   ├── acoustic_report_entity.freezed.dart
│   │   └── noise_data.dart
│   └── repositories/
│       └── acoustic_repository.dart
├── application/            ✨ NEW LAYER - Business Logic
│   ├── notifiers/
│   │   ├── enhanced_noise_meter_notifier.dart      (from presentation/providers/)
│   │   └── acoustic_reports_list_notifier.dart     (from presentation/providers/)
│   ├── providers/
│   │   ├── enhanced_noise_meter_provider.dart      (provider only, notifier in notifiers/)
│   │   ├── acoustic_reports_list_provider.dart     (provider only)
│   │   └── custom_preset_provider.dart             (from presentation/providers/)
│   ├── services/
│   │   ├── acoustic_report_service.dart            (from root services/)
│   │   ├── noise_analysis_service.dart             (from root services/)
│   │   ├── noise_event_detector_service.dart       (from root services/)
│   │   └── report_export_service.dart              (from root services/)
│   └── state/
│       ├── enhanced_noise_data.dart                (from presentation/state/)
│       ├── enhanced_noise_data.freezed.dart
│       ├── acoustic_reports_list_state.dart        (from presentation/state/)
│       └── acoustic_reports_list_state.freezed.dart
├── presentation/           ✅ KEEP - Pure UI
│   ├── models/             ✅ KEEP - UI-specific models
│   │   ├── custom_preset_config.dart
│   │   └── custom_preset_config.freezed.dart
│   ├── screens/            ✅ KEEP - Screen widgets
│   │   ├── acoustic_monitoring_screen.dart
│   │   ├── acoustic_preset_selection_screen.dart
│   │   ├── acoustic_report_detail_screen.dart
│   │   ├── acoustic_reports_list_screen.dart
│   │   └── noise_meter_screen.dart
│   └── widgets/            ✅ KEEP - Reusable widgets
│       ├── acoustic_monitoring/
│       ├── acoustic_preset_selection/
│       ├── acoustic_report_detail/
│       ├── acoustic_reports_list/
│       ├── acoustic_reports_list_screen/
│       ├── common/
│       ├── noise_meter_screen/
│       └── widgets_index.dart
└── utils/                  ✅ KEEP - Shared utilities
    ├── acoustic_preset_selection_utils.dart
    ├── noise_level_formatter.dart
    └── utils_index.dart
```

---

## 📝 Step-by-Step Refactoring Tasks

### **Phase 1: Create New Directory Structure** ⏱️ 5 minutes

#### Step 1.1: Create `application/` layer folders

```powershell
# Navigate to noise_meter directory
cd "d:\Dream\Flutter App\SensorLab\lib\src\features\noise_meter"

# Create application layer structure
New-Item -Path "application\notifiers" -ItemType Directory -Force
New-Item -Path "application\providers" -ItemType Directory -Force
New-Item -Path "application\services" -ItemType Directory -Force
New-Item -Path "application\state" -ItemType Directory -Force
```

#### Step 1.2: Create `data/datasources` and `data/providers`

```powershell
New-Item -Path "data\datasources" -ItemType Directory -Force
New-Item -Path "data\providers" -ItemType Directory -Force
```

✅ **Checkpoint:** Verify folders created

```powershell
tree /F application
tree /F data
```

---

### **Phase 2: Move Service Files** ⏱️ 10 minutes

#### Step 2.1: Move all service files to `application/services/`

```powershell
# Move service files
Move-Item "services\acoustic_report_service.dart" "application\services\"
Move-Item "services\noise_analysis_service.dart" "application\services\"
Move-Item "services\noise_event_detector_service.dart" "application\services\"
Move-Item "services\report_export_service.dart" "application\services\"

# Remove empty services directory
Remove-Item "services" -Force
```

#### Step 2.2: Update imports in moved service files

**Files to update:**

- `application/services/acoustic_report_service.dart`
- `application/services/noise_analysis_service.dart`
- `application/services/noise_event_detector_service.dart`
- `application/services/report_export_service.dart`

**Import changes:**

```dart
// OLD: No change needed (they import from domain/data layers below them)
// Just verify paths still work after move
```

✅ **Checkpoint:** Services moved successfully

```powershell
Get-ChildItem "application\services"
```

---

### **Phase 3: Move State Files** ⏱️ 10 minutes

#### Step 3.1: Move state files to `application/state/`

```powershell
# Move state files
Move-Item "presentation\state\enhanced_noise_data.dart" "application\state\"
Move-Item "presentation\state\enhanced_noise_data.freezed.dart" "application\state\"
Move-Item "presentation\state\acoustic_reports_list_state.dart" "application\state\"
Move-Item "presentation\state\acoustic_reports_list_state.freezed.dart" "application\state\"

# Remove empty state directory
Remove-Item "presentation\state" -Force
```

#### Step 3.2: Update imports in moved state files

**File:** `application/state/enhanced_noise_data.dart`

```dart
// Update import if needed (domain entities import should still work)
```

**File:** `application/state/acoustic_reports_list_state.dart`

```dart
// Update import if needed
```

✅ **Checkpoint:** State files moved

```powershell
Get-ChildItem "application\state"
```

---

### **Phase 4: Split and Move Provider Files** ⏱️ 30 minutes

This is the most complex phase as we need to separate **business logic (Notifiers)** from **provider declarations**.

#### Step 4.1: Handle `enhanced_noise_meter_provider.dart`

**Current file structure:**

```dart
// Contains both:
// 1. EnhancedNoiseMeterNotifier (business logic) - should go to application/notifiers/
// 2. enhancedNoiseMeterProvider (Riverpod provider) - should go to application/providers/
```

**Actions:**

1. Create `application/notifiers/enhanced_noise_meter_notifier.dart` (NEW FILE)
2. Create `application/providers/enhanced_noise_meter_provider.dart` (NEW FILE)
3. Delete `presentation/providers/enhanced_noise_meter_provider.dart` (OLD FILE)

#### Step 4.2: Handle `acoustic_reports_list_controller.dart`

**Current file structure:**

```dart
// Contains both:
// 1. AcousticReportsListController (business logic) - should go to application/notifiers/
// 2. acousticReportsListProvider (Riverpod provider) - should go to application/providers/
```

**Actions:**

1. Create `application/notifiers/acoustic_reports_list_notifier.dart` (NEW FILE)
2. Create `application/providers/acoustic_reports_list_provider.dart` (NEW FILE)
3. Delete `presentation/providers/acoustic_reports_list_controller.dart` (OLD FILE)

#### Step 4.3: Move `custom_preset_provider.dart`

```powershell
# This file can be moved as-is (UI state management)
Move-Item "presentation\providers\custom_preset_provider.dart" "application\providers\"
```

#### Step 4.4: Remove empty providers directory

```powershell
Remove-Item "presentation\providers" -Force
```

✅ **Checkpoint:** Providers reorganized

```powershell
Get-ChildItem "application\notifiers"
Get-ChildItem "application\providers"
```

---

### **Phase 5: Create Data Layer Files** ⏱️ 15 minutes

#### Step 5.1: Create `data/datasources/noise_meter_datasource.dart`

This will encapsulate direct microphone access (currently in repository).

#### Step 5.2: Create `data/providers/acoustic_repository_provider.dart`

Move the provider from `acoustic_repository_impl.dart` to separate file.

✅ **Checkpoint:** Data layer complete

---

### **Phase 6: Update All Import References** ⏱️ 45-60 minutes

This is **critical** - all files importing moved files need updated paths.

#### Files that need import updates:

**Screens (5 files):**

1. `presentation/screens/noise_meter_screen.dart`
2. `presentation/screens/acoustic_monitoring_screen.dart`
3. `presentation/screens/acoustic_preset_selection_screen.dart`
4. `presentation/screens/acoustic_report_detail_screen.dart`
5. `presentation/screens/acoustic_reports_list_screen.dart`

**Widgets (~30+ files):**

- All files in `presentation/widgets/**/` that import providers/state

**Core providers:**

- `lib/src/core/providers.dart`

**Import pattern changes:**

```dart
// OLD IMPORTS
import 'package:sensorlab/src/features/noise_meter/presentation/providers/enhanced_noise_meter_provider.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/enhanced_noise_data.dart';

// NEW IMPORTS
import 'package:sensorlab/src/features/noise_meter/application/providers/enhanced_noise_meter_provider.dart';
import 'package:sensorlab/src/features/noise_meter/application/state/enhanced_noise_data.dart';
```

✅ **Checkpoint:** Run build to check for import errors

```powershell
flutter pub get
flutter analyze
```

---

### **Phase 7: Update Core Providers** ⏱️ 5 minutes

**File:** `lib/src/core/providers.dart`

Update export:

```dart
// OLD
export '../features/noise_meter/presentation/providers/enhanced_noise_meter_provider.dart';

// NEW
export '../features/noise_meter/application/providers/enhanced_noise_meter_provider.dart';
```

---

### **Phase 8: Testing & Validation** ⏱️ 20 minutes

#### Step 8.1: Build the project

```powershell
flutter clean
flutter pub get
flutter build apk --debug
```

#### Step 8.2: Run the app and test noise_meter features

- Open noise meter screen
- Test acoustic monitoring
- Test report generation
- Test report list and export
- Test report detail view

#### Step 8.3: Run tests (if available)

```powershell
flutter test
```

---

## 📊 Summary Statistics

### Files to Create:

- **6 new files** (datasource, notifiers, separated providers)

### Files to Move:

- **4 service files** → `application/services/`
- **4 state files** → `application/state/`
- **1 provider file** → `application/providers/`

### Files to Split & Recreate:

- **2 provider files** → Split into notifier + provider

### Files to Update (imports):

- **5 screen files**
- **~30 widget files**
- **1 core provider file**
- **Files in application layer** (internal imports)

### Directories to Create:

- `application/notifiers/`
- `application/providers/`
- `application/services/`
- `application/state/`
- `data/datasources/`
- `data/providers/`

### Directories to Remove:

- `services/` (root level)
- `presentation/providers/`
- `presentation/state/`

---

## ⏰ Estimated Time

| Phase     | Task                       | Time           |
| --------- | -------------------------- | -------------- |
| 1         | Create directory structure | 5 min          |
| 2         | Move service files         | 10 min         |
| 3         | Move state files           | 10 min         |
| 4         | Split & move providers     | 30 min         |
| 5         | Create data layer files    | 15 min         |
| 6         | Update all imports         | 60 min         |
| 7         | Update core providers      | 5 min          |
| 8         | Testing & validation       | 20 min         |
| **Total** |                            | **~2.5 hours** |

---

## 🚨 Risk Assessment

### High Risk:

- **Import path updates** - Missing even one will cause build errors
- **Provider splitting** - Must maintain same public API

### Medium Risk:

- **State file references** - Freezed files need regeneration if imports change
- **Widget dependencies** - Many widgets depend on providers

### Low Risk:

- **Service moves** - Services are self-contained
- **Directory creation** - Safe operation

---

## 🔄 Rollback Plan

If issues occur:

```powershell
# Rollback using git
git status
git diff
git checkout .
git clean -fd
```

---

## 📌 Post-Refactoring Tasks

1. ✅ Update `ACOUSTIC_ANALYZER_IMPLEMENTATION.md` with new structure
2. ✅ Update `LOCALIZATION_TODO.md` with new file paths
3. ✅ Run code generation for Freezed files
4. ✅ Update documentation comments in moved files
5. ✅ Complete localization of remaining files (using new paths)

---

## 🎯 Success Criteria

- [ ] All files build without errors
- [ ] All imports resolve correctly
- [ ] App runs and noise_meter feature works
- [ ] No duplicate code
- [ ] Clean architecture layers properly separated
- [ ] All tests pass (if applicable)

---

**Ready to start?** Let's begin with **Phase 1: Create New Directory Structure**!
