import '../domain/mood_entry.dart';

/// Derives simple, honest pattern insights from mood history — the
/// spec's "the AI should identify patterns" behavior. Kept as pure
/// functions over data (no LLM call needed for these correlations),
/// so results are deterministic and unit-testable.
class MoodInsightsGenerator {
  const MoodInsightsGenerator._();

  static List<String> generate(List<MoodEntry> history) {
    if (history.length < 5) return const [];

    final insights = <String>[];

    final workoutDays = history.where((e) => e.didWorkout).toList();
    final restDays = history.where((e) => !e.didWorkout).toList();
    if (workoutDays.isNotEmpty && restDays.isNotEmpty) {
      final workoutAvg = _avgScore(workoutDays);
      final restAvg = _avgScore(restDays);
      if (workoutAvg - restAvg >= 0.4) {
        insights.add('You are happier on workout days.');
      }
    }

    final wellSlept = history.where((e) => e.sleepHours >= 7).toList();
    final underSlept = history.where((e) => e.sleepHours < 6).toList();
    if (underSlept.isNotEmpty) {
      final underSleptAvg = _avgScore(underSlept);
      final wellSleptAvg = wellSlept.isNotEmpty ? _avgScore(wellSlept) : underSleptAvg;
      if (wellSleptAvg - underSleptAvg >= 0.4) {
        insights.add('You feel tired after sleeping less than 6 hours.');
      }
    }

    final byWeekday = <int, List<MoodEntry>>{};
    for (final entry in history) {
      byWeekday.putIfAbsent(entry.date.weekday, () => []).add(entry);
    }
    if (byWeekday.length >= 4) {
      final bestWeekday = byWeekday.entries.reduce(
        (a, b) => _avgScore(a.value) >= _avgScore(b.value) ? a : b,
      );
      insights.add('You tend to feel best on ${_weekdayName(bestWeekday.key)}s.');
    }

    return insights;
  }

  static double _avgScore(List<MoodEntry> entries) {
    if (entries.isEmpty) return 0;
    return entries.fold<double>(0, (sum, e) => sum + e.mood.score) / entries.length;
  }

  static String _weekdayName(int weekday) {
    const names = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
    ];
    return names[(weekday - 1) % 7];
  }
}
