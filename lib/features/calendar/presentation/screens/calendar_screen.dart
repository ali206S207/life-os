import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/calendar_event.dart';
import '../providers/calendar_provider.dart';
import '../widgets/month_grid.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDateProvider);
    final dayEvents = ref.watch(selectedDayEventsProvider);
    final eventsAsync = ref.watch(calendarEventsProvider);

    return Scaffold(
      body: SafeArea(
        child: eventsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => const Center(child: Text('Could not load calendar.')),
          data: (_) => ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl,
            ),
            children: [
              Text('Calendar', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: AppSpacing.md),
              GlassCard(
                child: Column(
                  children: [
                    Text(
                      '${_monthNames[selected.month - 1]} ${selected.year}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    MonthGrid(month: selected),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '${_monthNames[selected.month - 1]} ${selected.day}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Drag an event onto another day to reschedule it.',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              if (dayEvents.isEmpty)
                GlassCard(
                  child: Text('No events today.', style: Theme.of(context).textTheme.bodyMedium),
                )
              else
                for (final event in dayEvents) ...[
                  Draggable<CalendarEvent>(
                    data: event,
                    feedback: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: 220,
                        child: _EventTile(event: event, elevated: true),
                      ),
                    ),
                    childWhenDragging: Opacity(opacity: 0.3, child: _EventTile(event: event)),
                    child: _EventTile(event: event),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event, this.elevated = false});

  final CalendarEvent event;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      gradientBorder: elevated,
      child: Row(
        children: [
          Text(event.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(event.title, style: Theme.of(context).textTheme.titleMedium),
          ),
          Text(event.time, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
