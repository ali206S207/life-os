import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/goals_provider.dart';
import 'goal_detail_screen.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(goalsProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl,
            ),
            children: [
              Text('Goals', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: AppSpacing.lg),
              goalsAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => GlassCard(
                  child: Text(
                    'Could not load goals.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                data: (goals) => Column(
                  children: [
                    for (final goal in goals) ...[
                      GlassCard(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => GoalDetailScreen(goalId: goal.id)),
                        ),
                        child: Row(
                          children: [
                            Text(goal.emoji, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(goal.title, style: Theme.of(context).textTheme.titleLarge),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${goal.linkedSystems.length} linked systems',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${(goal.progress * 100).round()}%',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
