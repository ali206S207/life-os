import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/providers/daily_actions_provider.dart';
import '../../../goals/presentation/providers/goals_provider.dart';
import '../../../habits/presentation/providers/habits_provider.dart';
import '../../../xp/presentation/providers/xp_provider.dart';
import '../../domain/assistant_suggestion.dart';
import '../../domain/assistant_suggestion_engine.dart';

/// Recomputes suggestions live from Dashboard actions, Habits, Goals
/// and level progress — whenever any of those change, the Assistant's
/// advice updates automatically with no manual refresh step.
final assistantSuggestionsProvider = Provider<List<AssistantSuggestion>>((ref) {
  final actions = ref.watch(dailyActionsProvider).value ?? [];
  final habits = ref.watch(habitsProvider).value ?? [];
  final goals = ref.watch(goalsProvider).value ?? [];
  final levelProgress = ref.watch(levelInfoProvider).progress;

  return AssistantSuggestionEngine.generate(
    todayActions: actions,
    habits: habits,
    goals: goals,
    levelProgress: levelProgress,
  );
});
