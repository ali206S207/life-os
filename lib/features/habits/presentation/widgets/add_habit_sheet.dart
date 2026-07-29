import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/habit.dart';
import '../providers/habits_provider.dart';

/// Opens a bottom sheet to create a new habit, wired to
/// [HabitsNotifier.addHabit]. Kept intentionally simple — title, an
/// emoji, difficulty, and XP reward — matching what the Habit model
/// actually needs to start tracking a streak.
Future<void> showAddHabitSheet(BuildContext context, WidgetRef ref) {
  final titleController = TextEditingController();
  final emojiController = TextEditingController(text: '✨');
  HabitDifficulty difficulty = HabitDifficulty.medium;
  int xpReward = 10;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.darkSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg,
              MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('New Habit', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: emojiController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24),
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextField(
                        controller: titleController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Habit name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Difficulty', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<HabitDifficulty>(
                  segments: const [
                    ButtonSegment(value: HabitDifficulty.easy, label: Text('Easy')),
                    ButtonSegment(value: HabitDifficulty.medium, label: Text('Medium')),
                    ButtonSegment(value: HabitDifficulty.hard, label: Text('Hard')),
                  ],
                  selected: {difficulty},
                  onSelectionChanged: (selection) {
                    setState(() {
                      difficulty = selection.first;
                      xpReward = switch (difficulty) {
                        HabitDifficulty.easy => 5,
                        HabitDifficulty.medium => 10,
                        HabitDifficulty.hard => 20,
                      };
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final title = titleController.text.trim();
                      if (title.isEmpty) return;
                      ref.read(habitsProvider.notifier).addHabit(
                            title: title,
                            emoji: emojiController.text.trim().isEmpty
                                ? '✨'
                                : emojiController.text.trim(),
                            areaId: 'fitness',
                            difficulty: difficulty,
                            xpReward: xpReward,
                          );
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add Habit'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
