import 'dart:math';
import '../domain/mood_entry.dart';

abstract class MoodRepository {
  Future<List<MoodEntry>> fetchHistory({int days = 21});
  Future<MoodEntry> logToday(Mood mood);
}

/// Local implementation. Seeds a history where mood is intentionally
/// correlated with workouts and sleep, so the generated insights have
/// something real to find — a Supabase-backed repository will replace
/// this with actual logged data behind the same interface.
class LocalMoodRepository implements MoodRepository {
  final List<MoodEntry> _history = _seed();

  static List<MoodEntry> _seed() {
    final random = Random(42);
    final today = DateTime.now();
    return List.generate(21, (i) {
      final date = today.subtract(Duration(days: 20 - i));
      final didWorkout = random.nextDouble() < 0.5;
      final sleepHours = 5.5 + random.nextDouble() * 3.5;

      // Bias mood upward on workout days and on well-slept nights, so
      // the correlation insights below are meaningfully true.
      double score = 2.5 + random.nextDouble() * 1.5;
      if (didWorkout) score += 1.0;
      if (sleepHours >= 7) score += 0.7;

      final mood = _moodFromScore(score);
      return MoodEntry(date: date, mood: mood, didWorkout: didWorkout, sleepHours: sleepHours);
    });
  }

  static Mood _moodFromScore(double score) {
    if (score >= 4.5) return Mood.happy;
    if (score >= 3.5) return Mood.good;
    if (score >= 2.8) return Mood.neutral;
    if (score >= 2.2) return Mood.tired;
    if (score >= 1.5) return Mood.sad;
    return Mood.angry;
  }

  @override
  Future<List<MoodEntry>> fetchHistory({int days = 21}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_history);
  }

  @override
  Future<MoodEntry> logToday(Mood mood) async {
    final today = DateTime.now();
    final entry = MoodEntry(
      date: DateTime(today.year, today.month, today.day),
      mood: mood,
      didWorkout: false,
      sleepHours: 7,
    );
    _history
      ..removeWhere((e) =>
          e.date.year == entry.date.year &&
          e.date.month == entry.date.month &&
          e.date.day == entry.date.day)
      ..add(entry);
    return entry;
  }
}
