import 'package:equatable/equatable.dart';

/// A snapshot of the user's core health metrics for "today". BMI is
/// derived from weight + height rather than stored directly, since it
/// should never drift out of sync with the two values it depends on.
class HealthSnapshot extends Equatable {
  const HealthSnapshot({
    required this.date,
    required this.weightKg,
    required this.heightCm,
    required this.calories,
    required this.proteinGrams,
    required this.waterLiters,
    required this.sleepHours,
    required this.steps,
  });

  final DateTime date;
  final double weightKg;
  final double heightCm;
  final int calories;
  final double proteinGrams;
  final double waterLiters;
  final double sleepHours;
  final int steps;

  double get bmi {
    final heightM = heightCm / 100;
    if (heightM == 0) return 0;
    return weightKg / (heightM * heightM);
  }

  String get bmiCategory {
    final b = bmi;
    if (b < 18.5) return 'Underweight';
    if (b < 25) return 'Normal';
    if (b < 30) return 'Overweight';
    return 'Obese';
  }

  @override
  List<Object?> get props => [
        date,
        weightKg,
        heightCm,
        calories,
        proteinGrams,
        waterLiters,
        sleepHours,
        steps,
      ];
}
