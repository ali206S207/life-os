import '../../dashboard/domain/daily_action.dart';
import '../../goals/domain/goal.dart';
import '../../habits/domain/habit.dart';
import 'assistant_suggestion.dart';

/// Generates proactive suggestions purely from current app state — no
/// external AI call needed for these patterns, which keeps the
/// Assistant fast, offline-capable, and fully deterministic/testable.
/// A generative-AI layer (for open-ended questions) can sit on top of
/// this later without replacing it.
class AssistantSuggestionEngine {
  const AssistantSuggestionEngine._();

  static List<AssistantSuggestion> generate({
    required List<DailyAction> todayActions,
    required List<Habit> habits,
    required List<Goal> goals,
    required double levelProgress,
  }) {
    final suggestions = <AssistantSuggestion>[];

    // Rule: exactly one action left today -> push to finish for 100%.
    final remaining = todayActions.where((a) => !a.isDone).toList();
    if (todayActions.isNotEmpty && remaining.length == 1) {
      suggestions.add(AssistantSuggestion(
        id: 'one_left_${remaining.first.id}',
        emoji: '🎯',
        message:
            'You have only one task left today: "${remaining.first.title}". '
            'Finish it now and your day will be 100% complete.',
        priority: SuggestionPriority.high,
      ));
    }

    // Rule: nothing completed yet today -> suggest a small first step.
    final completedToday = todayActions.where((a) => a.isDone).length;
    if (todayActions.isNotEmpty && completedToday == 0) {
      suggestions.add(const AssistantSuggestion(
        id: 'no_start_yet',
        emoji: '🧠',
        message: "Don't know where to start? Start with a 15-minute study session.",
        priority: SuggestionPriority.medium,
      ));
    }

    // Rule: a habit that used to have a streak just got broken (streak
    // reset to 0 but it had momentum before) -> nudge to restart today.
    for (final habit in habits) {
      if (!habit.isDoneToday && habit.currentStreak == 0 && habit.bestStreak >= 3) {
        suggestions.add(AssistantSuggestion(
          id: 'streak_broken_${habit.id}',
          emoji: '🔥',
          message:
              'You skipped "${habit.title}" recently. Going today starts building '
              'your streak back up toward your best of ${habit.bestStreak} days.',
          priority: SuggestionPriority.high,
        ));
      }
    }

    // Rule: a habit is close to a milestone streak (6 -> keep going for 7).
    for (final habit in habits) {
      if (habit.isDoneToday && habit.currentStreak == 6) {
        suggestions.add(AssistantSuggestion(
          id: 'streak_milestone_${habit.id}',
          emoji: '🏆',
          message:
              'One more day of "${habit.title}" and you\'ll hit a 7-day streak.',
          priority: SuggestionPriority.medium,
        ));
      }
    }

    // Rule: a goal is close to completion.
    for (final goal in goals) {
      if (goal.progress >= 0.8 && goal.progress < 1.0) {
        suggestions.add(AssistantSuggestion(
          id: 'goal_close_${goal.id}',
          emoji: '🚀',
          message:
              '"${goal.title}" is ${(goal.progress * 100).round()}% done. '
              'A little more effort and it\'s complete.',
          priority: SuggestionPriority.medium,
        ));
      }
    }

    // Rule: close to leveling up.
    if (levelProgress >= 0.85) {
      suggestions.add(const AssistantSuggestion(
        id: 'level_close',
        emoji: '⭐',
        message: "You're almost at the next level — a couple more completed actions will do it.",
        priority: SuggestionPriority.low,
      ));
    }

    // Fallback: everything done, nothing to flag.
    if (suggestions.isEmpty && todayActions.isNotEmpty && remaining.isEmpty) {
      suggestions.add(const AssistantSuggestion(
        id: 'all_done',
        emoji: '✅',
        message: "Everything's done for today. Nice work — take the win.",
        priority: SuggestionPriority.low,
      ));
    }

    suggestions.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    return suggestions.take(4).toList();
  }
}
