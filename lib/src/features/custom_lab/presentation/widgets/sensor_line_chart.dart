import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

class SensorLineChart extends StatelessWidget {
  final List<double> data;
  final SensorType sensorType;
  final Color color;
  final dynamic currentValue;

  const SensorLineChart({
    super.key,
    required this.data,
    required this.sensorType,
    required this.color,
    this.currentValue,
  });

  String _getUnit() {
    switch (sensorType) {
      case SensorType.lightMeter:
        return 'lux';
      case SensorType.noiseMeter:
        return 'dB';
      case SensorType.temperature:
        return '°C';
      case SensorType.humidity:
        return '%';
      case SensorType.barometer:
        return 'hPa';
      case SensorType.accelerometer:
      case SensorType.gyroscope:
        return 'm/s²';
      case SensorType.magnetometer:
        return 'µT';
      case SensorType.altimeter:
        return 'm';
      case SensorType.speedMeter:
        return 'km/h';
      case SensorType.heartBeat:
        return 'bpm';
      case SensorType.pedometer:
        return 'steps';
      case SensorType.proximity:
        return 'cm';
      default:
        return '';
    }
  }

  String _formatValue(dynamic value) {
    if (value is Map) {
      return 'x:${(value['x'] as num).toStringAsFixed(2)} y:${(value['y'] as num).toStringAsFixed(2)} z:${(value['z'] as num).toStringAsFixed(2)}';
    } else if (value is num) {
      return '${value.toStringAsFixed(2)} ${_getUnit()}';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unit = _getUnit();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    sensorType.displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (currentValue != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Text(
                      _formatValue(currentValue),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: data.isEmpty
                  ? Center(
                      child: Text(
                        'Collecting data...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : CustomPaint(
                      painter: _LineChartPainter(data, color),
                      child: Container(),
                    ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatChip(
                  'Min',
                  data.isNotEmpty
                      ? '${data.reduce((a, b) => a < b ? a : b).toStringAsFixed(1)} $unit'
                      : '-',
                  Colors.green,
                ),
                _buildStatChip(
                  'Avg',
                  data.isNotEmpty
                      ? '${(data.reduce((a, b) => a + b) / data.length).toStringAsFixed(1)} $unit'
                      : '-',
                  Colors.orange,
                ),
                _buildStatChip(
                  'Max',
                  data.isNotEmpty
                      ? '${data.reduce((a, b) => a > b ? a : b).toStringAsFixed(1)} $unit'
                      : '-',
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  _LineChartPainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path();
    final minY = data.reduce((a, b) => a < b ? a : b);
    final maxY = data.reduce((a, b) => a > b ? a : b);
    final rangeY = (maxY - minY).abs() < 1e-6 ? 1.0 : (maxY - minY);
    for (int i = 0; i < data.length; i++) {
      final x = i * size.width / (data.length - 1);
      final y = size.height - ((data[i] - minY) / rangeY * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
