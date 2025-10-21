import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

class NoiseMeterGuideSection extends StatelessWidget {
  final AppLocalizations l10n;

  const NoiseMeterGuideSection({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(l10n.noiseMeterGuide),
      ),
    );
  }
}
