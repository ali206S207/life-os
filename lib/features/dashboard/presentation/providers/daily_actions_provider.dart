import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/daily_actions_repository.dart';
import '../../domain/daily_action.dart';

final dailyActionsRepositoryProvider = Provider<DailyActionsRepository>((ref) {
  return LocalDailyActionsRepository();
});

/// Holds today's [DailyAction] list and exposes toggling logic.
/// Every action toggle recomputes progress % and total XP earned today —
/// this is the live state the progress ring and XP bar read from.
class DailyActionsNotifier extends StateNotifier<AsyncValue<List<DailyAction>>> {
  DailyActionsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  final DailyActionsRepository _repository;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final actions = await _repository.fetchToday();
      state = AsyncValue.data(actions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void toggle(String id) {
    state.whenData((actions) {
      state = AsyncValue.data([
        for (final action in actions)
          if (action.id == id) action.copyWith(isDone: !action.isDone) else action,
      ]);
    });
  }

  Future<void> refresh() => _load();
}

final dailyActionsProvider =
    StateNotifierProvider<DailyActionsNotifier, AsyncValue<List<DailyAction>>>((ref) {
  return DailyActionsNotifier(ref.watch(dailyActionsRepositoryProvider));
});

/// Derived: fraction of today's actions completed (0.0–1.0), for the ring.
final todayProgressProvider = Provider<double>((ref) {
  final actions = ref.watch(dailyActionsProvider).value ?? [];
  if (actions.isEmpty) return 0;
  final done = actions.where((a) => a.isDone).length;
  return done / actions.length;
});

/// Derived: total XP earned today from completed actions.
final todayXpProvider = Provider<int>((ref) {
  final actions = ref.watch(dailyActionsProvider).value ?? [];
  return actions.where((a) => a.isDone).fold(0, (sum, a) => sum + a.xpReward);
});
