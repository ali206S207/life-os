import '../domain/daily_action.dart';

/// Abstraction over where daily actions come from, so the presentation
/// layer never depends on a concrete data source (local cache vs.
/// Supabase). A [SupabaseDailyActionsRepository] implementing this same
/// interface will be added in the Supabase-sync milestone.
abstract class DailyActionsRepository {
  Future<List<DailyAction>> fetchToday();
}

/// Local, offline-first implementation. Ships with a realistic seed list
/// so the dashboard is fully interactive out of the box; real persistence
/// (Hive cache + Supabase sync) plugs in behind this same interface.
class LocalDailyActionsRepository implements DailyActionsRepository {
  @override
  Future<List<DailyAction>> fetchToday() async {
    // Simulated latency to keep loading states real during development.
    await Future.delayed(const Duration(milliseconds: 300));

    return const [
      DailyAction(
        id: 'a1',
        title: 'Workout',
        emoji: '🏋️',
        xpReward: 20,
        time: '08:00',
        isDone: true,
        areaId: 'fitness',
      ),
      DailyAction(
        id: 'a2',
        title: 'Drink Water',
        emoji: '💧',
        xpReward: 5,
        time: '09:00',
        isDone: true,
        areaId: 'fitness',
      ),
      DailyAction(
        id: 'a3',
        title: 'Read',
        emoji: '📚',
        xpReward: 10,
        time: '10:00',
        isDone: true,
        areaId: 'learning',
      ),
      DailyAction(
        id: 'a4',
        title: 'Study',
        emoji: '🧠',
        xpReward: 15,
        time: '12:00',
        areaId: 'learning',
      ),
      DailyAction(
        id: 'a5',
        title: 'Walk',
        emoji: '🚶',
        xpReward: 10,
        time: '17:00',
        areaId: 'fitness',
      ),
      DailyAction(
        id: 'a6',
        title: 'Sleep 8h',
        emoji: '😴',
        xpReward: 10,
        time: '23:00',
        areaId: 'mental_health',
      ),
    ];
  }
}
