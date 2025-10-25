import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
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
    final l10n = AppLocalizations.of(context)!;

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

    String? exportedFilePath;
    String? errorMessage;
    try {
      exportedFilePath = await exportNotifier.exportMultipleForSharing(
        widget.lab.id,
        _selectedSessions.toList(),
      );
    } catch (e) {
      errorMessage = e.toString();
      AppLogger.log(
        'Error during multi-session export: $e',
        level: LogLevel.error,
      );
    } finally {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close progress dialog
    }

    if (!mounted) return;
    if (exportedFilePath != null) {
      _showExportResultDialog([exportedFilePath], {}, l10n);
      _deselectAll();
    } else {
      _showExportResultDialog([], {
        'General Error': errorMessage ?? 'Unknown error occurred',
      }, l10n);
    }
  }

  Future<void> _showExportResultDialog(
    List<String> exportedFiles,
    Map<String, String> errors,
    AppLocalizations l10n,
  ) async {
    final hasSuccesses = exportedFiles.isNotEmpty;
    final hasFailures = errors.isNotEmpty;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              hasFailures && !hasSuccesses ? Icons.error : Icons.check_circle,
              color: hasFailures && !hasSuccesses ? Colors.red : Colors.green,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              hasFailures && !hasSuccesses
                  ? 'Export Failed'
                  : hasFailures
                  ? 'Partial Success'
                  : 'Export Success',
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasSuccesses) ...[
                Text(
                  'Successfully exported ${exportedFiles.length} session(s)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
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
                      const SizedBox(height: 8),
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
                          '... ${l10n.more} ${exportedFiles.length - 3}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              if (hasFailures) ...[
                if (hasSuccesses) const SizedBox(height: 16),
                Text(
                  '${l10n.failedStatus}: ${errors.length} ${l10n.sessions}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                ...errors.entries
                    .take(3)
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• ${l10n.sessions} ${entry.key.substring(0, 8)}...: ${entry.value}',
                          style: const TextStyle(fontSize: 11),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                if (errors.length > 3)
                  Text(
                    '... ${l10n.more} ${errors.length - 3}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
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
