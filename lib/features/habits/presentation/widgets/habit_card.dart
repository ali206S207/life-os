import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/habit.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({super.key, required this.habit, required this.onToggle});

  final Habit habit;
  final VoidCallback onToggle;

  Color get _difficultyColor {
    switch (habit.difficulty) {
      case HabitDifficulty.easy:
        return AppColors.success;
      case HabitDifficulty.medium:
        return AppColors.warning;
      case HabitDifficulty.hard:
        return AppColors.danger;
    }
  }

  String get _difficultyLabel {
    switch (habit.difficulty) {
      case HabitDifficulty.easy:
        return 'Easy';
      case HabitDifficulty.medium:
        return 'Medium';
      case HabitDifficulty.hard:
        return 'Hard';
    }
  }

  @override
  Widget build(BuildContext context) {
    final done = habit.isDoneToday;
    return GlassCard(
      onTap: onToggle,
      gradientBorder: done,
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: done ? AppColors.primaryGradient : null,
              color: done ? null : AppColors.darkSurfaceElevated,
              shape: BoxShape.circle,
              border: Border.all(color: done ? Colors.transparent : AppColors.darkBorder),
            ),
            alignment: Alignment.center,
            child: Text(habit.emoji, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: done ? TextDecoration.lineThrough : null,
                        color: done ? AppColors.textMuted : AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _Badge(
                      label: _difficultyLabel,
                      color: _difficultyColor,
                    ),
                    const SizedBox(width: 6),
                    Text('🔥 ${habit.currentStreak}d', style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(width: 6),
                    Text('+${habit.xpReward} XP', style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
