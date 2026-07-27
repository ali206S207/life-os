import 'package:equatable/equatable.dart';

enum Mood { happy, good, neutral, sad, angry, tired }

extension MoodMeta on Mood {
  String get emoji {
    switch (this) {
      case Mood.happy:
        return '😁';
      case Mood.good:
        return '🙂';
      case Mood.neutral:
        return '😐';
      case Mood.sad:
        return '😞';
      case Mood.angry:
        return '😡';
      case Mood.tired:
        return '😴';
    }
  }

  String get label {
    switch (this) {
      case Mood.happy:
        return 'Happy';
      case Mood.good:
        return 'Good';
      case Mood.neutral:
        return 'Neutral';
      case Mood.sad:
        return 'Sad';
      case Mood.angry:
        return 'Angry';
      case Mood.tired:
        return 'Tired';
    }
  }

  /// Numeric score so averages/comparisons are possible for insights.
  double get score {
    switch (this) {
      case Mood.happy:
        return 5;
      case Mood.good:
        return 4;
      case Mood.neutral:
        return 3;
      case Mood.tired:
        return 2.5;
      case Mood.sad:
        return 2;
      case Mood.angry:
        return 1;
    }
  }
}

/// One day's mood log, plus lightweight context (whether the user
/// worked out that day, hours slept, day of week) — this is exactly
/// the context the spec's "AI should identify patterns" insights are
/// derived from (e.g. "You are happier on workout days").
class MoodEntry extends Equatable {
  const MoodEntry({
    required this.date,
    required this.mood,
    required this.didWorkout,
    required this.sleepHours,
  });

  final DateTime date;
  final Mood mood;
  final bool didWorkout;
  final double sleepHours;

  @override
  List<Object?> get props => [date, mood, didWorkout, sleepHours];
}
