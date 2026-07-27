import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/projects_provider.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl,
          ),
          children: [
            Text('Projects', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: AppSpacing.lg),
            projectsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const Text('Could not load projects.'),
              data: (projects) => Column(
                children: [
                  for (final project in projects) ...[
                    GlassCard(
                      padding: EdgeInsets.zero,
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg, vertical: AppSpacing.sm,
                          ),
                          childrenPadding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md,
                          ),
                          leading: Text(project.emoji, style: const TextStyle(fontSize: 22)),
                          title: Text(project.title, style: Theme.of(context).textTheme.titleLarge),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                  child: LinearProgressIndicator(
                                    value: project.progress,
                                    minHeight: 6,
                                    backgroundColor: AppColors.darkBorder,
                                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${(project.progress * 100).round()}% · '
                                  '${project.daysRemaining >= 0 ? '${project.daysRemaining}d left' : 'overdue'}',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                          children: [
                            for (final task in project.tasks)
                              CheckboxListTile(
                                value: task.isDone,
                                onChanged: (_) => ref
                                    .read(projectsProvider.notifier)
                                    .toggleTask(project.id, task.id),
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: AppColors.primary,
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  task.title,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        decoration: task.isDone ? TextDecoration.lineThrough : null,
                                        color: task.isDone ? AppColors.textMuted : AppColors.textPrimary,
                                      ),
                                ),
                              ),
                          ],
                        ),
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
    );
  }
}
