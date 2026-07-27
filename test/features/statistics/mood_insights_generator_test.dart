import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/features/statistics/domain/mood_entry.dart';
import 'package:life_os/features/statistics/domain/mood_insights_generator.dart';

void main() {
  group('MoodInsightsGenerator', () {
    test('returns no insights with too little history', () {
      final history = [
        MoodEntry(date: DateTime(2026, 1, 1), mood: Mood.good, didWorkout: true, sleepHours: 7),
      ];
      expect(MoodInsightsGenerator.generate(history), isEmpty);
    });

    test('detects workout-day happiness correlation', () {
      final history = List.generate(10, (i) {
        final workout = i.isEven;
        return MoodEntry(
          date: DateTime(2026, 1, i + 1),
          mood: workout ? Mood.happy : Mood.neutral,
          didWorkout: workout,
          sleepHours: 7,
        );
      });

      final insights = MoodInsightsGenerator.generate(history);
      expect(insights, contains('You are happier on workout days.'));
    });

    test('detects low-sleep tiredness correlation', () {
      final history = List.generate(10, (i) {
        final underSlept = i.isEven;
        return MoodEntry(
          date: DateTime(2026, 1, i + 1),
          mood: underSlept ? Mood.sad : Mood.happy,
          didWorkout: false,
          sleepHours: underSlept ? 5 : 8,
        );
      });

      final insights = MoodInsightsGenerator.generate(history);
      expect(insights, contains('You feel tired after sleeping less than 6 hours.'));
    });
  });
}
