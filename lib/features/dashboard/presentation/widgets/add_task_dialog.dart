import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/daily_actions_provider.dart';

Future<void> showAddTaskDialog(BuildContext context, WidgetRef ref) {
  final titleController = TextEditingController();
  final emojiController = TextEditingController(text: '✅');
  final timeController = TextEditingController(text: '09:00');

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.darkSurface,
      title: const Text('New Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(
                width: 60,
                child: TextField(
                  controller: emojiController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Task', border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: timeController,
            decoration: const InputDecoration(labelText: 'Time (e.g. 09:00)', border: OutlineInputBorder()),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final title = titleController.text.trim();
            if (title.isEmpty) return;
            ref.read(dailyActionsProvider.notifier).addAction(
                  title: title,
                  emoji: emojiController.text.trim().isEmpty ? '✅' : emojiController.text.trim(),
                  xpReward: 10,
                  time: timeController.text.trim().isEmpty ? '—' : timeController.text.trim(),
                );
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    ),
  );
}
