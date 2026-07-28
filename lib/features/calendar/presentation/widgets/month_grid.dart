import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/calendar_event.dart';
import '../providers/calendar_provider.dart';

class MonthGrid extends ConsumerWidget {
  const MonthGrid({super.key, required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(calendarEventsProvider).value ?? [];
    final selected = ref.watch(selectedDateProvider);

    final firstOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingBlanks = firstOfMonth.weekday % 7; // Sunday-start grid

    final cells = <DateTime?>[
      for (int i = 0; i < leadingBlanks; i++) null,
      for (int d = 1; d <= daysInMonth; d++) DateTime(month.year, month.month, d),
    ];

    return Column(
      children: [
        Row(
          children: [
            for (final label in const ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
              Expanded(
                child: Center(
                  child: Text(label, style: Theme.of(context).textTheme.labelSmall),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final date in cells)
              if (date == null)
                const SizedBox.shrink()
              else
                _DayCell(
                  date: date,
                  isSelected: _isSameDay(date, selected),
                  isToday: _isSameDay(date, DateTime.now()),
                  eventCount: events.where((e) => e.isSameDay(date)).length,
                ),
          ],
        ),
      ],
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayCell extends ConsumerWidget {
  const _DayCell({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.eventCount,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final int eventCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DragTarget<CalendarEvent>(
      onAcceptWithDetails: (details) =>
          ref.read(calendarEventsProvider.notifier).rescheduleEvent(details.data.id, date),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return GestureDetector(
          onTap: () => ref.read(selectedDateProvider.notifier).select(date),
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isHovering
                  ? AppColors.primary.withOpacity(0.25)
                  : isSelected
                      ? AppColors.primary
                      : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday && !isSelected
                  ? Border.all(color: AppColors.primary)
                  : null,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${date.day}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
                if (eventCount > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
