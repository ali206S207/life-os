import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/life_areas_repository.dart';
import '../../domain/life_area.dart';

final lifeAreasRepositoryProvider = Provider<LifeAreasRepository>((ref) {
  return LocalLifeAreasRepository();
});

/// Fetches all Life Areas. AsyncNotifier keeps this test-friendly and
/// easy to swap for a Supabase-backed source later without touching UI.
class LifeAreasNotifier extends AsyncNotifier<List<LifeArea>> {
  @override
  Future<List<LifeArea>> build() {
    return ref.read(lifeAreasRepositoryProvider).fetchAreas();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(lifeAreasRepositoryProvider).fetchAreas(),
    );
  }
}

final lifeAreasProvider = AsyncNotifierProvider<LifeAreasNotifier, List<LifeArea>>(
  LifeAreasNotifier.new,
);

/// Derived: overall life-balance score — the average progress across all
/// areas. Used later by the Life Balance Wheel.
final overallBalanceProvider = Provider<double>((ref) {
  final areas = ref.watch(lifeAreasProvider).value ?? [];
  if (areas.isEmpty) return 0;
  final total = areas.fold<double>(0, (sum, a) => sum + a.progress);
  return total / areas.length;
});
