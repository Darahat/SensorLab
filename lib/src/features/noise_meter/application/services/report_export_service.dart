import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/utils/report_formatters.dart';
import 'package:share_plus/share_plus.dart';

class ReportExportService {
  static Future<void> exportToClipboard(String csvData) async {
    await Clipboard.setData(ClipboardData(text: csvData));
  }

  static Future<String?> exportToFile(String csvData, String filename) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final params = SaveFileDialogParams(
          fileName: filename,
          data: Uint8List.fromList(csvData.codeUnits),
        );
        return await FlutterFileDialog.saveFile(params: params);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$filename');
        await file.writeAsString(csvData);
        return file.path;
      }
    } catch (e) {
      rethrow;
    }
  }

  static String generateFilename() {
    final timestamp = DateTime.now();
    return 'acoustic_reports_${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')}_${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}.csv';
  }

  // ---- New helpers for full report export ----

  static String buildCsvFromReport(AcousticReport report) {
    final buffer = StringBuffer();
    final date = DateFormat('yyyy-MM-dd HH:mm').format(report.startTime);

    buffer.writeln('Acoustic Report');
    buffer.writeln('Date,$date');
    buffer.writeln('Duration,${_formatDuration(report.duration)}');
    buffer.writeln('Preset,${report.preset.name}');
    buffer.writeln('Average dB,${report.averageDecibels.toStringAsFixed(1)}');
    buffer.writeln('Peak dB,${report.maxDecibels.toStringAsFixed(1)}');
    buffer.writeln('Events,${report.interruptionCount}');
    buffer.writeln('Quality Score,${report.qualityScore}');
    buffer.writeln('');
    if (report.events.isNotEmpty) {
      buffer.writeln('Events');
      buffer.writeln('Time,Peak (dB)');
      for (final e in report.events) {
        final t = DateFormat('HH:mm:ss').format(e.timestamp);
        buffer.writeln('$t,${e.peakDecibels.toStringAsFixed(1)}');
      }
    }
    return buffer.toString();
  }

  static Future<void> shareCsvFromReport(AcousticReport report) async {
    final csv = buildCsvFromReport(report);
    final file = await _writeTempFile(
      _suggestCsvName(report),
      Uint8List.fromList(csv.codeUnits),
    );
    await Share.shareXFiles([file], text: 'Acoustic report CSV');
  }

  static Future<void> saveCsvFromReport(AcousticReport report) async {
    final csv = buildCsvFromReport(report);
    final params = SaveFileDialogParams(
      fileName: _suggestCsvName(report),
      data: Uint8List.fromList(csv.codeUnits),
      mimeTypesFilter: ['text/csv'],
    );
    await FlutterFileDialog.saveFile(params: params);
  }

  static Future<Uint8List> buildPdfFromReport(AcousticReport report) async {
    final doc = pw.Document();
    final date = DateFormat('yyyy-MM-dd HH:mm').format(report.startTime);
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Acoustic Report',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Text('Date: $date'),
            pw.Text('Duration: ${_formatDuration(report.duration)}'),
            pw.Text('Preset: ${report.preset.name}'),
            pw.SizedBox(height: 12),
            pw.Text(
              'Statistics',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Bullet(
              text:
                  'Average: ${ReportFormatters.formatDecibelValue(report.averageDecibels)}',
            ),
            pw.Bullet(
              text:
                  'Peak: ${ReportFormatters.formatDecibelValue(report.maxDecibels)}',
            ),
            pw.Bullet(text: 'Events: ${report.interruptionCount}'),
            pw.Bullet(text: 'Quality Score: ${report.qualityScore}/100'),
            pw.SizedBox(height: 12),
            if (report.events.isNotEmpty) ...[
              pw.Text(
                'Events',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Table.fromTextArray(
                headers: ['Time', 'Peak (dB)'],
                data: report.events
                    .map(
                      (e) => [
                        DateFormat('HH:mm:ss').format(e.timestamp),
                        e.peakDecibels.toStringAsFixed(1),
                      ],
                    )
                    .toList(),
              ),
            ],
            pw.SizedBox(height: 12),
            pw.Text(
              'Recommendation',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text(report.recommendation),
          ],
        ),
      ),
    );
    return doc.save();
  }

  static Future<void> savePdfFromReport(AcousticReport report) async {
    final bytes = await buildPdfFromReport(report);
    final params = SaveFileDialogParams(
      fileName: _suggestPdfName(report),
      data: bytes,
      mimeTypesFilter: ['application/pdf'],
    );
    await FlutterFileDialog.saveFile(params: params);
  }

  static Future<void> sharePdfFromReport(AcousticReport report) async {
    final bytes = await buildPdfFromReport(report);
    final file = await _writeTempFile(_suggestPdfName(report), bytes);
    await Share.shareXFiles([file], text: 'Acoustic report PDF');
  }

  static Future<XFile> _writeTempFile(String filename, Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final f = File('${dir.path}/$filename');
    await f.writeAsBytes(bytes, flush: true);
    return XFile(f.path);
  }

  static String _suggestCsvName(AcousticReport report) {
    final d = report.startTime;
    return 'acoustic_report_${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}_${d.hour.toString().padLeft(2, '0')}${d.minute.toString().padLeft(2, '0')}.csv';
  }

  static String _suggestPdfName(AcousticReport report) {
    final d = report.startTime;
    return 'acoustic_report_${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}_${d.hour.toString().padLeft(2, '0')}${d.minute.toString().padLeft(2, '0')}.pdf';
  }

  static String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = d.inHours;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}
