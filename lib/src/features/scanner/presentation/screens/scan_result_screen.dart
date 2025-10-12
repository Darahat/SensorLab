import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/scan_result.dart';
import 'scanner_main_screen.dart';

class ScanResultScreen extends StatelessWidget {
  final ScanResult result;

  const ScanResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('${result.scanType.displayName} Result'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.copy),
            onPressed: () => _copyToClipboard(context),
          ),
          IconButton(
            icon: const Icon(Iconsax.share),
            onPressed: () => _shareResult(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            _buildHeaderCard(colorScheme),
            const SizedBox(height: 24),

            // Content card
            _buildContentCard(colorScheme),
            const SizedBox(height: 24),

            // Actions card (if actionable)
            if (result.isActionable) ...[
              _buildActionsCard(colorScheme, context),
              const SizedBox(height: 24),
            ],

            // Technical details card
            _buildTechnicalCard(colorScheme),
            const SizedBox(height: 32),

            // Action buttons
            _buildActionButtons(context, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(ColorScheme colorScheme) {
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
                    'Scanned ${result.formattedTimestamp}',
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

  Widget _buildContentCard(ColorScheme colorScheme) {
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
                const Text(
                  'Content',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildActionsCard(ColorScheme colorScheme, BuildContext context) {
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
                const Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: _getActionIcon(),
                label: Text(result.actionLabel),
                onPressed: () => _performAction(context),
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

  Widget _buildTechnicalCard(ColorScheme colorScheme) {
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
                const Text(
                  'Technical Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildDetailRow('Format', result.format.name, colorScheme),
            if (result.formatDetails != null)
              _buildDetailRow(
                'Description',
                result.formatDetails!,
                colorScheme,
              ),
            _buildDetailRow(
              'Data Length',
              '${result.rawData.length} characters',
              colorScheme,
            ),
            _buildDetailRow(
              'Scan Type',
              result.scanType.displayName,
              colorScheme,
            ),
            _buildDetailRow(
              'Content Type',
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

  Widget _buildActionButtons(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Iconsax.copy),
                label: const Text('Copy All'),
                onPressed: () => _copyToClipboard(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Iconsax.share),
                label: const Text('Share'),
                onPressed: () => _shareResult(context),
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
            label: const Text('Scan Another'),
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

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: result.rawData));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareResult(BuildContext context) {
    // Note: You might want to use the share_plus package for better sharing
    Clipboard.setData(ClipboardData(text: result.rawData));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Content copied to clipboard for sharing'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _performAction(BuildContext context) async {
    try {
      switch (result.contentType) {
        case ContentType.url:
          final uri = Uri.parse(result.rawData);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            _showErrorSnackBar(context, 'Cannot open URL');
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
          _copyToClipboard(context);
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
