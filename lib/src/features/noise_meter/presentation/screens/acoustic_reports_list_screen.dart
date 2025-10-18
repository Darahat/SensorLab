import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/acoustic_reports_list_controller.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/acoustic_report_detail_screen.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/index.dart';

class AcousticReportsListScreen extends ConsumerWidget {
  const AcousticReportsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(acousticReportsListProvider);
    final notifier = ref.read(acousticReportsListProvider.notifier);
    final filteredReports = state.filteredReports;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          state.isSelectionMode
              ? '${state.selectedReportIds.length} Selected'
              : 'Acoustic Reports',
        ),
        centerTitle: true,
        elevation: 0,
        leading: state.isSelectionMode
            ? IconButton(
                icon: const Icon(Iconsax.close_circle),
                onPressed: notifier.cancelSelection,
              )
            : null,
        actions: [
          if (state.isSelectionMode) ...[
            IconButton(
              icon: const Icon(Iconsax.document_download),
              onPressed: state.selectedReportIds.isNotEmpty
                  ? () => _exportReports(
                      context,
                      notifier,
                      filteredReports
                          .where((r) => state.selectedReportIds.contains(r.id))
                          .toList(),
                    )
                  : null,
              tooltip: 'Export as CSV',
            ),
            IconButton(
              icon: const Icon(Iconsax.trash),
              onPressed: state.selectedReportIds.isNotEmpty
                  ? () => _deleteSelected(context, notifier)
                  : null,
              tooltip: 'Delete Selected',
            ),
          ] else ...[
            PopupMenuButton<RecordingPreset?>(
              icon: const Icon(Iconsax.filter),
              tooltip: 'Filter by Preset',
              onSelected: notifier.setFilter,
              itemBuilder: (context) => [
                const PopupMenuItem(value: null, child: Text('All Presets')),
                const PopupMenuDivider(),
                _buildPresetMenuItem(
                  RecordingPreset.sleep,
                  'Sleep',
                  Iconsax.moon,
                ),
                _buildPresetMenuItem(
                  RecordingPreset.work,
                  'Work',
                  Iconsax.briefcase,
                ),
                _buildPresetMenuItem(
                  RecordingPreset.focus,
                  'Focus',
                  Iconsax.lamp_charge,
                ),
              ],
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : filteredReports.isEmpty
            ? _buildEmptyState(context)
            : Column(
                children: [
                  if (state.filterPreset != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: _buildFilterChip(notifier, state.filterPreset!),
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filteredReports.length,
                      itemBuilder: (context, index) {
                        final report = filteredReports[index];
                        final isSelected = state.selectedReportIds.contains(
                          report.id,
                        );
                        return _buildReportItem(
                          context,
                          notifier,
                          report,
                          isSelected,
                          state.isSelectionMode,
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: !state.isSelectionMode && filteredReports.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () =>
                  _exportReports(context, notifier, filteredReports),
              icon: const Icon(Iconsax.document_download),
              label: const Text('Export All'),
            )
          : null,
    );
  }

  PopupMenuItem<RecordingPreset> _buildPresetMenuItem(
    RecordingPreset preset,
    String text,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: preset,
      child: Row(
        children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(text)],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      icon: Iconsax.document,
      title: 'No Reports Yet',
      message:
          'Start an acoustic analysis session to generate your first report',
      action: ElevatedButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Iconsax.add_circle),
        label: const Text('Start Analysis'),
      ),
    );
  }

  Widget _buildFilterChip(
    AcousticReportsListController notifier,
    RecordingPreset preset,
  ) {
    return Chip(
      avatar: Icon(_getPresetIcon(preset), size: 18),
      label: Text(_getPresetName(preset)),
      onDeleted: () => notifier.setFilter(null),
      deleteIcon: const Icon(Iconsax.close_circle, size: 18),
    );
  }

  Widget _buildReportItem(
    BuildContext context,
    AcousticReportsListController notifier,
    AcousticReport report,
    bool isSelected,
    bool isSelectionMode,
  ) {
    return GestureDetector(
      onLongPress: () => notifier.onReportLongPress(report),
      child: Stack(
        children: [
          ReportSummaryCard(
            title: _getPresetName(report.preset),
            date: _formatDate(context, report.startTime),
            avgDecibels: report.averageDecibels,
            qualityScore: report.qualityScore.toDouble(),
            eventCount: report.events.length,
            presetName: _getPresetName(report.preset),
            onTap: () {
              if (isSelectionMode) {
                notifier.onReportTap(report);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AcousticReportDetailScreen(report: report),
                  ),
                );
              }
            },
          ),
          if (isSelectionMode)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: Icon(
                  isSelected ? Iconsax.tick_circle5 : Iconsax.record_circle,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _deleteSelected(
    BuildContext context,
    AcousticReportsListController notifier,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reports?'),
        content: const Text(
          'Are you sure you want to delete the selected report(s)? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await notifier.deleteSelected();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Reports deleted')));
      }
    }
  }

  Future<void> _exportReports(
    BuildContext context,
    AcousticReportsListController notifier,
    List<AcousticReport> reports,
  ) async {
    // Show export options dialog
    final exportOption = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Reports'),
        content: const Text('Choose how you want to export the reports:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'clipboard'),
            child: const Text('Copy to Clipboard'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, 'file'),
            icon: const Icon(Iconsax.document_download, size: 18),
            label: const Text('Save as File'),
          ),
        ],
      ),
    );

    if (exportOption == null) return;

    final csvData = notifier.exportReportsAsCSV(reports);

    if (exportOption == 'clipboard') {
      // Copy to clipboard (existing functionality)
      Clipboard.setData(ClipboardData(text: csvData));
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('CSV data copied to clipboard!'),
              backgroundColor: Colors.green,
            ),
          );
      }
    } else if (exportOption == 'file') {
      // Save to file
      await _saveCSVToFile(context, csvData, reports.length);
    }
  }

  Future<void> _saveCSVToFile(
    BuildContext context,
    String csvData,
    int reportCount,
  ) async {
    try {
      // Generate filename with timestamp
      final timestamp = DateTime.now();
      final filename =
          'acoustic_reports_${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')}_${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}.csv';

      String? savedPath;
      if (Platform.isAndroid || Platform.isIOS) {
        // Use Storage Access Framework / native saver. This opens a system dialog
        // where the user picks the folder (Downloads by default on Android).
        try {
          final params = SaveFileDialogParams(
            fileName: filename,
            data: Uint8List.fromList(csvData.codeUnits),
          );
          savedPath = await FlutterFileDialog.saveFile(params: params);
          if (savedPath == null) {
            // User cancelled
            return;
          }
        } on MissingPluginException {
          // Fallback to app documents directory if plugin channel not registered
          final dir = await getApplicationDocumentsDirectory();
          final file = File('${dir.path}/$filename');
          await file.writeAsString(csvData);
          savedPath = file.path;
        }
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$filename');
        await file.writeAsString(csvData);
        savedPath = file.path;
      }

      if (context.mounted) {
        // Show success dialog with file location
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Iconsax.tick_circle, color: Colors.green, size: 28),
                const SizedBox(width: 12),
                const Text('Export Successful'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$reportCount report(s) exported successfully!'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 68, 68, 68),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Saved to:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        savedPath ?? '',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // With Storage Access Framework-based saving, explicit storage permissions are not needed.

  // Helper methods for formatting (can be moved to an extension or kept here)
  IconData _getPresetIcon(RecordingPreset preset) {
    switch (preset) {
      case RecordingPreset.sleep:
        return Iconsax.moon;
      case RecordingPreset.work:
        return Iconsax.briefcase;
      case RecordingPreset.focus:
        return Iconsax.lamp_charge;
      case RecordingPreset.custom:
        return Iconsax.setting_2;
    }
  }

  String _getPresetName(RecordingPreset preset) {
    switch (preset) {
      case RecordingPreset.sleep:
        return 'Sleep';
      case RecordingPreset.work:
        return 'Work';
      case RecordingPreset.focus:
        return 'Focus';
      case RecordingPreset.custom:
        return 'Custom';
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDate = DateTime(date.year, date.month, date.day);

    if (sessionDate == today) {
      return 'Today at ${TimeOfDay.fromDateTime(date).format(context)}';
    } else if (sessionDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday at ${TimeOfDay.fromDateTime(date).format(context)}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
