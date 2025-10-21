import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/recording_session_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/screens/create_lab_screen.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/screens/recording_screen.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/screens/session_history_screen.dart';

/// Detail screen for a lab showing info and actions
class LabDetailScreen extends ConsumerWidget {
  final Lab lab;

  const LabDetailScreen({required this.lab, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final color = lab.colorValue != null
        ? Color(lab.colorValue!)
        : theme.colorScheme.primaryContainer;
    final sessionsAsync = ref.watch(labSessionsProvider(lab.id));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with gradient
          SliverAppBar(
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
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreateLabScreen(labToEdit: lab),
                      ),
                    );
                  },
                  tooltip: l10n.editLab,
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
          ),

          // Content
          SliverToBoxAdapter(
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
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.sensors,
                          label: l10n.sensors,
                          value: '${lab.sensors.length}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.timer,
                          label: l10n.interval,
                          value: '${lab.recordingInterval}ms',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.calendar_today,
                          label: l10n.created,
                          value: DateFormat('MMM d, y').format(lab.createdAt),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: sessionsAsync.when(
                          data: (sessions) => _InfoCard(
                            icon: Icons.history,
                            label: l10n.sessions,
                            value: '${sessions.length}',
                          ),
                          loading: () => _InfoCard(
                            icon: Icons.history,
                            label: l10n.sessions,
                            value: '...',
                          ),
                          error: (_, __) => _InfoCard(
                            icon: Icons.history,
                            label: l10n.sessions,
                            value: '0',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sensors list
                  Text(l10n.sensors, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: lab.sensors.map((sensor) {
                      return Chip(
                        avatar: Icon(_getSensorIcon(sensor.name), size: 18),
                        label: Text(
                          sensor.name.replaceAll('_', ' ').toUpperCase(),
                          style: theme.textTheme.bodySmall,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => RecordingScreen(lab: lab)),
          );
        },
        icon: const Icon(Icons.play_arrow),
        label: Text(l10n.startRecording),
      ),
    );
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

  IconData _getSensorIcon(String sensorName) {
    switch (sensorName.toLowerCase()) {
      case 'accelerometer':
        return Icons.speed;
      case 'gyroscope':
        return Icons.screen_rotation;
      case 'magnetometer':
        return Icons.explore;
      case 'barometer':
        return Icons.compress;
      case 'lightmeter':
        return Icons.light_mode;
      case 'noisemeter':
        return Icons.volume_up;
      case 'gps':
        return Icons.location_on;
      case 'proximity':
        return Icons.phonelink_ring;
      case 'temperature':
        return Icons.thermostat;
      case 'humidity':
        return Icons.water_drop;
      case 'pedometer':
        return Icons.directions_walk;
      case 'compass':
        return Icons.compass_calibration;
      case 'altimeter':
        return Icons.terrain;
      case 'speedmeter':
        return Icons.speed;
      case 'heartbeat':
        return Icons.favorite;
      default:
        return Icons.sensors;
    }
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
