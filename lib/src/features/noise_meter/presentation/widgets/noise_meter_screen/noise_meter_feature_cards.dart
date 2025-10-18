import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/acoustic_preset_selection_screen.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/acoustic_reports_list_screen.dart';

class NoiseMeterFeatureCards extends StatelessWidget {
  const NoiseMeterFeatureCards({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _EnvironmentAnalyzerCard(),
        SizedBox(height: 12),
        _ReportsCard(),
      ],
    );
  }
}

class _EnvironmentAnalyzerCard extends StatelessWidget {
  const _EnvironmentAnalyzerCard();

  @override
  Widget build(BuildContext context) {
    return _CompactFeatureCard(
      icon: Iconsax.chart_2,
      title: 'Environment Analyzer',
      subtitle: 'Preset-based acoustic analysis',
      color: Colors.blue,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AcousticPresetSelectionScreen(),
        ),
      ),
    );
  }
}

class _ReportsCard extends StatelessWidget {
  const _ReportsCard();

  @override
  Widget build(BuildContext context) {
    return _CompactFeatureCard(
      icon: Iconsax.document_text,
      title: 'Acoustic Reports',
      subtitle: 'View saved analyses and history',
      color: Colors.purple,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AcousticReportsListScreen(),
        ),
      ),
    );
  }
}

class _CompactFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CompactFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),

              // Text content - takes full available width
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow indicator
              Icon(
                Iconsax.arrow_right_3,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
