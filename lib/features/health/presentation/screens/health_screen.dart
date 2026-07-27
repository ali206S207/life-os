import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/health_provider.dart';
import '../widgets/sparkline.dart';

class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsync = ref.watch(todayHealthProvider);
    final weightHistoryAsync = ref.watch(weightHistoryProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl,
          ),
          children: [
            Text('Health', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: AppSpacing.md),
            healthAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => const Text('Could not load health data.'),
              data: (snapshot) => Column(
                children: [
                  GlassCard(
                    gradientBorder: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Weight Trend', style: Theme.of(context).textTheme.titleMedium),
                            Text(
                              '${snapshot.weightKg.toStringAsFixed(1)} kg',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        weightHistoryAsync.when(
                          loading: () => const SizedBox(height: 60),
                          error: (e, _) => const SizedBox.shrink(),
                          data: (history) => Sparkline(values: history),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'BMI ${snapshot.bmi.toStringAsFixed(1)} · ${snapshot.bmiCategory}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.5,
                    children: [
                      _MetricTile(emoji: '🔥', label: 'Calories', value: '${snapshot.calories}', unit: 'kcal'),
                      _MetricTile(emoji: '🥩', label: 'Protein', value: snapshot.proteinGrams.toStringAsFixed(0), unit: 'g'),
                      _MetricTile(emoji: '💧', label: 'Water', value: snapshot.waterLiters.toStringAsFixed(1), unit: 'L'),
                      _MetricTile(emoji: '😴', label: 'Sleep', value: snapshot.sleepHours.toStringAsFixed(1), unit: 'hrs'),
                      _MetricTile(emoji: '👣', label: 'Steps', value: '${snapshot.steps}', unit: 'steps'),
                      _MetricTile(emoji: '📸', label: 'Progress Photos', value: '—', unit: 'coming soon'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.emoji,
    required this.label,
    required this.value,
    required this.unit,
  });

  final String emoji;
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(unit, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
