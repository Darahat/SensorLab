import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';

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
}
