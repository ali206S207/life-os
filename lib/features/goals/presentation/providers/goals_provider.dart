import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/goals_repository.dart';
import '../../data/supabase_goals_repository.dart';
import '../../domain/goal.dart';

final goalsRepositoryProvider = Provider<GoalsRepository>((ref) {
  return SupabaseGoalsRepository(ref.watch(supabaseClientProvider));
});

class GoalsNotifier extends AsyncNotifier<List<Goal>> {
  @override
  Future<List<Goal>> build() {
    return ref.read(goalsRepositoryProvider).fetchGoals();
  }

  /// Updates one linked system's current value. The parent goal's
  /// progress is a derived getter, so it recalculates automatically —
  /// this is the "every update should automatically affect the goal
  /// progress" behavior from the spec. Applied optimistically, then
  /// persisted to Supabase in the background.
  void updateSystemValue(String goalId, String systemId, double newValue) {
    state.whenData((goals) {
      state = AsyncValue.data([
        for (final goal in goals)
          if (goal.id == goalId)
            goal.copyWithSystem(
              goal.linkedSystems
                  .firstWhere((s) => s.id == systemId)
                  .let((s) => LinkedSystem(
                        id: s.id,
                        title: s.title,
                        emoji: s.emoji,
                        currentValue: newValue,
                        targetValue: s.targetValue,
                        unit: s.unit,
                        weight: s.weight,
                      )),
            )
          else
            goal,
      ]);
    });

    ref.read(goalsRepositoryProvider).persistSystemValue(systemId, newValue).catchError((e) {
      debugPrint('Failed to persist system value: $e');
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(goalsRepositoryProvider).fetchGoals());
  }
}

final goalsProvider = AsyncNotifierProvider<GoalsNotifier, List<Goal>>(GoalsNotifier.new);

/// Convenience extension so we can chain a transform inline above,
/// Kotlin-`let`-style, without an extra local variable.
extension _Let<T> on T {
  R let<R>(R Function(T) f) => f(this);
}
