import 'package:equatable/equatable.dart';

/// A single unlockable achievement (e.g. "First Workout", "7-Day Streak").
/// Achievements are evaluated against live app state (see
/// [AchievementsNotifier]) rather than stored as a flat unlocked flag,
/// so they stay correct as habits/goals/XP change.
class Achievement extends Equatable {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.isUnlocked,
    this.unlockedAt,
  });

  final String id;
  final String title;
  final String description;
  final String emoji;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  Achievement copyWith({bool? isUnlocked, DateTime? unlockedAt}) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      emoji: emoji,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, description, emoji, isUnlocked, unlockedAt];
}
