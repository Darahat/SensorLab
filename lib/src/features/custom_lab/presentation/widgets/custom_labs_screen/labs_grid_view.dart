import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/screens/lab_detail_screen.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/widgets_index.dart';

class LabsGridView extends StatelessWidget {
  final List<Lab> labs;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const LabsGridView({
    super.key,
    required this.labs,
    this.shrinkWrap = true,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: labs.length,
      itemBuilder: (context, index) {
        final lab = labs[index];
        return LabCard(lab: lab, onTap: () => _handleLabTap(context, lab));
      },
    );
  }

  Future<void> _handleLabTap(BuildContext context, Lab lab) async {
    if (lab.isPreset) {
      final proceed = await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (_) => PresetPreflightDialog(lab: lab),
      );
      if (proceed == true && context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LabDetailScreen(lab: lab)),
        );
      }
    } else {
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LabDetailScreen(lab: lab)),
      );
    }
  }
}
