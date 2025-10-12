import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:sensorlab/l10n/app_localizations.dart';

class CalorieBurnHelper {
  final BuildContext context;
  final Function(VoidCallback) safeSetState;
  double totalDistance;
  double currentSpeed;
  String activityType;
  double userWeight;
  double caloriesBurned;
  double temperature;
  double heightInCm;
  String gender;
  final Function() saveUserData;
  final Function(double) onCaloriesCalculated; // Add this callback

  CalorieBurnHelper({
    required this.context,
    required this.safeSetState,
    required this.totalDistance,
    required this.currentSpeed,
    required this.activityType,
    required this.userWeight,
    required this.caloriesBurned,
    required this.temperature,
    required this.heightInCm,
    required this.gender,
    required this.saveUserData,
    required this.onCaloriesCalculated,
  });

  Future<void> fetchTemperature(double lat, double lon) async {
    try {
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        debugPrint('OpenWeather API key not set. Skipping temperature fetch.');
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        safeSetState(() {
          temperature = data['main']['temp']?.toDouble() ?? 20.0;
        });
      }
    } catch (e) {
      debugPrint('Error fetching temperature: $e');
    }
  }

  void calculateCalories(double distanceKm, double speedKmph) {
    if (speedKmph <= 0 || distanceKm <= 0) return;
    double bmiFactor = 1.0;

    if (heightInCm > 0) {
      final bmi = userWeight / ((heightInCm / 100) * (heightInCm / 100));
      bmiFactor = 1.0 + (bmi - 22) * 0.02; // Adjust MET based on BMI
    }
    final timeHours = distanceKm / speedKmph;
    final genderFactor = gender == 'male' ? 1.05 : 0.95;
    final metValues = {
      'Walking': _getWalkingMET(speedKmph) * bmiFactor * genderFactor,
      'Running': _getRunningMET(speedKmph) * bmiFactor * genderFactor,
      'Cycling': _getCyclingMET(speedKmph) * bmiFactor * genderFactor,
    };

    if (metValues.containsKey(activityType)) {
      final double metValue = metValues[activityType]!;
      final double calories = metValue * userWeight * timeHours;

      safeSetState(() {
        caloriesBurned = calories;
      });
      onCaloriesCalculated(calories); // Notify parent
    }
  }

  double _getWalkingMET(double speedKmph) {
    if (speedKmph < 3.0) return 2.5;
    if (speedKmph < 5.0) return 3.5;
    return 4.5;
  }

  double _getRunningMET(double speedKmph) {
    return 7.0 + (speedKmph - 8.0) * 0.5;
  }

  double _getCyclingMET(double speedKmph) {
    if (speedKmph < 16.0) return 4.0;
    if (speedKmph < 20.0) return 6.0;
    return 8.0;
  }

  Future<void> showWeightInputDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final weightController = TextEditingController(
      text: userWeight.toStringAsFixed(0),
    );
    final heightController = TextEditingController(
      text: heightInCm.toStringAsFixed(0),
    );
    String? selectedGender = gender;

    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text(l10n.enterYourDetails),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: l10n.weightKg,
                            suffixText: 'kg',
                          ),
                        ),
                        TextField(
                          controller: heightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: l10n.heightCm,
                            suffixText: 'cm',
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: selectedGender,
                          items: [
                            DropdownMenuItem(
                              value: 'male',
                              child: Text(l10n.male),
                            ),
                            DropdownMenuItem(
                              value: 'female',
                              child: Text(l10n.female),
                            ),
                          ],
                          onChanged:
                              (value) => setState(() => selectedGender = value),
                          decoration: InputDecoration(
                            labelText: l10n.gender,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () async {
                        final weight =
                            double.tryParse(weightController.text) ??
                            userWeight;
                        final height =
                            double.tryParse(heightController.text) ??
                            heightInCm;
                        final genderValue = selectedGender ?? gender;

                        safeSetState(() {
                          userWeight = weight;
                          heightInCm = height;
                          gender = genderValue;
                        });

                        await saveUserData();
                        if (totalDistance > 0 && currentSpeed > 0) {
                          calculateCalories(totalDistance / 1000, currentSpeed);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(l10n.save),
                    ),
                  ],
                ),
          ),
    );
  }

  Future<void> showActivityTypeDialog() async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.selectActivity),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(l10n.walking),
                  leading: const Icon(Icons.directions_walk),
                  onTap: () {
                    safeSetState(() => activityType = 'Walking');
                    saveUserData();
                    if (totalDistance > 0 && currentSpeed > 0) {
                      calculateCalories(totalDistance / 1000, currentSpeed);
                    }
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(l10n.running),
                  leading: const Icon(Icons.directions_run),
                  onTap: () {
                    safeSetState(() => activityType = 'Running');
                    saveUserData();
                    if (totalDistance > 0 && currentSpeed > 0) {
                      calculateCalories(totalDistance / 1000, currentSpeed);
                    }
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(l10n.cycling),
                  leading: const Icon(Icons.directions_bike),
                  onTap: () {
                    safeSetState(() => activityType = 'Cycling');
                    saveUserData();
                    if (totalDistance > 0 && currentSpeed > 0) {
                      calculateCalories(totalDistance / 1000, currentSpeed);
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }
}