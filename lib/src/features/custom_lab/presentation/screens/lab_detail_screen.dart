import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_management_provider.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/recording_session_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/screens/create_lab_screen.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/screens/recording_screen.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/screens/session_history_screen.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/lab_detail_screen/lab_info_card.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/lab_detail_screen/sensor_chip_list.dart';

/// Provider to get a specific lab by ID (auto-updates when lab changes)
final labByIdProvider = FutureProvider.autoDispose.family<Lab?, String>((
  ref,
  labId,
) async {
  // Watch the allLabsProvider which contains the list of labs
  final labsAsync = await ref.watch(allLabsProvider.future);

  try {
    return labsAsync.firstWhere((lab) => lab.id == labId);
  } catch (e) {
    return null;
  }
});

/// Detail screen for a lab showing info and actions
class LabDetailScreen extends ConsumerWidget {
  final String labId; // Change to use ID instead of Lab object

  const LabDetailScreen({required this.labId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Watch the lab by ID - this will auto-update when the lab changes
    final labAsync = ref.watch(labByIdProvider(labId));

    return labAsync.when(
      data: (lab) {
        // If lab is deleted or null, go back
        if (lab == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final color = lab.colorValue != null
            ? Color(lab.colorValue!)
            : theme.colorScheme.primaryContainer;
        final sessionsAsync = ref.watch(labSessionsProvider(lab.id));

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, lab, color, l10n),
              _buildContent(context, theme, lab, sessionsAsync, l10n),
            ],
          ),
          floatingActionButton: _buildFAB(context, lab, l10n),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.labDetails ?? 'Lab Details')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text(l10n.labDetails ?? 'Lab Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    Lab lab,
    Color color,
    AppLocalizations l10n,
  ) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(lab.name),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.7)],
            ),
          ),
          child: Center(
            child: Icon(
              _getIconData(lab.iconName),
              size: 80,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ),
      actions: [
        if (!lab.isPreset)
          Consumer(
            builder: (context, ref, _) {
              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final result = await Navigator.of(context).push<Lab>(
                    MaterialPageRoute(
                      builder: (context) => CreateLabScreen(labToEdit: lab),
                    ),
                  );

                  // The provider will automatically update, no need to manually refresh
                  if (result != null) {
                    // Optionally show a snackbar or do something with the result
                  }
                },
                tooltip: l10n.editLab,
              );
            },
          ),
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SessionHistoryScreen(lab: lab),
              ),
            );
          },
          tooltip: l10n.sessionHistory,
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    Lab lab,
    AsyncValue<List<dynamic>> sessionsAsync,
    AppLocalizations l10n,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            if (lab.description.isNotEmpty) ...[
              Text(l10n.description, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(lab.description, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 24),
            ],

            // Lab info cards
            _buildInfoCards(context, lab, sessionsAsync, l10n),
            const SizedBox(height: 24),

            // Sensors list
            Text(l10n.sensors, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            SensorChipList(sensors: lab.sensors),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards(
    BuildContext context,
    Lab lab,
    AsyncValue<List<dynamic>> sessionsAsync,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: LabInfoCard(
                icon: Icons.sensors,
                label: l10n.sensors,
                value: '${lab.sensors.length}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LabInfoCard(
                icon: Icons.timer,
                label: l10n.interval,
                value:
                    '${(lab.recordingInterval / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}s',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: LabInfoCard(
                icon: Icons.calendar_today,
                label: l10n.created,
                value: _formatDate(lab.createdAt),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SessionHistoryScreen(lab: lab),
                    ),
                  );
                },
                child: sessionsAsync.when(
                  data: (sessions) => LabInfoCard(
                    icon: Icons.history,
                    label: l10n.sessions,
                    value: '${sessions.length}',
                  ),
                  loading: () => LabInfoCard(
                    icon: Icons.history,
                    label: l10n.sessions,
                    value: '...',
                  ),
                  error: (_, __) => LabInfoCard(
                    icon: Icons.history,
                    label: l10n.sessions,
                    value: '0',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFAB(BuildContext context, Lab lab, AppLocalizations l10n) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => RecordingScreen(lab: lab)),
        );
      },
      icon: const Icon(Icons.play_arrow),
      label: Text(l10n.startRecording),
    );
  }

  String _formatDate(DateTime date) {
    // Simple date formatting - you can use intl package for better formatting
    return '${date.month}/${date.day}/${date.year}';
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'environment':
        return Icons.wb_sunny;
      case 'motion':
        return Icons.directions_run;
      case 'indoor':
        return Icons.home;
      case 'outdoor':
        return Icons.terrain;
      case 'vehicle':
        return Icons.directions_car;
      case 'health':
        return Icons.favorite;
      default:
        return Icons.science;
    }
  }
}
