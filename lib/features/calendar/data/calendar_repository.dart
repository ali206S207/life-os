import '../domain/calendar_event.dart';

abstract class CalendarRepository {
  Future<List<CalendarEvent>> fetchEvents();
}

class LocalCalendarRepository implements CalendarRepository {
  @override
  Future<List<CalendarEvent>> fetchEvents() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    DateTime day(int offset) => DateTime(now.year, now.month, now.day + offset);

    return [
      CalendarEvent(id: 'e1', title: 'Morning Workout', emoji: '🏋️', date: day(0), time: '08:00'),
      CalendarEvent(id: 'e2', title: 'Client call', emoji: '💼', date: day(0), time: '14:00'),
      CalendarEvent(id: 'e3', title: 'Study session', emoji: '🧠', date: day(1), time: '10:00'),
      CalendarEvent(id: 'e4', title: 'Gym check-ins review', emoji: '💪', date: day(2), time: '17:00'),
      CalendarEvent(id: 'e5', title: 'Supplements restock', emoji: '💊', date: day(3), time: '11:00'),
      CalendarEvent(id: 'e6', title: 'Weekly review', emoji: '📝', date: day(6), time: '20:00'),
      CalendarEvent(id: 'e7', title: 'Project deadline', emoji: '🚀', date: day(10), time: '18:00'),
    ];
  }
}
