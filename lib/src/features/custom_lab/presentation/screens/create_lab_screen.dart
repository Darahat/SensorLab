import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_management_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/notifiers/create_lab_notifier.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/create_lab_screen/color_picker_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/create_lab_screen/sensor_selection_grid.dart';

/// Screen for creating or editing a lab
class CreateLabScreen extends ConsumerStatefulWidget {
  final Lab? labToEdit;

  const CreateLabScreen({this.labToEdit, super.key});

  @override
  ConsumerState<CreateLabScreen> createState() => _CreateLabScreenState();
}

class _CreateLabScreenState extends ConsumerState<CreateLabScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _intervalController = TextEditingController();

  bool get isEditing => widget.labToEdit != null;

  @override
  void initState() {
    super.initState();

    // Initialize form with existing lab data if editing
    if (isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final lab = widget.labToEdit!;
        ref.read(createLabNotifierProvider.notifier).initializeForEdit(lab);

        _nameController.text = lab.name;
        _descriptionController.text = lab.description;
        _intervalController.text = (lab.recordingInterval / 1000)
            .toStringAsFixed(1)
            .replaceAll(RegExp(r'\.0$'), '');
      });
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(createLabNotifierProvider);
    final isPreset = widget.labToEdit?.isPreset == true;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editLab : l10n.createLab),
        actions: [
          if (isEditing && !isPreset)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: state.isLoading ? null : _showDeleteConfirmation,
              tooltip: l10n.deleteLab,
            ),
        ],
      ),
      body: _buildBody(context, state, isPreset),
    );
  }

  Widget _buildBody(BuildContext context, CreateLabState state, bool isPreset) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNameField(context, isPreset),
        const SizedBox(height: 16),
        _buildDescriptionField(context, isPreset),
        const SizedBox(height: 16),
        _buildIntervalField(context, isPreset),
        const SizedBox(height: 24),
        _buildColorSection(context, state, isPreset),
        const SizedBox(height: 24),
        _buildSensorSection(context, isPreset),
        const SizedBox(height: 24),
        if (state.errorMessage != null) ...[
          _buildErrorMessage(context, state.errorMessage!),
          const SizedBox(height: 24),
        ],
        _buildSaveButton(context, state, isPreset),
      ],
    );
  }

  Widget _buildNameField(BuildContext context, bool isPreset) {
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: l10n.labName,
        hintText: l10n.labNameHint,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.science),
      ),
      onChanged: (value) {
        ref.read(createLabNotifierProvider.notifier).updateName(value);
      },
      enabled: !isPreset,
    );
  }

  Widget _buildDescriptionField(BuildContext context, bool isPreset) {
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: l10n.description,
        hintText: l10n.descriptionHint,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.description),
      ),
      maxLines: 3,
      onChanged: (value) {
        ref.read(createLabNotifierProvider.notifier).updateDescription(value);
      },
      enabled: !isPreset,
    );
  }

  Widget _buildIntervalField(BuildContext context, bool isPreset) {
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      controller: _intervalController,
      decoration: InputDecoration(
        labelText: l10n.recordingIntervalSec,
        hintText: l10n.recordingIntervalHint,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.timer),
        suffixText: 's',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        ref.read(createLabNotifierProvider.notifier).updateInterval(value);
      },
      enabled: !isPreset,
    );
  }

  Widget _buildColorSection(
    BuildContext context,
    CreateLabState state,
    bool isPreset,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.labColor, style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        ColorPickerWidget(
          selectedColor: state.selectedColor,
          onColorSelected: (color) {
            ref.read(createLabNotifierProvider.notifier).updateColor(color);
          },
          enabled: !isPreset,
        ),
      ],
    );
  }

  Widget _buildSensorSection(BuildContext context, bool isPreset) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.selectSensors, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          l10n.chooseAtLeastOneSensor,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),
        SensorSelectionGrid(enabled: !isPreset),
      ],
    );
  }

  Widget _buildErrorMessage(BuildContext context, String message) {
    final theme = Theme.of(context);

    return Container(
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
              message,
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    CreateLabState state,
    bool isPreset,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return FilledButton.icon(
      onPressed: (state.isLoading || isPreset) ? null : _saveLab,
      icon: state.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(isEditing ? Icons.save : Icons.add),
      label: Text(isEditing ? l10n.save : l10n.createLab),
      style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
    );
  }

  Future<void> _saveLab() async {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(createLabNotifierProvider.notifier);
    final state = ref.read(createLabNotifierProvider);

    // Validate
    final error = notifier.validate();
    if (error != null) {
      notifier.setError(error);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    notifier.setLoading(true);
    notifier.setError(null);

    try {
      final labManagement = ref.read(labManagementProvider.notifier);
      Lab? result;

      if (isEditing) {
        result = await labManagement.updateLab(
          id: widget.labToEdit!.id,
          name: state.name,
          description: state.description,
          sensors: state.selectedSensors.toList(),
          color: state.selectedColor,
          recordingInterval: notifier.getRecordingInterval(),
        );
      } else {
        result = await labManagement.createLab(
          name: state.name,
          description: state.description,
          sensors: state.selectedSensors.toList(),
          color: state.selectedColor,
          recordingInterval: notifier.getRecordingInterval(),
        );
      }

      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? l10n.labUpdatedSuccessfully
                  : l10n.labCreatedSuccessfully,
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh the lab list and invalidate related providers
        ref.invalidate(labManagementProvider);

        Navigator.of(context).pop(result); // Return the updated lab
      }
    } catch (e) {
      notifier.setError(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      notifier.setLoading(false);
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
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final notifier = ref.read(createLabNotifierProvider.notifier);
      notifier.setLoading(true);

      final success = await ref
          .read(labManagementProvider.notifier)
          .deleteLab(widget.labToEdit!.id);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.labDeletedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh the lab list
        ref.invalidate(labManagementProvider);

        Navigator.of(context).pop();
      }
    }
  }
}
