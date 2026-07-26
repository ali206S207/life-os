import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/heatmap_day.dart';

/// Renders [days] as a GitHub-style contribution grid: one column per
/// week, one cell per day, colored by [HeatLevel]. Scrolls horizontally
/// so long histories don't get squeezed.
class HeatmapGrid extends StatelessWidget {
  const HeatmapGrid({super.key, required this.days, this.cellSize = 14});

  final List<HeatmapDay> days;
  final double cellSize;

  Color _colorFor(HeatLevel level) {
    switch (level) {
      case HeatLevel.none:
        return AppColors.darkSurfaceElevated;
      case HeatLevel.missed:
        return AppColors.darkBorder;
      case HeatLevel.average:
        return AppColors.warning.withOpacity(0.55);
      case HeatLevel.excellent:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Group days into weeks (columns of 7), left-padded so the grid
    // starts on a Sunday like GitHub's.
    final leadingEmptyDays = days.isEmpty ? 0 : days.first.date.weekday % 7;
    final padded = [
      for (int i = 0; i < leadingEmptyDays; i++)
        HeatmapDay(date: days.first.date.subtract(Duration(days: leadingEmptyDays - i)), level: HeatLevel.none),
      ...days,
    ];
    final weekCount = (padded.length / 7).ceil();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int w = 0; w < weekCount; w++)
            Padding(
              padding: const EdgeInsets.only(right: 3),
              child: Column(
                children: [
                  for (int d = 0; d < 7; d++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Builder(builder: (context) {
                        final index = w * 7 + d;
                        final day = index < padded.length ? padded[index] : null;
                        return Tooltip(
                          message: day == null
                              ? ''
                              : '${day.date.year}-${day.date.month.toString().padLeft(2, '0')}-${day.date.day.toString().padLeft(2, '0')}',
                          child: Container(
                            width: cellSize,
                            height: cellSize,
                            decoration: BoxDecoration(
                              color: day == null ? Colors.transparent : _colorFor(day.level),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Small legend explaining the color scale, shown under the grid.
class HeatmapLegend extends StatelessWidget {
  const HeatmapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    Widget swatch(Color color) => Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Missed', style: Theme.of(context).textTheme.labelSmall),
        swatch(AppColors.darkBorder),
        swatch(AppColors.warning.withOpacity(0.55)),
        swatch(AppColors.success),
        Text('Excellent', style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
