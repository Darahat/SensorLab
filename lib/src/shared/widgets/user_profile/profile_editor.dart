import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/health/domain/entities/user_profile.dart'
    as domain;
import 'package:sensorlab/src/features/health/models/health_data.dart';

class ProfileEditor extends StatefulWidget {
  final HealthData initialData;
  final Function(HealthData) onSave;

  const ProfileEditor({
    super.key,
    required this.initialData,
    required this.onSave,
  });

  @override
  State<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  late TextEditingController _nameController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _ageController;
  late TextEditingController _feetController;
  late TextEditingController _inchesController;
  late String _gender;

  @override
  void initState() {
    super.initState();
    final profile = widget.initialData.profile;

    _nameController = TextEditingController(text: profile.name);
    _weightController = TextEditingController(
      text: profile.weight.toStringAsFixed(1),
    );
    _heightController = TextEditingController(
      text: profile.height.toStringAsFixed(1),
    );
    _ageController = TextEditingController(text: profile.age.toString());

    // Convert height from cm to feet/inches
    final totalInches = profile.height / 2.54;
    final feet = (totalInches / 12).floor();
    final inches = totalInches % 12;

    _feetController = TextEditingController(text: feet.toString());
    _inchesController = TextEditingController(text: inches.toStringAsFixed(0));
    _gender = profile.gender.name;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfile)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.name),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.weightKg,
                suffixText: 'kg',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _feetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.feet),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _inchesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.inches),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.age),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _gender,
              items: [
                DropdownMenuItem(value: 'male', child: Text(l10n.male)),
                DropdownMenuItem(value: 'female', child: Text(l10n.female)),
                DropdownMenuItem(value: 'other', child: Text(l10n.other)),
              ],
              onChanged: (value) => setState(() => _gender = value ?? 'male'),
              decoration: InputDecoration(labelText: l10n.gender),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text(l10n.saveProfile),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    // Parse the form values
    final name = _nameController.text.trim();
    final weight = double.tryParse(_weightController.text) ?? 70.0;
    final age = int.tryParse(_ageController.text) ?? 30;
    final feet = double.tryParse(_feetController.text) ?? 5.0;
    final inches = double.tryParse(_inchesController.text) ?? 7.0;

    // Convert feet/inches to cm
    final heightCm = (feet * 30.48) + (inches * 2.54);

    // Convert gender string to enum
    final gender =
        _gender == 'female' ? domain.Gender.female : domain.Gender.male;

    // Create updated UserProfile
    final updatedProfile = widget.initialData.profile.copyWith(
      name: name,
      age: age,
      weight: weight,
      height: heightCm,
      gender: gender,
      updatedAt: DateTime.now(),
    );

    // Create new HealthData with updated profile
    final newData = widget.initialData.copyWith(profile: updatedProfile);

    widget.onSave(newData);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}