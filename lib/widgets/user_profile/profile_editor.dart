import 'package:flutter/material.dart';
import 'package:sensorlab/models/health_data.dart';

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
    _nameController = TextEditingController(text: widget.initialData.name);
    _weightController = TextEditingController(
      text: widget.initialData.weightKg.toStringAsFixed(1),
    );
    _heightController = TextEditingController(
      text: widget.initialData.heightCm.toStringAsFixed(1),
    );
    _ageController = TextEditingController(
      text: widget.initialData.age.toString(),
    );

    _feetController = TextEditingController(
      text: widget.initialData.heightFeet.toStringAsFixed(0),
    );
    _inchesController = TextEditingController(
      text: widget.initialData.heightInches.toStringAsFixed(0),
    );
    _gender = widget.initialData.gender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
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
                    decoration: const InputDecoration(labelText: 'Feet'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _inchesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Inches'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _gender,
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Male')),
                DropdownMenuItem(value: 'female', child: Text('Female')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (value) => setState(() => _gender = value ?? 'male'),
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    final newData = widget.initialData.copyWith(
      name: _nameController.text,
      weightKg: double.tryParse(_weightController.text),
      heightFeet: double.tryParse(_feetController.text),
      heightInches: double.tryParse(_inchesController.text),
      age: int.tryParse(_ageController.text),
      gender: _gender,
    );
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
