extension DoubleExtensions on double {
  String toDecibelString() => '${toStringAsFixed(1)} dB';

  bool isWithinRange(double min, double max) => this >= min && this <= max;
}
