import 'package:flutter/material.dart';

/// A widget that displays a single row in the noise level guide.
class NoiseGuideItem extends StatelessWidget {
  const NoiseGuideItem({
    super.key,
    required this.level,
    required this.range,
    required this.examples,
    required this.color,
  });

  final String level;
  final String range;
  final String examples;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$level ($range)',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  examples,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
