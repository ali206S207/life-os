import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/health_repository.dart';
import '../../domain/health_snapshot.dart';

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return LocalHealthRepository();
});

final todayHealthProvider = FutureProvider<HealthSnapshot>((ref) {
  return ref.read(healthRepositoryProvider).fetchToday();
});

final weightHistoryProvider = FutureProvider<List<double>>((ref) {
  return ref.read(healthRepositoryProvider).fetchWeightHistory();
});
