import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/calendar_repository.dart';
import '../../domain/calendar_event.dart';

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return LocalCalendarRepository();
});

class CalendarEventsNotifier extends AsyncNotifier<List<CalendarEvent>> {
  @override
  Future<List<CalendarEvent>> build() {
    return ref.read(calendarRepositoryProvider).fetchEvents();
  }

  /// Moves an event to a new date — this is the "drag & drop, auto
  /// reorganize" behavior from the spec, exposed here as a data
  /// operation the Calendar screen's drag target calls.
  void rescheduleEvent(String eventId, DateTime newDate) {
    state.whenData((events) {
      state = AsyncValue.data([
        for (final event in events)
          if (event.id == eventId)
            CalendarEvent(
              id: event.id,
              title: event.title,
              emoji: event.emoji,
              date: DateTime(newDate.year, newDate.month, newDate.day),
              time: event.time,
            )
          else
            event,
      ]);
    });
  }
}

final calendarEventsProvider =
    AsyncNotifierProvider<CalendarEventsNotifier, List<CalendarEvent>>(
  CalendarEventsNotifier.new,
);

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void select(DateTime date) => state = DateTime(date.year, date.month, date.day);
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(
  SelectedDateNotifier.new,
);

/// Events for the currently selected day, for the agenda panel.
final selectedDayEventsProvider = Provider<List<CalendarEvent>>((ref) {
  final events = ref.watch(calendarEventsProvider).value ?? [];
  final selected = ref.watch(selectedDateProvider);
  return events.where((e) => e.isSameDay(selected)).toList()
    ..sort((a, b) => a.time.compareTo(b.time));
});
