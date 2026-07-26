import 'package:equatable/equatable.dart';

enum HabitDifficulty { easy, medium, hard }

/// A recurring habit (e.g. "Drink Water", "Read", "Meditate").
/// Unlike a one-off [DailyAction], a Habit persists across days and
/// tracks its own streak history, difficulty, and XP reward.
class Habit extends Equatable {
  const Habit({
    required this.id,
    required this.title,
    required this.emoji,
    required this.areaId,
    required this.difficulty,
    required this.xpReward,
    required this.currentStreak,
    required this.bestStreak,
    required this.completionRate,
    required this.missHistory,
    this.isDoneToday = false,
    this.notes,
  });

  final String id;
  final String title;
  final String emoji;
  final String areaId;
  final HabitDifficulty difficulty;
  final int xpReward;
  final int currentStreak;
  final int bestStreak;

  /// 0.0–1.0 completion rate over the tracked period.
  final double completionRate;

  /// Dates the habit was missed (most recent first), used for the
  /// "miss history" the spec calls for.
  final List<DateTime> missHistory;

  final bool isDoneToday;
  final String? notes;

  Habit copyWith({bool? isDoneToday, int? currentStreak, int? bestStreak}) {
    return Habit(
      id: id,
      title: title,
      emoji: emoji,
      areaId: areaId,
      difficulty: difficulty,
      xpReward: xpReward,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      completionRate: completionRate,
      missHistory: missHistory,
      isDoneToday: isDoneToday ?? this.isDoneToday,
      notes: notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        emoji,
        areaId,
        difficulty,
        xpReward,
        currentStreak,
        bestStreak,
        completionRate,
        missHistory,
        isDoneToday,
        notes,
      ];
}
