import 'package:equatable/equatable.dart';

class CalendarEvent extends Equatable {
  const CalendarEvent({
    required this.id,
    required this.title,
    required this.emoji,
    required this.date,
    required this.time,
  });

  final String id;
  final String title;
  final String emoji;
  final DateTime date; // date-only (year/month/day) for grouping
  final String time; // display string, e.g. "09:00"

  bool isSameDay(DateTime other) =>
      date.year == other.year && date.month == other.month && date.day == other.day;

  @override
  List<Object?> get props => [id, title, emoji, date, time];
}
