# 🚀 Quick Start Template - Health Tracker App

Ready-to-use template for creating a health tracking app with SensorLab features.

## 📦 Copy This pubspec.yaml

```yaml
name: health_tracker_app
description: Health tracking app with user management and settings

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

  # Health Sensors
  sensors_plus: ^4.0.2
  pedometer: ^4.0.2

  # Permissions
  permission_handler: ^11.1.0

  # Utils
  logger: ^2.6.2
  json_annotation: ^4.9.0
  uuid: ^4.2.1

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
  generate: true

  assets:
    - assets/images/
    - assets/icons/
```

## 📁 Folder Structure to Create

```bash
# Run these commands in your project root
mkdir -p lib/src/core/{constants,services,generated}
mkdir -p lib/src/features/{health,app_settings,user_profile}/{models,providers,screens,widgets}
mkdir -p lib/src/shared/{widgets,themes}
mkdir -p lib/l10n
mkdir -p assets/{images,icons}
```

## 🔧 Essential Configuration Files

### l10n.yaml (Project Root)

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/src/core/generated/
```

### analysis_options.yaml (Project Root)

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "lib/src/core/generated/**"
```

## 📋 Step-by-Step Setup

### 1. Create Project & Setup Dependencies

```bash
flutter create health_tracker_app
cd health_tracker_app

# Replace pubspec.yaml with the one above
# Then run:
flutter pub get
```

### 2. Copy Files from SensorLab

**Required Files to Copy:**

```bash
# Core Services
SensorLab/lib/src/core/services/hive_service.dart → lib/src/core/services/
SensorLab/lib/src/core/services/initialization_service.dart → lib/src/core/services/

# Health Feature (Complete)
SensorLab/lib/src/features/health/ → lib/src/features/health/

# App Settings Feature (Complete)
SensorLab/lib/src/features/app_settings/ → lib/src/features/app_settings/

# Themes
SensorLab/lib/src/shared/themes/ → lib/src/shared/themes/

# Localization Files
SensorLab/lib/l10n/app_en.arb → lib/l10n/
SensorLab/lib/l10n/app_es.arb → lib/l10n/
SensorLab/lib/l10n/app_ja.arb → lib/l10n/
SensorLab/lib/l10n/app_km.arb → lib/l10n/
```

### 3. Main App Structure

**lib/main.dart**

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

    return MaterialApp(
      title: 'Health Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(settings.language),

      home: const HomeScreen(),
    );
  }
}
```

**lib/src/app.dart**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/health/screens/health_screen.dart';
import 'features/user_profile/screens/profile_screen.dart';
import 'features/app_settings/screens/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HealthScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Health',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
```

### 4. User Profile CRUD Screen

**lib/src/features/user_profile/screens/profile_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/generated/app_localizations.dart';
import '../providers/user_provider.dart';
import '../widgets/user_form.dart';
import '../widgets/user_list.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userListProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.userProfile),
      ),
      body: Column(
        children: [
          // Add User Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => _showUserForm(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add User'),
            ),
          ),

          // Users List
          Expanded(
            child: users.isEmpty
                ? const Center(child: Text('No users yet'))
                : UserList(users: users),
          ),
        ],
      ),
    );
  }

  void _showUserForm(BuildContext context, WidgetRef ref, [User? user]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: UserForm(user: user),
      ),
    );
  }
}
```

### 5. Simple User CRUD Provider

**lib/src/features/user_profile/providers/user_provider.dart**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

final userListProvider = StateNotifierProvider<UserListNotifier, List<User>>((ref) {
  return UserListNotifier();
});

class UserListNotifier extends StateNotifier<List<User>> {
  UserListNotifier() : super([]) {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final box = Hive.box<User>('users');
    state = box.values.toList();
  }

  Future<void> addUser(User user) async {
    final box = Hive.box<User>('users');
    await box.put(user.id, user);
    state = [...state, user];
  }

  Future<void> updateUser(User user) async {
    final box = Hive.box<User>('users');
    await box.put(user.id, user);
    state = state.map((u) => u.id == user.id ? user : u).toList();
  }

  Future<void> deleteUser(String id) async {
    final box = Hive.box<User>('users');
    await box.delete(id);
    state = state.where((u) => u.id != id).toList();
  }
}
```

## 🏃‍♂️ Quick Commands to Run

```bash
# Generate code (after copying files)
dart run build_runner build --delete-conflicting-outputs

# Generate localizations
flutter gen-l10n

# Run the app
flutter run
```

## 🎯 What You'll Get

After following this guide, you'll have a complete Flutter app with:

✅ **Health Tracking Dashboard**
✅ **User Profile Management (CRUD)**
✅ **App Settings (Theme, Language, etc.)**
✅ **Hive Database for Local Storage**
✅ **4 Language Support**
✅ **Material Design 3 Theme**
✅ **Sensor Integration Ready**

## 🆘 Need Help?

1. **Check the full guide**: [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md)
2. **Open an issue**: [GitHub Issues](https://github.com/Darahat/All-in-One-Sensor-Toolkit/issues)
3. **Study the source**: Browse SensorLab codebase for examples

---

**Ready to build your health app!** 🚀💪
