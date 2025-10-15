import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/models/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/enhanced_noise_meter_provider.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/acoustic_report_detail_screen.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/index.dart';

/// Historical Acoustic Reports List with Multi-Select and CSV Export
class AcousticReportsListScreen extends ConsumerStatefulWidget {
  const AcousticReportsListScreen({super.key});

  @override
  ConsumerState<AcousticReportsListScreen> createState() =>
      _AcousticReportsListScreenState();
}

class _AcousticReportsListScreenState
    extends ConsumerState<AcousticReportsListScreen> {
  RecordingPreset? _filterPreset;
  final Set<String> _selectedReportIds = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    // Load saved reports
    Future.microtask(() {
      ref.read(enhancedNoiseMeterProvider.notifier).loadSavedReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(enhancedNoiseMeterProvider);
    final reports = _filterReports(state.savedReports);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          _isSelectionMode
              ? '${_selectedReportIds.length} Selected'
              : 'Acoustic Reports',
        ),
        centerTitle: true,
        elevation: 0,
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Iconsax.close_circle),
                onPressed: _cancelSelection,
              )
            : null,
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Iconsax.document_download),
              onPressed: _selectedReportIds.isNotEmpty
                  ? () => _exportSelectedAsCSV(reports)
                  : null,
              tooltip: 'Export as CSV',
            ),
            IconButton(
              icon: const Icon(Iconsax.trash),
              onPressed: _selectedReportIds.isNotEmpty ? _deleteSelected : null,
              tooltip: 'Delete Selected',
            ),
          ] else ...[
            PopupMenuButton<RecordingPreset?>(
              icon: const Icon(Iconsax.filter),
              tooltip: 'Filter by Preset',
              onSelected: (preset) {
                setState(() {
                  _filterPreset = preset;
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: null, child: Text('All Presets')),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: RecordingPreset.sleep,
                  child: Row(
                    children: [
                      Icon(Iconsax.moon, size: 18),
                      const SizedBox(width: 8),
                      Text('Sleep'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: RecordingPreset.work,
                  child: Row(
                    children: [
                      Icon(Iconsax.briefcase, size: 18),
                      const SizedBox(width: 8),
                      Text('Work'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: RecordingPreset.focus,
                  child: Row(
                    children: [
                      Icon(Iconsax.lamp_charge, size: 18),
                      const SizedBox(width: 8),
                      Text('Focus'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: reports.isEmpty
            ? EmptyStateWidget(
                icon: Iconsax.document,
                title: 'No Reports Yet',
                message:
                    'Start an acoustic analysis session to generate your first report',
                action: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Iconsax.add_circle),
                  label: const Text('Start Analysis'),
                ),
              )
            : Column(
                children: [
                  if (_filterPreset != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildFilterChip(),
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        final isSelected = _selectedReportIds.contains(
                          report.id,
                        );

                        // Use ReportSummaryCard widget
                        return GestureDetector(
                          onLongPress: () => _onReportLongPress(report),
                          child: Stack(
                            children: [
                              ReportSummaryCard(
                                title: _getPresetName(report.preset),
                                date: _formatDate(report.startTime),
                                avgDecibels: report.averageDecibels,
                                qualityScore: report.qualityScore.toDouble(),
                                eventCount: report.events.length,
                                presetName: _getPresetName(report.preset),
                                onTap: () => _onReportTap(report),
                              ),
                              if (_isSelectionMode)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Colors.grey.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      isSelected
                                          ? Iconsax.tick_circle5
                                          : Iconsax.record_circle,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: !_isSelectionMode && reports.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _exportAllAsCSV(reports),
              icon: const Icon(Iconsax.document_download),
              label: const Text('Export All'),
            )
          : null,
    );
  }

  Widget _buildFilterChip() {
    return Chip(
      avatar: Icon(_getPresetIcon(_filterPreset!), size: 18),
      label: Text(_getPresetName(_filterPreset!)),
      onDeleted: () {
        setState(() {
          _filterPreset = null;
        });
      },
      deleteIcon: const Icon(Iconsax.close_circle, size: 18),
    );
  }

  void _onReportTap(AcousticReport report) {
    if (_isSelectionMode) {
      setState(() {
        if (_selectedReportIds.contains(report.id)) {
          _selectedReportIds.remove(report.id);
          if (_selectedReportIds.isEmpty) {
            _isSelectionMode = false;
          }
        } else {
          _selectedReportIds.add(report.id);
        }
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AcousticReportDetailScreen(report: report),
        ),
      );
    }
  }

  void _onReportLongPress(AcousticReport report) {
    if (!_isSelectionMode) {
      setState(() {
        _isSelectionMode = true;
        _selectedReportIds.add(report.id);
      });
    }
  }

  void _cancelSelection() {
    setState(() {
      _isSelectionMode = false;
      _selectedReportIds.clear();
    });
  }

  void _deleteSelected() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reports?'),
        content: Text(
          'Are you sure you want to delete ${_selectedReportIds.length} report(s)? This action cannot be undone.',
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
      for (final id in _selectedReportIds) {
        await ref.read(enhancedNoiseMeterProvider.notifier).deleteReport(id);
      }
      _cancelSelection();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Reports deleted')));
      }
    }
  }

  void _exportSelectedAsCSV(List<AcousticReport> allReports) {
    final selectedReports = allReports
        .where((r) => _selectedReportIds.contains(r.id))
        .toList();
    _exportReportsAsCSV(selectedReports);
  }

  void _exportAllAsCSV(List<AcousticReport> reports) {
    _exportReportsAsCSV(reports);
  }

  void _exportReportsAsCSV(List<AcousticReport> reports) {
    if (reports.isEmpty) return;

    // CSV Header
    final csv = StringBuffer();
    csv.writeln(
      'ID,Start Time,End Time,Duration (min),Preset,Average dB,Min dB,Max dB,Events,Quality Score,Quality,Recommendation',
    );

    // CSV Rows
    for (final report in reports) {
      csv.writeln(
        '${report.id},'
        '${report.startTime.toIso8601String()},'
        '${report.endTime.toIso8601String()},'
        '${report.duration.inMinutes},'
        '${report.preset.name},'
        '${report.averageDecibels.toStringAsFixed(1)},'
        '${report.minDecibels.toStringAsFixed(1)},'
        '${report.maxDecibels.toStringAsFixed(1)},'
        '${report.interruptionCount},'
        '${report.qualityScore},'
        '${report.environmentQuality},'
        '"${report.recommendation.replaceAll('"', '""')}"',
      );
    }

    // Copy CSV to clipboard
    Clipboard.setData(ClipboardData(text: csv.toString()));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('CSV data copied to clipboard!'),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
      ),
    );
  }

  List<AcousticReport> _filterReports(List<AcousticReport> reports) {
    if (_filterPreset == null) return reports;
    return reports.where((r) => r.preset == _filterPreset).toList();
  }

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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDate = DateTime(date.year, date.month, date.day);

    if (sessionDate == today) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (sessionDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}
