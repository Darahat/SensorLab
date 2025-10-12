import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/scan_result.dart';
import 'scanner_main_screen.dart';

class ScanResultScreen extends StatelessWidget {
  final ScanResult result;

  const ScanResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Builder(builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return Scaffold(
        appBar: AppBar(
          title: Text('${result.scanType.displayName} ${l10n.scanResult}'),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.copy),
              onPressed: () => _copyToClipboard(context, l10n),
            ),
            IconButton(
              icon: const Icon(Iconsax.share),
              onPressed: () => _shareResult(context, l10n),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card
              _buildHeaderCard(colorScheme, l10n),
              const SizedBox(height: 24),

              // Content card
              _buildContentCard(colorScheme, l10n),
              const SizedBox(height: 24),

              // Actions card (if actionable)
              if (result.isActionable) ...[
                _buildActionsCard(colorScheme, context, l10n),
                const SizedBox(height: 24),
              ],

              // Technical details card
              _buildTechnicalCard(colorScheme, l10n),
              const SizedBox(height: 32),

              // Action buttons
              _buildActionButtons(context, colorScheme, l10n),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeaderCard(ColorScheme colorScheme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                result.scanType.icon,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.scanType.displayName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.contentType.displayName,
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.scannedOn(result.formattedTimestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Text(result.contentType.icon, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(ColorScheme colorScheme, AppLocalizations l10n) {
    final parsedContent = result.parsedContent;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.document_text,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.content,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (parsedContent.length == 1 &&
                parsedContent.containsKey('content'))
              // Simple content display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: SelectableText(
                  result.rawData,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                ),
              )
            else
              // Structured content display
              Column(
                children:
                    parsedContent.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildContentRow(
                          entry.key,
                          entry.value,
                          colorScheme,
                        ),
                      );
                    }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentRow(String label, String value, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              value,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsCard(ColorScheme colorScheme, BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.flash_circle,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.quickActions,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: _getActionIcon(),
                label: Text(result.actionLabel),
                onPressed: () => _performAction(context, l10n),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalCard(ColorScheme colorScheme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.cpu, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.technicalDetails,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildDetailRow(l10n.format, result.format.name, colorScheme),
            if (result.formatDetails != null)
              _buildDetailRow(
                l10n.description,
                result.formatDetails!,
                colorScheme,
              ),
            _buildDetailRow(
              l10n.dataLength,
              '${result.rawData.length} characters',
              colorScheme,
            ),
            _buildDetailRow(
              l10n.scanType,
              result.scanType.displayName,
              colorScheme,
            ),
            _buildDetailRow(
              l10n.contentType,
              result.contentType.displayName,
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.7),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ColorScheme colorScheme, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Iconsax.copy),
                label: Text(l10n.copyAll),
                onPressed: () => _copyToClipboard(context, l10n),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Iconsax.share),
                label: Text(l10n.share),
                onPressed: () => _shareResult(context, l10n),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            icon: const Icon(Iconsax.scan),
            label: Text(l10n.scanAnother),
            onPressed: () => _scanAnother(context),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Icon _getActionIcon() {
    switch (result.contentType) {
      case ContentType.url:
        return const Icon(Iconsax.global);
      case ContentType.email:
        return const Icon(Iconsax.sms);
      case ContentType.phone:
        return const Icon(Iconsax.call);
      case ContentType.sms:
        return const Icon(Iconsax.message);
      case ContentType.wifi:
        return const Icon(Iconsax.wifi);
      case ContentType.contact:
        return const Icon(Iconsax.profile_add);
      case ContentType.location:
        return const Icon(Iconsax.location);
      case ContentType.calendar:
        return const Icon(Iconsax.calendar_add);
      default:
        return const Icon(Iconsax.eye);
    }
  }

  void _copyToClipboard(BuildContext context, AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: result.rawData));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.copiedToClipboard),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareResult(BuildContext context, AppLocalizations l10n) {
    // Note: You might want to use the share_plus package for better sharing
    Clipboard.setData(ClipboardData(text: result.rawData));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.contentCopied),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _performAction(BuildContext context, AppLocalizations l10n) async {
    try {
      switch (result.contentType) {
        case ContentType.url:
          final uri = Uri.parse(result.rawData);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            _showErrorSnackBar(context, l10n.cannotOpenUrl);
          }
          break;

        case ContentType.email:
          String emailUrl = result.rawData;
          if (!emailUrl.startsWith('mailto:')) {
            emailUrl = 'mailto:$emailUrl';
          }
          final uri = Uri.parse(emailUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            _showErrorSnackBar(context, 'Cannot open email app');
          }
          break;

        case ContentType.phone:
          String phoneUrl = result.rawData;
          if (!phoneUrl.startsWith('tel:')) {
            phoneUrl = 'tel:$phoneUrl';
          }
          final uri = Uri.parse(phoneUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            _showErrorSnackBar(context, 'Cannot open phone app');
          }
          break;

        case ContentType.location:
          final parsedLocation = result.parsedContent;
          if (parsedLocation.containsKey('Latitude') &&
              parsedLocation.containsKey('Longitude')) {
            final lat = parsedLocation['Latitude'];
            final lng = parsedLocation['Longitude'];
            final uri = Uri.parse('https://maps.google.com/maps?q=$lat,$lng');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              _showErrorSnackBar(context, 'Cannot open maps');
            }
          }
          break;

        default:
          _copyToClipboard(context, l10n);
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Action failed: $e');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _scanAnother(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ScannerMainScreen()),
      (route) => route.isFirst,
    );
  }
}