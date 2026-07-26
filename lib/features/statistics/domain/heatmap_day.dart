import 'package:equatable/equatable.dart';

/// Intensity levels for a single day in a heatmap — matches the spec's
/// "Green = Excellent, Yellow = Average, Gray = Missed" scale, with an
/// extra "none" state for days with no data at all (e.g. before the
/// user started tracking).
enum HeatLevel { none, missed, average, excellent }

class HeatmapDay extends Equatable {
  const HeatmapDay({required this.date, required this.level});

  final DateTime date;
  final HeatLevel level;

  @override
  List<Object?> get props => [date, level];
}

/// A trackable metric the heatmap can switch between.
enum HeatmapMetric { workout, study, habits, sleep, water, mood }

extension HeatmapMetricLabel on HeatmapMetric {
  String get label {
    switch (this) {
      case HeatmapMetric.workout:
        return 'Workout';
      case HeatmapMetric.study:
        return 'Study';
      case HeatmapMetric.habits:
        return 'Habits';
      case HeatmapMetric.sleep:
        return 'Sleep';
      case HeatmapMetric.water:
        return 'Water';
      case HeatmapMetric.mood:
        return 'Mood';
    }
  }
}
