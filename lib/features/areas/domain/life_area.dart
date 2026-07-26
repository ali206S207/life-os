import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// One of the core "Life Areas" the whole app is organized around
/// (Fitness, Learning, Career, Finance, Relationships, Mental Health,
/// Spiritual, Fun). Each area tracks its own progress, XP and streak
/// independently of the others.
class LifeArea extends Equatable {
  const LifeArea({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
    required this.progress,
    required this.xp,
    required this.level,
    required this.currentStreak,
    required this.activeGoalsCount,
  });

  final String id;
  final String title;
  final String emoji;
  final Color color;

  /// 0.0–1.0 — this week's progress within the area.
  final double progress;
  final int xp;
  final int level;
  final int currentStreak; // in days
  final int activeGoalsCount;

  @override
  List<Object?> get props => [
        id,
        title,
        emoji,
        color,
        progress,
        xp,
        level,
        currentStreak,
        activeGoalsCount,
      ];
}
