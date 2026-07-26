import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/goals_provider.dart';
import '../widgets/goal_dependency_graph.dart';

class GoalDetailScreen extends ConsumerWidget {
  const GoalDetailScreen({super.key, required this.goalId});

  final String goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider).value ?? [];
    final goal = goals.firstWhere((g) => g.id == goalId);

    return Scaffold(
      appBar: AppBar(title: Text(goal.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxxl,
          ),
          children: [
            Center(child: GoalDependencyGraph(goal: goal)),
            const SizedBox(height: AppSpacing.lg),
            Text('Linked Systems', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.md),
            for (final system in goal.linkedSystems) ...[
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(system.emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(system.title, style: Theme.of(context).textTheme.titleMedium),
                        ),
                        Text(
                          '${system.currentValue.toStringAsFixed(1)} / '
                          '${system.targetValue.toStringAsFixed(1)} ${system.unit}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Slider(
                      value: system.currentValue.clamp(0, system.targetValue * 1.5),
                      min: 0,
                      max: system.targetValue * 1.5,
                      activeColor: AppColors.primary,
                      label: system.currentValue.toStringAsFixed(1),
                      onChanged: (value) {
                        ref.read(goalsProvider.notifier).updateSystemValue(
                              goal.id,
                              system.id,
                              value,
                            );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}
