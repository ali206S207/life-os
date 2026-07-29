import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/habits_repository.dart';
import '../../data/supabase_habits_repository.dart';
import '../../domain/habit.dart';

/// Real, Supabase-backed persistence — the app requires sign-in (see
/// [AuthGate]) before this provider is ever read, so a signed-in
/// client is always available here.
final habitsRepositoryProvider = Provider<HabitsRepository>((ref) {
  return SupabaseHabitsRepository(ref.watch(supabaseClientProvider));
});

class HabitsNotifier extends AsyncNotifier<List<Habit>> {
  @override
  Future<List<Habit>> build() {
    return ref.read(habitsRepositoryProvider).fetchHabits();
  }

  /// Toggling a habit for today also updates its streak: completing it
  /// increments the streak (and best streak if a new record), undoing
  /// it steps the streak back down. The change is applied optimistically
  /// to local state, then persisted to Supabase in the background.
  void toggleToday(String id) {
    state.whenData((habits) {
      final updated = [
        for (final habit in habits)
          if (habit.id == id) _toggleHabit(habit) else habit,
      ];
      state = AsyncValue.data(updated);

      final toggled = updated.firstWhere((h) => h.id == id);
      ref.read(habitsRepositoryProvider).persistToggle(toggled).catchError((e) {
        debugPrint('Failed to persist habit toggle: $e');
      });
    });
  }

  Habit _toggleHabit(Habit habit) {
    final nowDone = !habit.isDoneToday;
    final newStreak = nowDone ? habit.currentStreak + 1 : (habit.currentStreak - 1).clamp(0, 1 << 30);
    final newBest = newStreak > habit.bestStreak ? newStreak : habit.bestStreak;
    return habit.copyWith(
      isDoneToday: nowDone,
      currentStreak: newStreak,
      bestStreak: newBest,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(habitsRepositoryProvider).fetchHabits());
  }
}

final habitsProvider = AsyncNotifierProvider<HabitsNotifier, List<Habit>>(HabitsNotifier.new);

/// Derived: total XP earned today across all completed habits.
final habitsXpTodayProvider = Provider<int>((ref) {
  final habits = ref.watch(habitsProvider).value ?? [];
  return habits.where((h) => h.isDoneToday).fold(0, (sum, h) => sum + h.xpReward);
});
