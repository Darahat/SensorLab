# 🚀 Feature Integration Guide - Health App with Settings

This guide shows beginner developers how to extract and integrate specific features from SensorLab into their own Flutter apps.

## 🎯 What You'll Build

A standalone Flutter app with:

- ✅ **Health Module** - Activity tracking, calorie counting, session management
- ✅ **User Profile CRUD** - Create, Read, Update, Delete user information
- ✅ **App Settings** - Theme, language, preferences management
- ✅ **Hive Database** - Local data storage
- ✅ **Localization** - Multi-language support (4 languages)
- ✅ **Material Design 3** - Modern UI theme system

## 📋 Prerequisites

### Development Environment

```bash
# Flutter SDK 3.0+
flutter --version

# IDE with Flutter support
# - VS Code with Flutter extension
# - Android Studio with Flutter plugin
```

### Basic Knowledge Required

- Dart programming basics
- Flutter widgets and state management
- Basic understanding of Provider/Riverpod

## 🏗️ Step-by-Step Integration

### Step 1: Create New Flutter Project

```bash
# Create new Flutter project
flutter create health_tracker_app
cd health_tracker_app

# Open in your IDE
code .  # For VS Code
```

### Step 2: Copy Core Dependencies

Update your `pubspec.yaml` with required dependencies:

```yaml
name: health_tracker_app
description: Health tracking app with user management

publish_to: "none"
version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.4.9

  # Database
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Localization
  flutter_localizations:
    sdk: flutter
  intl: any

  # UI & Navigation
  go_router: ^14.6.1

  # Sensors (for health tracking)
  sensors_plus: ^4.0.2
  pedometer: ^4.0.2

  # Permissions
  permission_handler: ^11.1.0

  # Utils
  logger: ^2.6.2
  json_annotation: ^4.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

  # Code Generation
  build_runner: ^2.4.11
  hive_generator: ^2.0.1
  json_serializable: ^6.6.2

flutter:
  uses-material-design: true
  generate: true # Enable localization

  assets:
    - assets/images/
    - assets/icons/
```

### Step 3: Set Up Project Structure

Create the following folder structure:

```bash
# Create core directories
mkdir -p lib/src/core/{constants,errors,services,utils}
mkdir -p lib/src/features/{health,app_settings,user_profile}
mkdir -p lib/src/shared/{widgets,models,themes}
mkdir -p lib/l10n
mkdir -p assets/{images,icons}
```

Your structure should look like:

```
lib/
├── src/
│   ├── core/                    # Core functionality
│   │   ├── constants/
│   │   ├── services/
│   │   └── utils/
│   ├── features/               # Feature modules
│   │   ├── health/             # Health tracking
│   │   ├── app_settings/       # Settings management
│   │   └── user_profile/       # User CRUD
│   └── shared/                 # Shared components
│       ├── widgets/
│       ├── models/
│       └── themes/
├── l10n/                       # Localization files
└── main.dart
```

## 📁 Files to Copy from SensorLab

### Core Services & Configuration

**From SensorLab, copy these files to your project:**

#### 1. Hive Service (`lib/src/core/services/`)

```bash
# Copy from SensorLab
cp SensorLab/lib/src/core/services/hive_service.dart your_app/lib/src/core/services/
```

#### 2. Initialization Service

```bash
cp SensorLab/lib/src/core/services/initialization_service.dart your_app/lib/src/core/services/
```

#### 3. Theme System (`lib/src/shared/themes/`)

```bash
cp -r SensorLab/lib/src/shared/themes/ your_app/lib/src/shared/themes/
```

### Feature Modules

#### 1. Health Feature (Complete Module)

```bash
# Copy entire health feature
cp -r SensorLab/lib/src/features/health/ your_app/lib/src/features/health/

# Files included:
# - models/ (user_profile.dart, health_data.dart, activity_session.dart)
# - providers/ (health_provider.dart, profile_provider.dart)
# - screens/ (health_screen.dart)
# - widgets/ (profile_editor.dart, health_cards.dart)
```

