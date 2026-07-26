import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/heatmap_day.dart';
import '../providers/heatmap_provider.dart';
import '../widgets/heatmap_grid.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMetric = ref.watch(selectedHeatmapMetricProvider);
    final historyAsync = ref.watch(heatmapHistoryProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl,
          ),
          children: [
            Text('Statistics', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: HeatmapMetric.values.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final metric = HeatmapMetric.values[i];
                  final selected = metric == selectedMetric;
                  return ChoiceChip(
                    label: Text(metric.label),
                    selected: selected,
                    onSelected: (_) =>
                        ref.read(selectedHeatmapMetricProvider.notifier).select(metric),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.darkSurfaceElevated,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(color: AppColors.darkBorder),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            GlassCard(
              child: historyAsync.when(
                loading: () => const SizedBox(
                  height: 140,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => const Text('Could not load heatmap.'),
                data: (days) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${selectedMetric.label} · last ${days.length} days',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    HeatmapGrid(days: days),
                    const SizedBox(height: AppSpacing.sm),
                    const HeatmapLegend(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
