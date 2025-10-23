import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_management_provider.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/presets_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/screens/create_lab_screen.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/screens/lab_detail_screen.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/lab_card.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/preset_preflight_dialog.dart';

/// Main screen showing all labs (presets and custom)
class CustomLabsScreen extends ConsumerStatefulWidget {
  const CustomLabsScreen({super.key});

  @override
  ConsumerState<CustomLabsScreen> createState() => _CustomLabsScreenState();
}

class _CustomLabsScreenState extends ConsumerState<CustomLabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize presets on first run
    Future.microtask(() {
      ref.read(presetsInitializationProvider.notifier).checkInitialization();
      final isInitialized = ref
          .read(presetsInitializationProvider)
          .isInitialized;
      if (!isInitialized) {
        ref.read(presetsInitializationProvider.notifier).initializePresets();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final allLabsAsync = ref.watch(allLabsProvider);
    final customLabsAsync = ref.watch(customLabsProvider);

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
        children: [
          // All Labs Tab
          allLabsAsync.when(
            data: (labs) {
              if (labs.isEmpty) {
                return _buildEmptyState(
                  context,
                  l10n.noLabsYet,
                  l10n.createFirstLabMessage,
                );
              }

              // Separate presets and custom labs
              final presets = labs.where((lab) => lab.isPreset).toList();
              final customs = labs.where((lab) => !lab.isPreset).toList();

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(allLabsProvider);
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (presets.isNotEmpty) ...[
                      Text(l10n.presetLabs, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
                      _buildLabsGrid(context, presets),
                      const SizedBox(height: 24),
                    ],
                    if (customs.isNotEmpty) ...[
                      Text(
                        l10n.myCustomLabs,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _buildLabsGrid(context, customs),
                    ],
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(context, error),
          ),

          // My Labs Tab
          customLabsAsync.when(
            data: (labs) {
              if (labs.isEmpty) {
                return _buildEmptyState(
                  context,
                  l10n.noCustomLabsYet,
                  l10n.tapPlusToCreateLab,
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(customLabsProvider);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildLabsGrid(context, labs),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(context, error),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreateLabScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.newLab),
      ),
    );
  }

  Widget _buildLabsGrid(BuildContext context, List<Lab> labs) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: labs.length,
      itemBuilder: (context, index) {
        final lab = labs[index];
        return LabCard(
          lab: lab,
          onTap: () async {
            if (lab.isPreset) {
              final proceed = await showDialog<bool>(
                context: context,
                barrierDismissible: true,
                builder: (_) => PresetPreflightDialog(lab: lab),
              );
              if (proceed == true && context.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LabDetailScreen(lab: lab),
                  ),
                );
              }
            } else {
              if (!context.mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LabDetailScreen(lab: lab),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String title, String message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.science_outlined,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              l10n.errorLoadingLabs,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(allLabsProvider);
                ref.invalidate(customLabsProvider);
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
