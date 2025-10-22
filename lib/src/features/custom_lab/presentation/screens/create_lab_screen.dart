import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_management_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/sensor_selection_grid.dart';

/// Screen for creating or editing a lab
class CreateLabScreen extends ConsumerStatefulWidget {
  final Lab? labToEdit;

  const CreateLabScreen({this.labToEdit, super.key});

  @override
  ConsumerState<CreateLabScreen> createState() => _CreateLabScreenState();
}

class _CreateLabScreenState extends ConsumerState<CreateLabScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _intervalController = TextEditingController(text: '1');

  Set<SensorType> _selectedSensors = {};
  Color _selectedColor = Colors.blue;

  bool get _isEditing => widget.labToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _nameController.text = widget.labToEdit!.name;
      _descriptionController.text = widget.labToEdit!.description;
      // Convert milliseconds to seconds for display
      final intervalInSeconds = (widget.labToEdit!.recordingInterval / 1000)
          .toStringAsFixed(1);
      _intervalController.text = intervalInSeconds.replaceAll(
        RegExp(r'\.0$'),
        '',
      );
      _selectedSensors = widget.labToEdit!.sensors.toSet();
      _selectedColor = widget.labToEdit!.colorValue != null
          ? Color(widget.labToEdit!.colorValue!)
          : Colors.blue;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final labManagementState = ref.watch(labManagementProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editLab : l10n.createLab),
        actions: [
          if (_isEditing && widget.labToEdit!.isPreset == false)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _showDeleteConfirmation,
              tooltip: l10n.deleteLab,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Lab name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.labName,
                hintText: l10n.labNameHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.science),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.pleaseEnterLabName;
                }
                return null;
              },
              enabled:
                  !labManagementState.isLoading &&
                  (!_isEditing || !widget.labToEdit!.isPreset),
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.description,
                hintText: l10n.descriptionHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.description),
              ),
              maxLines: 3,
              enabled:
                  !labManagementState.isLoading &&
                  (!_isEditing || !widget.labToEdit!.isPreset),
            ),
            const SizedBox(height: 16),

            // Recording interval
            TextFormField(
              controller: _intervalController,
              decoration: InputDecoration(
                labelText: l10n.recordingIntervalSec,
                hintText: l10n.recordingIntervalHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.timer),
                suffixText: 's',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterInterval;
                }
                final interval = double.tryParse(value);
                if (interval == null || interval < 0.1 || interval > 10) {
                  return l10n.intervalMustBeBetween;
                }
                return null;
              },
              enabled:
                  !labManagementState.isLoading &&
                  (!_isEditing || !widget.labToEdit!.isPreset),
            ),
            const SizedBox(height: 24),

            // Color selection
            Text(l10n.labColor, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            _buildColorPicker(),
            const SizedBox(height: 24),

            // Sensor selection
            Text(l10n.selectSensors, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              l10n.chooseAtLeastOneSensor,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 12),
            SensorSelectionGrid(
              selectedSensors: _selectedSensors,
              onSensorToggled: (sensor) {
                if (!labManagementState.isLoading &&
                    (!_isEditing || !widget.labToEdit!.isPreset)) {
                  setState(() {
                    if (_selectedSensors.contains(sensor)) {
                      _selectedSensors.remove(sensor);
                    } else {
                      _selectedSensors.add(sensor);
                    }
                  });
                }
              },
              enabled:
                  !labManagementState.isLoading &&
                  (!_isEditing || !widget.labToEdit!.isPreset),
            ),
            const SizedBox(height: 24),

            // Error message
            if (labManagementState.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: theme.colorScheme.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        labManagementState.errorMessage!,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Save button
            FilledButton.icon(
              onPressed:
                  labManagementState.isLoading ||
                      (_isEditing && widget.labToEdit!.isPreset)
                  ? null
                  : _saveLab,
              icon: labManagementState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(_isEditing ? Icons.save : Icons.add),
              label: Text(_isEditing ? l10n.save : l10n.createLab),
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((color) {
        final isSelected = _selectedColor.value == color.value;
        return InkWell(
          onTap: () {
            setState(() {
              _selectedColor = color;
            });
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Future<void> _saveLab() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSensors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseSelectAtLeastOneSensor),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Convert seconds to milliseconds
    final intervalInSeconds = double.parse(_intervalController.text);
    final interval = (intervalInSeconds * 1000).round();
    final labManagementNotifier = ref.read(labManagementProvider.notifier);

    Lab? result;
    if (_isEditing) {
      result = await labManagementNotifier.updateLab(
        id: widget.labToEdit!.id,
        name: _nameController.text,
        description: _descriptionController.text,
        sensors: _selectedSensors.toList(),
        color: _selectedColor,
        recordingInterval: interval,
      );
    } else {
      result = await labManagementNotifier.createLab(
        name: _nameController.text,
        description: _descriptionController.text,
        sensors: _selectedSensors.toList(),
        color: _selectedColor,
        recordingInterval: interval,
      );
    }

    if (result != null && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? l10n.labUpdatedSuccessfully
                : l10n.labCreatedSuccessfully,
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _showDeleteConfirmation() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteLab),
        content: Text(l10n.deleteLabConfirm(widget.labToEdit!.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final l10n = AppLocalizations.of(context)!;
      final labManagementNotifier = ref.read(labManagementProvider.notifier);
      final success = await labManagementNotifier.deleteLab(
        widget.labToEdit!.id,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.labDeletedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }
}
