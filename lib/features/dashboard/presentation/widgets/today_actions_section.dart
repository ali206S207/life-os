import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/daily_actions_provider.dart';

class TodayActionsSection extends ConsumerWidget {
  const TodayActionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionsAsync = ref.watch(dailyActionsProvider);

    return actionsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, _) => GlassCard(
        child: Text(
          'Could not load today\'s actions.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      data: (actions) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          for (final action in actions) ...[
            _DailyActionTile(action: action),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _DailyActionTile extends ConsumerWidget {
  const _DailyActionTile({required this.action});

  final dynamic action; // DailyAction — dynamic to avoid an extra import cycle here

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDone = action.isDone as bool;
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      onTap: () => ref.read(dailyActionsProvider.notifier).toggle(action.id as String),
      child: Row(
        children: [
          Text(action.emoji as String, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.title as String,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: isDone ? TextDecoration.lineThrough : null,
                        color: isDone ? AppColors.textMuted : AppColors.textPrimary,
                      ),
                ),
                Text(
                  '${action.time}  ·  +${action.xpReward} XP',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isDone ? AppColors.primaryGradient : null,
              border: Border.all(
                color: isDone ? Colors.transparent : AppColors.darkBorder,
                width: 2,
              ),
            ),
            child: isDone
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }
}
