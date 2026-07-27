import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/features/health/domain/health_snapshot.dart';

void main() {
  group('HealthSnapshot BMI', () {
    test('calculates BMI from weight and height', () {
      final snapshot = HealthSnapshot(
        date: DateTime(2026, 1, 1),
        weightKg: 74,
        heightCm: 178,
        calories: 2000,
        proteinGrams: 100,
        waterLiters: 2,
        sleepHours: 7,
        steps: 5000,
      );
      expect(snapshot.bmi, closeTo(23.4, 0.1));
      expect(snapshot.bmiCategory, 'Normal');
    });

    test('categorizes underweight and obese correctly', () {
      final underweight = HealthSnapshot(
        date: DateTime(2026, 1, 1),
        weightKg: 50,
        heightCm: 178,
        calories: 2000,
        proteinGrams: 100,
        waterLiters: 2,
        sleepHours: 7,
        steps: 5000,
      );
      expect(underweight.bmiCategory, 'Underweight');

      final obese = HealthSnapshot(
        date: DateTime(2026, 1, 1),
        weightKg: 110,
        heightCm: 170,
        calories: 2000,
        proteinGrams: 100,
        waterLiters: 2,
        sleepHours: 7,
        steps: 5000,
      );
      expect(obese.bmiCategory, 'Obese');
    });
  });
}
