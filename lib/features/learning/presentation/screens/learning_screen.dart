import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/learning_provider.dart';

class LearningScreen extends ConsumerWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);
    final totalHours = ref.watch(totalLearningHoursProvider);
    final certificates = ref.watch(certificatesEarnedProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl,
          ),
          children: [
            Text('Learning', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: AppSpacing.md),
            GlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('⏱️ ${totalHours.toStringAsFixed(0)}h', style: Theme.of(context).textTheme.titleLarge),
                      Text('hours studied', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  Column(
                    children: [
                      Text('🎓 $certificates', style: Theme.of(context).textTheme.titleLarge),
                      Text('certificates', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            coursesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const Text('Could not load courses.'),
              data: (courses) => Column(
                children: [
                  for (final course in courses) ...[
                    GlassCard(
                      gradientBorder: course.isComplete,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(course.title, style: Theme.of(context).textTheme.titleLarge),
                                    Text(course.subject, style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                              if (course.hasCertificate)
                                const Text('🎓', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            child: LinearProgressIndicator(
                              value: course.progress,
                              minHeight: 6,
                              backgroundColor: AppColors.darkBorder,
                              valueColor: const AlwaysStoppedAnimation(AppColors.areaLearning),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${course.hoursCompleted.toStringAsFixed(0)} / ${course.totalHours.toStringAsFixed(0)} hrs',
                            style: Theme.of(context).textTheme.bodyMedium,
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
    );
  }
}