#### 2. App Settings Feature

```bash
# Copy app settings
cp -r SensorLab/lib/src/features/app_settings/ your_app/lib/src/features/app_settings/
```

### Localization Files

#### Copy Language Files

```bash
# Copy localization files
cp SensorLab/lib/l10n/app_en.arb your_app/lib/l10n/
cp SensorLab/lib/l10n/app_es.arb your_app/lib/l10n/
cp SensorLab/lib/l10n/app_ja.arb your_app/lib/l10n/
cp SensorLab/lib/l10n/app_km.arb your_app/lib/l10n/
```

#### Localization Configuration

Add to `pubspec.yaml`:

```yaml
flutter:
  generate: true

flutter_gen:
  output: lib/src/core/
  line_length: 80
```

Create `l10n.yaml` in project root:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/src/core/generated/
```

## 🔧 Essential Code Setup

### Main Application Setup

**`lib/main.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'src/core/generated/app_localizations.dart';
import 'src/core/services/initialization_service.dart';
import 'src/shared/themes/app_theme.dart';
import 'src/features/app_settings/providers/app_settings_provider.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(initializationServiceProvider).initialize();

  runApp(UncontrolledProviderScope(
    container: container,
    child: const HealthTrackerApp(),
  ));
}

class HealthTrackerApp extends ConsumerWidget {
  const HealthTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    return MaterialApp.router(
      title: 'Health Tracker',

      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(settings.language),

      // Navigation
      routerConfig: ref.watch(routerProvider),
    );
  }
}
```

### Router Configuration

**`lib/src/core/router/app_router.dart`**

```dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/health/screens/health_screen.dart';
import '../../features/user_profile/screens/profile_screen.dart';
import '../../features/app_settings/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/health',
    routes: [
      GoRoute(
        path: '/health',
        name: 'health',
        builder: (context, state) => const HealthScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
```

### User Profile CRUD Implementation

**`lib/src/features/user_profile/models/user.dart`**

```dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final int age;

  @HiveField(4)
  final double height; // in cm

  @HiveField(5)
  final double weight; // in kg

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.height,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON serialization
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // Copy with method for updates
  User copyWith({
    String? name,
    String? email,
    int? age,
    double? height,
    double? weight,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
```

**`lib/src/features/user_profile/providers/user_provider.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';

// User Repository
class UserRepository {
  static const String _boxName = 'users';
  late Box<User> _box;

  Future<void> init() async {
    _box = await Hive.openBox<User>(_boxName);
  }

  // Create
  Future<User> createUser({
    required String name,
    required String email,
    required int age,
    required double height,
    required double weight,
  }) async {
    final user = User(
      id: const Uuid().v4(),
      name: name,
      email: email,
      age: age,
      height: height,
      weight: weight,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _box.put(user.id, user);
    return user;
  }

  // Read
  User? getUser(String id) => _box.get(id);
  List<User> getAllUsers() => _box.values.toList();

  // Update
  Future<User> updateUser(User user) async {
    await _box.put(user.id, user);
    return user;
  }

  // Delete
  Future<void> deleteUser(String id) async {
    await _box.delete(id);
  }
}

// Providers
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final userListProvider = StateNotifierProvider<UserListNotifier, List<User>>((ref) {
  return UserListNotifier(ref.read(userRepositoryProvider));
});

final currentUserProvider = StateProvider<User?>((ref) => null);

// User List State Notifier
class UserListNotifier extends StateNotifier<List<User>> {
  final UserRepository _repository;

  UserListNotifier(this._repository) : super([]) {
    loadUsers();
  }

  void loadUsers() {
    state = _repository.getAllUsers();
  }

  Future<void> createUser({
    required String name,
    required String email,
    required int age,
    required double height,
    required double weight,
  }) async {
    final user = await _repository.createUser(
      name: name,
      email: email,
      age: age,
      height: height,
      weight: weight,
    );
    state = [...state, user];
  }

  Future<void> updateUser(User updatedUser) async {
    await _repository.updateUser(updatedUser);
    state = state.map((user) =>
      user.id == updatedUser.id ? updatedUser : user
    ).toList();
  }

  Future<void> deleteUser(String id) async {
    await _repository.deleteUser(id);
    state = state.where((user) => user.id != id).toList();
  }
}
```

## 🎨 UI Implementation Examples

### Health Dashboard

**`lib/src/features/health/screens/health_dashboard.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/generated/app_localizations.dart';
import '../providers/health_provider.dart';
import '../widgets/health_stats_card.dart';
import '../widgets/activity_chart.dart';

class HealthDashboard extends ConsumerWidget {
  const HealthDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthData = ref.watch(healthDataProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.healthTracking),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Health Stats Cards
            Row(
              children: [
                Expanded(
                  child: HealthStatsCard(
                    title: l10n.steps,
                    value: healthData.todaySteps.toString(),
                    icon: Icons.directions_walk,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: HealthStatsCard(
                    title: l10n.calories,
                    value: healthData.todayCalories.toStringAsFixed(0),
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Activity Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.weeklyActivity,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: ActivityChart(data: healthData.weeklyData),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 📱 Complete App Integration Checklist

### Phase 1: Basic Setup ✅

- [ ] Create Flutter project
- [ ] Add dependencies to pubspec.yaml
- [ ] Set up folder structure
- [ ] Copy core services from SensorLab

### Phase 2: Database & Models ✅

- [ ] Set up Hive database
- [ ] Create User model with CRUD
- [ ] Create Health data models
- [ ] Generate Hive adapters: `dart run build_runner build`

### Phase 3: Features Integration ✅

- [ ] Copy Health module from SensorLab
- [ ] Implement User Profile CRUD
- [ ] Copy App Settings module
- [ ] Set up navigation with GoRouter

### Phase 4: UI & Localization ✅

- [ ] Copy theme system
- [ ] Set up localization files
- [ ] Generate localization: `flutter gen-l10n`
- [ ] Create main app structure

### Phase 5: Testing & Polish ✅

- [ ] Test all CRUD operations
- [ ] Test theme switching
- [ ] Test language switching
- [ ] Test health data persistence

## 🚀 Running Your App

```bash
# Generate necessary files
dart run build_runner build
flutter gen-l10n

# Run the app
flutter run
```

## 📚 Learning Resources

### Understanding the Codebase

- **[SensorLab Architecture](../PROJECT_ARCHITECTURE.md)** - Complete technical overview
- **[Health Module Docs](../docs/modules/health.md)** - Detailed health feature guide
- **[Settings Module Docs](../docs/modules/app_settings.md)** - Settings implementation

### Flutter Learning Path

1. **Riverpod State Management**: [riverpod.dev](https://riverpod.dev)
2. **Hive Database**: [docs.hivedb.dev](https://docs.hivedb.dev)
3. **Flutter Localization**: [flutter.dev/internationalization](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)

## 🆘 Common Issues & Solutions

### Build Errors

```bash
# Missing generated files
dart run build_runner build --delete-conflicting-outputs

# Localization errors
flutter gen-l10n
flutter clean && flutter pub get
```

### Hive Setup Issues

```bash
# Register adapters in main.dart before runApp
Hive.registerAdapter(UserAdapter());
```

### Import Errors

- Update import paths to match your project structure
- Use relative imports within feature modules
- Use absolute imports for shared components

## 🤝 Contributing Back

If you build something cool with this integration:

1. **Share your experience** - Open discussions in SensorLab repo
2. **Contribute improvements** - Submit PRs for better integration guides
3. **Report issues** - Help improve the documentation

## 📄 License & Attribution

When using SensorLab components:

- ✅ **MIT License** - Free to use and modify
- ✅ **Attribution appreciated** - Link back to SensorLab repo
- ✅ **Share improvements** - Help the community grow

---

**Happy Coding!** 🎉

Need help? Open an issue in the [SensorLab repository](https://github.com/Darahat/All-in-One-Sensor-Toolkit) with the `integration-help` label.
