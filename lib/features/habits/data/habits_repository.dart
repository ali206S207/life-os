import '../domain/habit.dart';

abstract class HabitsRepository {
  Future<List<Habit>> fetchHabits();

  /// Persists a single habit's updated streak/done state. The Local
  /// implementation no-ops (state already lives in the Notifier); the
  /// Supabase implementation writes the row back.
  Future<void> persistToggle(Habit habit);

  /// Creates a brand-new habit and returns it with its real id
  /// (server-generated for Supabase).
  Future<Habit> createHabit({
    required String title,
    required String emoji,
    required String areaId,
    required HabitDifficulty difficulty,
    required int xpReward,
  });
}

class LocalHabitsRepository implements HabitsRepository {
  @override
  Future<List<Habit>> fetchHabits() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return seedHabits();
  }

  @override
  Future<void> persistToggle(Habit habit) async {
    // No-op: state already lives in the Notifier for the local/offline
    // implementation. The Supabase implementation overrides this to
    // actually write the row back.
  }

  @override
  Future<Habit> createHabit({
    required String title,
    required String emoji,
    required String areaId,
    required HabitDifficulty difficulty,
    required int xpReward,
  }) async {
    return Habit(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      emoji: emoji,
      areaId: areaId,
      difficulty: difficulty,
      xpReward: xpReward,
      currentStreak: 0,
      bestStreak: 0,
      completionRate: 0,
      missHistory: const [],
    );
  }

  /// Shared seed data — also used by [SupabaseHabitsRepository] to
  /// populate a brand-new account's first sign-in with starter habits.
  static List<Habit> seedHabits() {
    final now = DateTime.now();

    return [
      Habit(
        id: 'h1',
        title: 'Drink Water',
        emoji: '💧',
        areaId: 'fitness',
        difficulty: HabitDifficulty.easy,
        xpReward: 5,
        currentStreak: 12,
        bestStreak: 21,
        completionRate: 0.92,
        isDoneToday: true,
        missHistory: [now.subtract(const Duration(days: 15))],
      ),
      Habit(
        id: 'h2',
        title: 'Read 20 pages',
        emoji: '📚',
        areaId: 'learning',
        difficulty: HabitDifficulty.medium,
        xpReward: 10,
        currentStreak: 5,
        bestStreak: 30,
        completionRate: 0.7,
        isDoneToday: true,
        missHistory: [
          now.subtract(const Duration(days: 3)),
          now.subtract(const Duration(days: 9)),
        ],
      ),
      Habit(
        id: 'h3',
        title: 'Morning Workout',
        emoji: '🏋️',
        areaId: 'fitness',
        difficulty: HabitDifficulty.hard,
        xpReward: 20,
        currentStreak: 0,
        bestStreak: 14,
        completionRate: 0.55,
        isDoneToday: false,
        missHistory: [now.subtract(const Duration(days: 1))],
      ),
      Habit(
        id: 'h4',
        title: 'Meditate 10 min',
        emoji: '🧘',
        areaId: 'mental_health',
        difficulty: HabitDifficulty.medium,
        xpReward: 10,
        currentStreak: 6,
        bestStreak: 6,
        completionRate: 0.8,
        isDoneToday: false,
        missHistory: const [],
      ),
      Habit(
        id: 'h5',
        title: 'No Sugar',
        emoji: '🍬',
        areaId: 'fitness',
        difficulty: HabitDifficulty.hard,
        xpReward: 15,
        currentStreak: 3,
        bestStreak: 10,
        completionRate: 0.6,
        isDoneToday: false,
        missHistory: [now.subtract(const Duration(days: 4))],
      ),
    ];
  }
}
