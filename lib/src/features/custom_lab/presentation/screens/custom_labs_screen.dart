import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/custom_labs_screen_provider.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/presets_provider.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/screens/create_lab_screen.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/custom_labs_screen/all_labs_tab.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/custom_labs_screen/my_labs_tab.dart';

class CustomLabsScreen extends ConsumerStatefulWidget {
  const CustomLabsScreen({super.key});

  @override
  ConsumerState<CustomLabsScreen> createState() => _CustomLabsScreenState();
}

class _CustomLabsScreenState extends ConsumerState<CustomLabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _presetsInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize tab controller in provider safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tabControllerProvider.notifier).state = _tabController;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Initialize presets on first build using Future.microtask
    if (!_presetsInitialized) {
      _presetsInitialized = true;
      Future.microtask(() => _verifyPresetsInitialization());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customLabs),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.allLabs, icon: const Icon(Icons.science)),
            Tab(text: l10n.myLabs, icon: const Icon(Icons.folder)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [AllLabsTab(), MyLabsTab()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleCreateLab,
        icon: const Icon(Icons.add),
        label: Text(l10n.newLab),
      ),
    );
  }

  void _verifyPresetsInitialization() async {
    final state = ref.read(presetsInitializationProvider);

    if (!state.isInitialized && !state.isLoading) {
      print('Presets not initialized in CustomLabsScreen, retrying...');
      try {
        await ref
            .read(presetsInitializationProvider.notifier)
            .initializePresets();
      } catch (e) {
        print('Failed to initialize presets in screen: $e');
      }
    }
  }

  void _handleCreateLab() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const CreateLabScreen()));
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Use Future.microtask to safely modify provider during dispose
    Future.microtask(() {
      ref.read(tabControllerProvider.notifier).state = null;
    });
    super.dispose();
  }
}
