import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mood_repository.dart';
import '../../domain/mood_entry.dart';
import '../../domain/mood_insights_generator.dart';

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return LocalMoodRepository();
});

class MoodHistoryNotifier extends AsyncNotifier<List<MoodEntry>> {
  @override
  Future<List<MoodEntry>> build() {
    return ref.read(moodRepositoryProvider).fetchHistory();
  }

  Future<void> logToday(Mood mood) async {
    await ref.read(moodRepositoryProvider).logToday(mood);
    state = await AsyncValue.guard(() => ref.read(moodRepositoryProvider).fetchHistory());
  }
}

final moodHistoryProvider = AsyncNotifierProvider<MoodHistoryNotifier, List<MoodEntry>>(
  MoodHistoryNotifier.new,
);

/// Today's logged mood, if any — drives which emoji shows as "selected"
/// in the picker.
final todayMoodProvider = Provider<Mood?>((ref) {
  final history = ref.watch(moodHistoryProvider).value ?? [];
  final today = DateTime.now();
  for (final entry in history) {
    if (entry.date.year == today.year &&
        entry.date.month == today.month &&
        entry.date.day == today.day) {
      return entry.mood;
    }
  }
  return null;
});

final moodInsightsProvider = Provider<List<String>>((ref) {
  final history = ref.watch(moodHistoryProvider).value ?? [];
  return MoodInsightsGenerator.generate(history);
});
