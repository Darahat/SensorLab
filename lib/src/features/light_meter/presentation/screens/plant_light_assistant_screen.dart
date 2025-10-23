import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
// Removed unused l10n import
import 'package:sensorlab/src/features/light_meter/models/plant_light_data.dart';
import 'package:sensorlab/src/features/light_meter/presentation/providers/light_meter_provider.dart';
import 'package:sensorlab/src/shared/widgets/common_cards.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

/// Plant Light Assistant - Helps optimize light conditions for plants
class PlantLightAssistantScreen extends ConsumerStatefulWidget {
  const PlantLightAssistantScreen({super.key});

  @override
  ConsumerState<PlantLightAssistantScreen> createState() =>
      _PlantLightAssistantScreenState();
}

class _PlantLightAssistantScreenState
    extends ConsumerState<PlantLightAssistantScreen> {
  PlantType? _selectedPlantType;
  bool _isTracking = false;

  @override
  void dispose() {
    // Stop tracking when leaving screen
    if (_isTracking) {
      ref.read(lightMeterProvider.notifier).stopPlantTracking();
    }
    super.dispose();
  }

  void _startTracking() {
    if (_selectedPlantType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a plant type first')),
      );
      return;
    }

    setState(() => _isTracking = true);
    ref
        .read(lightMeterProvider.notifier)
        .startPlantTracking(_selectedPlantType!);
  }

  void _stopTracking() {
    setState(() => _isTracking = false);
    ref.read(lightMeterProvider.notifier).stopPlantTracking();
  }

  void _resetTracking() {
    ref.read(lightMeterProvider.notifier).resetPlantTracking();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Removed unused local l10n to satisfy analyzer
    final lightState = ref.watch(lightMeterProvider);
    final notifier = ref.read(lightMeterProvider.notifier);
    final plantData = notifier.plantTrackingData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Light Assistant'),
        centerTitle: true,
        actions: [
          if (_isTracking)
            IconButton(
              icon: const Icon(Iconsax.refresh),
              onPressed: _resetTracking,
              tooltip: 'Reset Tracking',
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Card
              StatusCard(
                isActive: _isTracking,
                title: _isTracking ? 'Tracking Active' : 'Not Tracking',
                subtitle: _isTracking
                    ? 'Accumulating daily light exposure'
                    : 'Select a plant to start tracking',
                activeColor: Colors.green,
              ),
              const SizedBox(height: 24),

              // Plant Type Selector
              _buildPlantSelector(theme),
              const SizedBox(height: 24),

              // Show data if plant is selected
              if (_selectedPlantType != null) ...[
                // Current Light Level
                _buildCurrentLightCard(theme, lightState),
                const SizedBox(height: 24),

                // DLI Progress
                if (plantData != null) ...[
                  _buildDLIProgressCard(theme, plantData),
                  const SizedBox(height: 24),

                  // Statistics Row
                  _buildStatisticsRow(theme, plantData, lightState),
                  const SizedBox(height: 24),

                  // Recommendations
                  _buildRecommendationsCard(theme, notifier),
                  const SizedBox(height: 24),
                ],

                // Control Button
                _buildControlButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlantSelector(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Iconsax.tree,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Select Plant Type',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PlantType>(
              value: _selectedPlantType,
              decoration: InputDecoration(
                hintText: 'Choose your plant',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
              items: PlantType.values.map((type) {
                final plantData = PlantDatabase.getPlantInfo(type);
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Text(
                        _getPlantIcon(type),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              plantData.name,
                              style: theme.textTheme.bodyLarge,
                            ),
                            Text(
                              'DLI: ${plantData.targetDLI} mol/m²/day',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: _isTracking
                  ? null
                  : (value) {
                      setState(() => _selectedPlantType = value);
                    },
            ),
            if (_selectedPlantType != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.info_circle,
                      size: 16,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        PlantDatabase.getPlantInfo(
                          _selectedPlantType!,
                        ).requirementText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLightCard(ThemeData theme, state) {
    final ppfd = state.currentLux / 54.0;
    final color = _getLightLevelColor(state.currentLux);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
        ),
        child: Column(
          children: [
            Text(
              'Current Light Level',
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  state.currentLux.toStringAsFixed(0),
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12, left: 8),
                  child: Text(
                    'lux',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '≈ ${ppfd.toStringAsFixed(1)} μmol/m²/s PPFD',
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDLIProgressCard(ThemeData theme, PlantLightData plantData) {
    final progress = plantData.progressPercentage / 100;
    final color = _getProgressColor(plantData.progressPercentage);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Daily Light Integral (DLI)',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // Circular Progress
            SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 16,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        plantData.currentDLI.toStringAsFixed(2),
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        'of ${plantData.targetDLI}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'mol/m²/day',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            BadgeWidget(
              label: plantData.status,
              color: color,
              icon: _getStatusIcon(plantData.status),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsRow(ThemeData theme, PlantLightData plantData, state) {
    final duration = DateTime.now().difference(plantData.trackingStartTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Iconsax.timer_1,
            label: 'Tracking Time',
            value: '${hours}h ${minutes}m',
            color: Colors.purple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Iconsax.chart_21,
            label: 'Readings',
            value: '${plantData.readings.length}',
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsCard(ThemeData theme, notifier) {
    final recommendations = notifier.getPlantRecommendations();

    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Iconsax.lamp_on,
                    color: Colors.amber,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Recommendations',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recommendations.map(
              (rec) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(rec, style: theme.textTheme.bodyMedium),
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

  Widget _buildControlButton() {
    return SizedBox(
      width: double.infinity,
      child: _isTracking
          ? ActionButton(
              icon: Iconsax.stop,
              label: 'Stop Tracking',
              onPressed: _stopTracking,
              color: Colors.red,
            )
          : ActionButton(
              icon: Iconsax.play,
              label: 'Start Tracking',
              onPressed: _startTracking,
              color: Colors.green,
            ),
    );
  }

  String _getPlantIcon(PlantType type) {
    switch (type) {
      case PlantType.snake:
        return '🌿';
      case PlantType.fern:
        return '🍀';
      case PlantType.orchid:
        return '🌸';
      case PlantType.cactus:
        return '🌵';
      case PlantType.tomato:
        return '🍅';
      case PlantType.lettuce:
        return '🥬';
      case PlantType.pothos:
        return '�';
      case PlantType.basil:
        return '🌿';
      case PlantType.spider:
        return '🕷️';
      case PlantType.fiddle:
        return '🎻';
      case PlantType.peace:
        return '☮️';
      case PlantType.monstera:
        return '🍃';
      case PlantType.rubber:
        return '🌳';
      case PlantType.succulent:
        return '🌿';
      case PlantType.croton:
        return '🌺';
      case PlantType.custom:
        return '🪴';
    }
  }

  Color _getLightLevelColor(double lux) {
    if (lux < 200) return Colors.blue;
    if (lux < 1000) return Colors.green;
    if (lux < 10000) return Colors.orange;
    return Colors.amber;
  }

  Color _getProgressColor(double percentage) {
    if (percentage < 50) return Colors.red;
    if (percentage < 80) return Colors.orange;
    if (percentage < 100) return Colors.blue;
    return Colors.green;
  }

  IconData _getStatusIcon(String status) {
    if (status.contains('Dark')) return Iconsax.moon;
    if (status.contains('Optimal')) return Iconsax.tick_circle;
    if (status.contains('Excess')) return Iconsax.warning_2;
    return Iconsax.sun_1;
  }
}
