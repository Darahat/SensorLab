import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/application/providers/custom_preset_provider.dart';
import 'package:sensorlab/src/shared/widgets/common_cards.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

/// Screen for creating custom acoustic analysis presets
class CustomPresetCreationScreen extends ConsumerWidget {
  const CustomPresetCreationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final presetState = ref.watch(customPresetProvider);
    final presetNotifier = ref.read(customPresetProvider.notifier);

    final List<IconData> availableIcons = [
      Iconsax.microphone,
      Iconsax.music,
      Iconsax.home,
      Iconsax.building,
      Iconsax.car,
      Iconsax.airplane,
      Iconsax.book,
      Iconsax.coffee,
      Iconsax.game,
      Iconsax.headphone,
    ];

    final List<Color> availableColors = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.pink,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
      Colors.cyan,
    ];

    void createPreset() {
      final customPreset = presetNotifier.createPreset();
      if (customPreset != null) {
        Navigator.pop(context, customPreset);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.durationMustBeGreaterThanZero),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    String formatDuration() {
      final hours = presetState.duration.inHours;
      final minutes = presetState.duration.inMinutes.remainder(60);

      if (hours == 0 && minutes == 0) return '0m';

      final parts = <String>[];
      if (hours > 0) parts.add('${hours}h');
      if (minutes > 0) parts.add('${minutes}m');
      return parts.join(' ');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createCustomPreset),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Preview Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        presetState.selectedColor.withOpacity(0.1),
                        presetState.selectedColor.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: presetState.selectedColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              presetState.selectedIcon,
                              color: presetState.selectedColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  presetState.title.isEmpty
                                      ? l10n.presetName
                                      : presetState.title,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatDuration(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: presetState.selectedColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (presetState.description.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          presetState.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Form Section
              const SectionHeader(title: 'Preset Details'),
              const SizedBox(height: 16),

              // Title Field
              TextFormField(
                initialValue: presetState.title,
                decoration: InputDecoration(
                  labelText: 'Preset Name *',
                  hintText: 'e.g., Study Session, Gym Workout',
                  prefixIcon: const Icon(Iconsax.edit),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                maxLength: 30,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a preset name';
                  }
                  if (value.trim().length < 3) {
                    return 'Name must be at least 3 characters';
                  }
                  return null;
                },
                onChanged: presetNotifier.updateTitle,
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                initialValue: presetState.description,
                decoration: InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Describe when to use this preset',
                  prefixIcon: const Icon(Iconsax.document_text),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
                maxLength: 100,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.trim().length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
                onChanged: presetNotifier.updateDescription,
              ),
              const SizedBox(height: 16),

              // Duration Section
              const SectionHeader(title: 'Recording Duration'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: presetState.duration.inHours.toString(),
                      decoration: InputDecoration(
                        labelText: 'Hours',
                        suffixText: 'h',
                        prefixIcon: const Icon(Iconsax.clock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      onChanged: (value) {
                        final hours = int.tryParse(value) ?? 0;
                        final minutes = presetState.duration.inMinutes
                            .remainder(60);
                        presetNotifier.updateDuration(hours, minutes);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: presetState.duration.inMinutes
                          .remainder(60)
                          .toString(),
                      decoration: InputDecoration(
                        labelText: 'Minutes',
                        suffixText: 'm',
                        prefixIcon: const Icon(Iconsax.timer_1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      onChanged: (value) {
                        final minutes = int.tryParse(value) ?? 0;
                        final hours = presetState.duration.inHours;
                        presetNotifier.updateDuration(hours, minutes);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Icon Selection
              const SectionHeader(title: 'Choose Icon'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: availableIcons.map((icon) {
                  final isSelected = presetState.selectedIcon == icon;
                  return GestureDetector(
                    onTap: () => presetNotifier.selectIcon(icon),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? presetState.selectedColor.withOpacity(0.2)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? presetState.selectedColor
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected
                            ? presetState.selectedColor
                            : Colors.grey[600],
                        size: 28,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Color Selection
              const SectionHeader(title: 'Choose Color'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: availableColors.map((color) {
                  final isSelected = presetState.selectedColor == color;
                  return GestureDetector(
                    onTap: () => presetNotifier.selectColor(color),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 28,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Create Button
              ActionButton(
                onPressed: createPreset,
                icon: Iconsax.add_circle,
                label: 'Create Preset',
                color: presetState.selectedColor,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
