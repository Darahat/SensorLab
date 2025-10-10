class GyroscopeData {
  final double x;
  final double y;
  final double z;
  final double intensity;
  final bool isActive;
  final List<GyroscopePoint> xPoints;
  final List<GyroscopePoint> yPoints;
  final List<GyroscopePoint> zPoints;
  final int time;

  const GyroscopeData({
    this.x = 0,
    this.y = 0,
    this.z = 0,
    this.intensity = 0,
    this.isActive = false,
    this.xPoints = const [],
    this.yPoints = const [],
    this.zPoints = const [],
    this.time = 0,
  });

  GyroscopeData copyWith({
    double? x,
    double? y,
    double? z,
    double? intensity,
    bool? isActive,
    List<GyroscopePoint>? xPoints,
    List<GyroscopePoint>? yPoints,
    List<GyroscopePoint>? zPoints,
    int? time,
  }) {
    return GyroscopeData(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      intensity: intensity ?? this.intensity,
      isActive: isActive ?? this.isActive,
      xPoints: xPoints ?? this.xPoints,
      yPoints: yPoints ?? this.yPoints,
      zPoints: zPoints ?? this.zPoints,
      time: time ?? this.time,
    );
  }
}

class GyroscopePoint {
  final double time;
  final double value;

  const GyroscopePoint(this.time, this.value);
}
