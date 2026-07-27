import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/features/assistant/domain/assistant_suggestion_engine.dart';
import 'package:life_os/features/dashboard/domain/daily_action.dart';
import 'package:life_os/features/habits/domain/habit.dart';

void main() {
  group('AssistantSuggestionEngine', () {
    test('flags when exactly one action remains', () {
      final actions = [
        const DailyAction(id: 'a1', title: 'Workout', emoji: '🏋️', xpReward: 20, time: '08:00', isDone: true),
        const DailyAction(id: 'a2', title: 'Study', emoji: '🧠', xpReward: 15, time: '12:00', isDone: false),
      ];

      final suggestions = AssistantSuggestionEngine.generate(
        todayActions: actions,
        habits: const [],
        goals: const [],
        levelProgress: 0.2,
      );

      expect(suggestions.any((s) => s.id.startsWith('one_left_')), isTrue);
    });

    test('flags a broken streak for a habit with prior momentum', () {
      final habits = [
        const Habit(
          id: 'h1',
          title: 'Morning Workout',
          emoji: '🏋️',
          areaId: 'fitness',
          difficulty: HabitDifficulty.hard,
          xpReward: 20,
          currentStreak: 0,
          bestStreak: 14,
          completionRate: 0.5,
          missHistory: [],
          isDoneToday: false,
        ),
      ];

      final suggestions = AssistantSuggestionEngine.generate(
        todayActions: const [],
        habits: habits,
        goals: const [],
        levelProgress: 0.2,
      );

      expect(suggestions.any((s) => s.id == 'streak_broken_h1'), isTrue);
    });

    test('returns at most 4 suggestions', () {
      final habits = List.generate(
        10,
        (i) => Habit(
          id: 'h$i',
          title: 'Habit $i',
          emoji: '⭐',
          areaId: 'fitness',
          difficulty: HabitDifficulty.medium,
          xpReward: 10,
          currentStreak: 0,
          bestStreak: 5,
          completionRate: 0.5,
          missHistory: const [],
          isDoneToday: false,
        ),
      );

      final suggestions = AssistantSuggestionEngine.generate(
        todayActions: const [],
        habits: habits,
        goals: const [],
        levelProgress: 0.2,
      );

      expect(suggestions.length, lessThanOrEqualTo(4));
    });
  });
}
