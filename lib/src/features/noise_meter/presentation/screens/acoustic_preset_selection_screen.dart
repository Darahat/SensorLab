import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/models/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/acoustic_monitoring_screen.dart';

/// Acoustic Environment Analyzer - Preset Selection Screen
class AcousticPresetSelectionScreen extends ConsumerWidget {
  const AcousticPresetSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Acoustic Environment Analyzer'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Choose Recording Preset',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select a preset to analyze your acoustic environment over time',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Preset Cards
              Expanded(
                child: ListView(
                  children: [
                    _PresetCard(
                      preset: RecordingPreset.sleep,
                      icon: Iconsax.moon,
                      title: 'Analyze Sleep Environment',
                      duration: '8 hours',
                      description:
                          'Monitor bedroom noise throughout the night to improve sleep quality',
                      color: Colors.indigo,
                      onTap: () =>
                          _startRecording(context, RecordingPreset.sleep),
                    ),
                    const SizedBox(height: 16),
                    _PresetCard(
                      preset: RecordingPreset.work,
                      icon: Iconsax.briefcase,
                      title: 'Monitor Office Environment',
                      duration: '1 hour',
                      description:
                          'Track workplace noise levels and identify distractions',
                      color: Colors.blue,
                      onTap: () =>
                          _startRecording(context, RecordingPreset.work),
                    ),
                    const SizedBox(height: 16),
                    _PresetCard(
                      preset: RecordingPreset.focus,
                      icon: Iconsax.lamp_charge,
                      title: 'Focus Session Analysis',
                      duration: '30 minutes',
                      description:
                          'Analyze your study or focus session environment',
                      color: Colors.teal,
                      onTap: () =>
                          _startRecording(context, RecordingPreset.focus),
                    ),
                  ],
                ),
              ),

              // View History Button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/acoustic-reports');
                  },
                  icon: const Icon(Iconsax.document),
                  label: const Text('View Historical Reports'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startRecording(BuildContext context, RecordingPreset preset) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcousticMonitoringScreen(preset: preset),
      ),
    );
  }
}

class _PresetCard extends StatelessWidget {
  final RecordingPreset preset;
  final IconData icon;
  final String title;
  final String duration;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _PresetCard({
    required this.preset,
    required this.icon,
    required this.title,
    required this.duration,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Iconsax.clock, size: 14, color: color),
                        const SizedBox(width: 4),
                        Text(
                          duration,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(Iconsax.arrow_right_3, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
