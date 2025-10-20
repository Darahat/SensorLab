import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

class StopRecordingDialog {
  static Future<bool> show(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.stopRecordingConfirmTitle),
            content: Text(l10n.stopRecordingConfirmMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.continueRecording),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.recordingStop),
              ),
            ],
          ),
        ) ??
        false;
  }
}
