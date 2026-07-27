import '../domain/health_snapshot.dart';

abstract class HealthRepository {
  Future<HealthSnapshot> fetchToday();
  Future<List<double>> fetchWeightHistory({int days = 14});
}

class LocalHealthRepository implements HealthRepository {
  @override
  Future<HealthSnapshot> fetchToday() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return HealthSnapshot(
      date: DateTime.now(),
      weightKg: 74,
      heightCm: 178,
      calories: 2100,
      proteinGrams: 110,
      waterLiters: 2.2,
      sleepHours: 6.5,
      steps: 6400,
    );
  }

  @override
  Future<List<double>> fetchWeightHistory({int days = 14}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    // A gentle, realistic downward trend toward the "Reach 70kg" goal.
    return List.generate(days, (i) => 76.5 - (i * 0.18));
  }
}
