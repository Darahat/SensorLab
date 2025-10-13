import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/app_settings/presentation/widgets/settings_item.dart';
import 'package:sensorlab/src/features/app_settings/presentation/widgets/settings_section.dart';
import 'package:sensorlab/src/features/health/domain/entities/user_profile.dart'
    as domain;
import 'package:sensorlab/src/features/health/providers/health_provider.dart';

class ProfileEditor extends ConsumerStatefulWidget {
  final domain.UserProfile profile;

  const ProfileEditor({super.key, required this.profile});

  static Future<void> show(BuildContext context, domain.UserProfile profile) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileEditor(profile: profile),
    );
  }

  @override
  ConsumerState<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends ConsumerState<ProfileEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late domain.Gender _gender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _ageController = TextEditingController(text: widget.profile.age.toString());
    _weightController = TextEditingController(
      text: widget.profile.weight.toString(),
    );
    _heightController = TextEditingController(
      text: widget.profile.height.toString(),
    );
    _gender = widget.profile.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Iconsax.profile_2user,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.editProfile,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            l10n.updateYourPersonalInformation,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Personal Information Section
                        SettingsSection(
                          title: l10n.personalInformation,
                          icon: Iconsax.user,
                          children: [
                            _buildNameField(l10n),
                            const SizedBox(height: 8),
                            _buildAgeField(l10n),
                            const SizedBox(height: 8),
                            _buildGenderField(l10n, colorScheme),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Physical Measurements Section
                        SettingsSection(
                          title: l10n.physicalMeasurements,
                          icon: Iconsax.ruler,
                          children: [
                            _buildWeightField(l10n),
                            const SizedBox(height: 8),
                            _buildHeightField(l10n),
                          ],
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              // Action Buttons
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outline.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.saveProfile,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final newProfile = widget.profile.copyWith(
        name: _nameController.text,
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        gender: _gender,
      );
      ref.read(healthProvider.notifier).updateProfile(newProfile);
      Navigator.of(context).pop();
    }
  }

  Widget _buildNameField(AppLocalizations l10n) {
    return SettingsItem(
      icon: Iconsax.user,
      title: l10n.name,
      subtitle: l10n.enterYourFullName,
      trailing: SizedBox(
        width: 150,
        child: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: l10n.name,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.pleaseEnterYourName;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildAgeField(AppLocalizations l10n) {
    return SettingsItem(
      icon: Iconsax.cake,
      title: l10n.age,
      subtitle: l10n.enterYourAge,
      trailing: SizedBox(
        width: 80,
        child: TextFormField(
          controller: _ageController,
          decoration: InputDecoration(
            hintText: l10n.age,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.pleaseEnterYourAge;
            }
            if (int.tryParse(value) == null) {
              return l10n.pleaseEnterValidNumber;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildGenderField(AppLocalizations l10n, ColorScheme colorScheme) {
    return SettingsItem(
      icon: Iconsax.people,
      title: l10n.gender,
      subtitle: l10n.selectYourGender,
      trailing: DropdownButton<domain.Gender>(
        value: _gender,
        underline: const SizedBox(),
        items: domain.Gender.values.map((gender) {
          String genderText;
          switch (gender) {
            case domain.Gender.male:
              genderText = l10n.male;
              break;
            case domain.Gender.female:
              genderText = l10n.female;
              break;
          }
          return DropdownMenuItem(value: gender, child: Text(genderText));
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _gender = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildWeightField(AppLocalizations l10n) {
    return SettingsItem(
      icon: Iconsax.weight_1,
      title: l10n.weight,
      subtitle: l10n.enterYourWeightInKg,
      trailing: SizedBox(
        width: 120,
        child: TextFormField(
          controller: _weightController,
          decoration: InputDecoration(
            hintText: 'kg',
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.pleaseEnterYourWeight;
            }
            if (double.tryParse(value) == null) {
              return l10n.pleaseEnterValidNumber;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildHeightField(AppLocalizations l10n) {
    return SettingsItem(
      icon: Iconsax.ruler,
      title: l10n.height,
      subtitle: l10n.enterYourHeightInCm,
      trailing: SizedBox(
        width: 120,
        child: TextFormField(
          controller: _heightController,
          decoration: InputDecoration(
            hintText: 'cm',
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.pleaseEnterYourHeight;
            }
            if (double.tryParse(value) == null) {
              return l10n.pleaseEnterValidNumber;
            }
            return null;
          },
        ),
      ),
    );
  }
}
