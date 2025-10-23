import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/export_provider.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/recording_session_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/screens/session_detail_screen.dart';

/// Screen showing session history for a lab
class SessionHistoryScreen extends ConsumerStatefulWidget {
  final Lab lab;

  const SessionHistoryScreen({required this.lab, super.key});

  @override
  ConsumerState<SessionHistoryScreen> createState() =>
      _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends ConsumerState<SessionHistoryScreen> {
  final Set<String> _selectedSessions = {};
  bool _isSelectionMode = false;

  void _toggleSelection(String sessionId) {
    setState(() {
      if (_selectedSessions.contains(sessionId)) {
        _selectedSessions.remove(sessionId);
        if (_selectedSessions.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedSessions.add(sessionId);
        _isSelectionMode = true;
      }
    });
  }

  void _selectAll(List<LabSession> sessions) {
    setState(() {
      _selectedSessions.addAll(sessions.map((s) => s.id));
      _isSelectionMode = true;
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedSessions.clear();
      _isSelectionMode = false;
    });
  }

  Future<void> _exportSelected() async {
    if (_selectedSessions.isEmpty) return;

    final exportNotifier = ref.read(exportProvider.notifier);

    // Show progress dialog
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Exporting ${_selectedSessions.length} session(s)...'),
          ],
        ),
      ),
    );

    final exportedFiles = <String>[];
    final errors = <String>[];

    try {
      for (final sessionId in _selectedSessions) {
        try {
          final filePath = await exportNotifier.exportForSharing(sessionId);
          if (filePath != null) {
            exportedFiles.add(filePath);
          }
        } catch (e) {
          errors.add('Session $sessionId: ${e.toString()}');
        }
      }

      if (!mounted) return;
      Navigator.of(context).pop(); // Close progress dialog

      if (exportedFiles.isNotEmpty) {
        // Show success dialog with file locations
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 12),
                Text('Export Success'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exported ${exportedFiles.length} session(s) successfully',
                  ),
                  if (errors.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Failed: ${errors.length} session(s)',
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ],
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
                          'Files saved to:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...exportedFiles
                            .take(3)
                            .map(
                              (path) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  path,
                                  style: const TextStyle(fontSize: 11),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                        if (exportedFiles.length > 3)
                          Text(
                            '... and ${exportedFiles.length - 3} more',
                            style: const TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );

        if (!mounted) return;
        _deselectAll();
      } else {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 28),
                SizedBox(width: 12),
                Text('Export Failed'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Failed to export sessions.'),
                if (errors.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Errors:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...errors.map(
                    (err) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '• $err',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
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
      if (!mounted) return;
      Navigator.of(context).pop(); // Close progress dialog

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 28),
              SizedBox(width: 12),
              Text('Export Error'),
            ],
          ),
          content: Text('An error occurred: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final sessionsAsync = ref.watch(labSessionsProvider(widget.lab.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isSelectionMode
              ? '${_selectedSessions.length} selected'
              : l10n.sessionHistory,
        ),
        leading: _isSelectionMode
            ? IconButton(icon: const Icon(Icons.close), onPressed: _deselectAll)
            : null,
        actions: _isSelectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () {
                    sessionsAsync.whenData((sessions) => _selectAll(sessions));
                  },
                  tooltip: 'Select All',
                ),
                IconButton(
                  icon: const Icon(Icons.file_download),
                  onPressed: _exportSelected,
                  tooltip: 'Export Selected',
                ),
              ]
            : null,
      ),
      body: sessionsAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noRecordingSessionsYet,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.startRecordingToCreateSession,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          // Sort sessions by start time (newest first)
          final sortedSessions = sessions.toList()
            ..sort((a, b) => b.startTime.compareTo(a.startTime));

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(labSessionsProvider(widget.lab.id));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedSessions.length,
              itemBuilder: (context, index) {
                final session = sortedSessions[index];
                final isSelected = _selectedSessions.contains(session.id);

                return SessionCard(
                  session: session,
                  isSelected: isSelected,
                  isSelectionMode: _isSelectionMode,
                  onTap: () {
                    if (_isSelectionMode) {
                      _toggleSelection(session.id);
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              SessionDetailScreen(session: session),
                        ),
                      );
                    }
                  },
                  onLongPress: () {
                    _toggleSelection(session.id);
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.errorLoadingSessions,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card widget for displaying a session
class SessionCard extends ConsumerWidget {
  final LabSession session;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final bool isSelectionMode;

  const SessionCard({
    required this.session,
    required this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.isSelectionMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isExportedAsync = ref.watch(isSessionExportedProvider(session.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isSelected
          ? theme.colorScheme.primaryContainer.withOpacity(0.5)
          : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (isSelectionMode) ...[
                Checkbox(value: isSelected, onChanged: (_) => onTap()),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status and date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatusChip(theme),
                        Text(
                          DateFormat(
                            'MMM d, y • HH:mm',
                          ).format(session.startTime),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Stats
                    Row(
                      children: [
                        _buildStatItem(
                          theme,
                          Icons.timer,
                          _formatDuration(session.duration),
                        ),
                        const SizedBox(width: 16),
                        _buildStatItem(
                          theme,
                          Icons.show_chart,
                          '${session.dataPointsCount} points',
                        ),
                        const SizedBox(width: 16),
                        _buildStatItem(
                          theme,
                          Icons.sensors,
                          '${session.sensorTypes.length} sensors',
                        ),
                      ],
                    ),

                    // Export status
                    isExportedAsync.when(
                      data: (isExported) {
                        if (isExported) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Exported',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),

                    // Notes preview
                    if (session.notes != null && session.notes!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        session.notes!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    Color color;
    IconData icon;
    String label;

    switch (session.status) {
      case RecordingStatus.completed:
        color = Colors.green;
        icon = Icons.check_circle;
        label = 'Completed';
        break;
      case RecordingStatus.recording:
        color = Colors.red;
        icon = Icons.fiber_manual_record;
        label = 'Recording';
        break;
      case RecordingStatus.paused:
        color = Colors.orange;
        icon = Icons.pause;
        label = 'Paused';
        break;
      case RecordingStatus.failed:
        color = Colors.red.shade900;
        icon = Icons.error;
        label = 'Failed';
        break;
      case RecordingStatus.idle:
        color = Colors.grey;
        icon = Icons.circle;
        label = 'Idle';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 4),
        Text(text, style: theme.textTheme.bodySmall),
      ],
    );
  }

  String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}
