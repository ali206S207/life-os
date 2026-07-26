import 'package:equatable/equatable.dart';

/// A single actionable item for "today" shown on the dashboard timeline
/// and progress ring (e.g. "Workout", "Drink Water", "Study").
class DailyAction extends Equatable {
  const DailyAction({
    required this.id,
    required this.title,
    required this.emoji,
    required this.xpReward,
    required this.time,
    this.isDone = false,
    this.areaId,
  });

  final String id;
  final String title;
  final String emoji;
  final int xpReward;
  final String time; // e.g. "08:00" — display string for the timeline
  final bool isDone;
  final String? areaId;

  DailyAction copyWith({bool? isDone}) {
    return DailyAction(
      id: id,
      title: title,
      emoji: emoji,
      xpReward: xpReward,
      time: time,
      isDone: isDone ?? this.isDone,
      areaId: areaId,
    );
  }

  @override
  List<Object?> get props => [id, title, emoji, xpReward, time, isDone, areaId];
}
