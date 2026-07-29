import '../domain/goal.dart';

abstract class GoalsRepository {
  Future<List<Goal>> fetchGoals();

  /// Persists one linked system's updated current value. The Local
  /// implementation no-ops; the Supabase implementation writes it back.
  Future<void> persistSystemValue(String systemId, double newValue);
}

class LocalGoalsRepository implements GoalsRepository {
  @override
  Future<List<Goal>> fetchGoals() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return seedGoals();
  }

  @override
  Future<void> persistSystemValue(String systemId, double newValue) async {
    // No-op for the local/offline implementation.
  }

  /// Shared seed data — also used by [SupabaseGoalsRepository] to
  /// populate a brand-new account's first sign-in with starter goals.
  static List<Goal> seedGoals() {
    return const [
      Goal(
        id: 'g1',
        title: 'Reach 70 kg',
        emoji: '⚖️',
        areaId: 'fitness',
        linkedSystems: [
          LinkedSystem(
            id: 's1',
            title: 'Weight',
            emoji: '⚖️',
            currentValue: 74,
            targetValue: 70,
            unit: 'kg',
            weight: 1.5,
          ),
          LinkedSystem(
            id: 's2',
            title: 'Calories',
            emoji: '🔥',
            currentValue: 2100,
            targetValue: 2000,
            unit: 'kcal/day',
            weight: 1.2,
          ),
          LinkedSystem(
            id: 's3',
            title: 'Workout',
            emoji: '🏋️',
            currentValue: 4,
            targetValue: 5,
            unit: 'sessions/wk',
            weight: 1.0,
          ),
          LinkedSystem(
            id: 's4',
            title: 'Protein',
            emoji: '🥩',
            currentValue: 110,
            targetValue: 140,
            unit: 'g/day',
            weight: 0.8,
          ),
          LinkedSystem(
            id: 's5',
            title: 'Sleep',
            emoji: '😴',
            currentValue: 6.5,
            targetValue: 8,
            unit: 'hrs/night',
            weight: 0.6,
          ),
          LinkedSystem(
            id: 's6',
            title: 'Water',
            emoji: '💧',
            currentValue: 2.2,
            targetValue: 3,
            unit: 'L/day',
            weight: 0.4,
          ),
        ],
      ),
      Goal(
        id: 'g2',
        title: 'Finish Flutter Course',
        emoji: '📚',
        areaId: 'learning',
        linkedSystems: [
          LinkedSystem(
            id: 's7',
            title: 'Study Hours',
            emoji: '🧠',
            currentValue: 18,
            targetValue: 40,
            unit: 'hrs',
            weight: 1.0,
          ),
          LinkedSystem(
            id: 's8',
            title: 'Projects Built',
            emoji: '🛠️',
            currentValue: 1,
            targetValue: 3,
            unit: 'projects',
            weight: 1.0,
          ),
        ],
      ),
    ];
  }
}
