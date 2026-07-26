import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../goals/presentation/providers/goals_provider.dart';
import '../../../habits/presentation/providers/habits_provider.dart';
import '../../domain/achievement.dart';
import 'xp_provider.dart';

/// Evaluates all achievement conditions against current app state.
/// Achievements are derived, not stored — unlocking a 7-day streak by
/// completing a habit today is reflected the instant that habit's
/// provider updates, with no separate "check achievements" step needed.
final achievementsProvider = Provider<List<Achievement>>((ref) {
  final habits = ref.watch(habitsProvider).value ?? [];
  final goals = ref.watch(goalsProvider).value ?? [];
  final level = ref.watch(levelInfoProvider);

  final hasAnyHabitDoneEver = habits.any((h) => h.currentStreak > 0 || h.isDoneToday);
  final has7DayStreak = habits.any((h) => h.currentStreak >= 7);
  final has30DayStreak = habits.any((h) => h.currentStreak >= 30);
  final hasCompletedGoal = goals.any((g) => g.progress >= 1.0);
  final workoutHabit = habits.where((h) => h.title.toLowerCase().contains('workout'));
  final hasFirstWorkout = workoutHabit.any((h) => h.currentStreak > 0 || h.isDoneToday);
  final readingHabit = habits.where((h) => h.title.toLowerCase().contains('read'));
  final has30DaysReading = readingHabit.any((h) => h.bestStreak >= 30);

  return [
    Achievement(
      id: 'first_workout',
      title: 'First Workout',
      description: 'Complete your first workout habit.',
      emoji: '🏆',
      isUnlocked: hasFirstWorkout,
    ),
    Achievement(
      id: 'first_habit',
      title: 'Getting Started',
      description: 'Complete any habit for the first time.',
      emoji: '🌱',
      isUnlocked: hasAnyHabitDoneEver,
    ),
    Achievement(
      id: 'streak_7',
      title: '7-Day Streak',
      description: 'Keep a habit streak alive for 7 days.',
      emoji: '🔥',
      isUnlocked: has7DayStreak,
    ),
    Achievement(
      id: 'streak_30',
      title: '30-Day Streak',
      description: 'Keep a habit streak alive for 30 days.',
      emoji: '💎',
      isUnlocked: has30DayStreak,
    ),
    Achievement(
      id: 'reading_30',
      title: '30 Days Reading',
      description: "Hit a 30-day best streak on a reading habit.",
      emoji: '📖',
      isUnlocked: has30DaysReading,
    ),
    Achievement(
      id: 'goal_completed',
      title: 'Goal Completed',
      description: 'Reach 100% progress on any goal.',
      emoji: '🎯',
      isUnlocked: hasCompletedGoal,
    ),
    Achievement(
      id: 'level_5',
      title: 'Level 5',
      description: 'Reach level 5 overall.',
      emoji: '⭐',
      isUnlocked: level.level >= 5,
    ),
    Achievement(
      id: 'level_10',
      title: 'Level 10',
      description: 'Reach level 10 overall.',
      emoji: '🌟',
      isUnlocked: level.level >= 10,
    ),
  ];
});

/// Derived counts for a compact "X / Y unlocked" summary.
final achievementsUnlockedCountProvider = Provider<int>((ref) {
  return ref.watch(achievementsProvider).where((a) => a.isUnlocked).length;
});
