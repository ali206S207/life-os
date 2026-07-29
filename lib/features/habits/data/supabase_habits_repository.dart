import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/habit.dart';
import 'habits_repository.dart';

/// Real persistence for Habits, backed by the `lifeos_habits` table
/// (owner-only RLS via `user_id = auth.uid()`). On a brand-new account
/// with no rows yet, seeds the same starter habits the local/offline
/// build used, so first sign-in isn't an empty screen.
class SupabaseHabitsRepository implements HabitsRepository {
  SupabaseHabitsRepository(this._client);

  final SupabaseClient _client;

  String get _userId => _client.auth.currentUser!.id;

  Habit _fromRow(Map<String, dynamic> row) {
    return Habit(
      id: row['id'] as String,
      title: row['title'] as String,
      emoji: row['emoji'] as String,
      areaId: row['area_key'] as String,
      difficulty: HabitDifficulty.values.firstWhere(
        (d) => d.name == row['difficulty'],
        orElse: () => HabitDifficulty.medium,
      ),
      xpReward: row['xp_reward'] as int,
      currentStreak: row['current_streak'] as int,
      bestStreak: row['best_streak'] as int,
      completionRate: 0.7, // TODO(life-os): derive from a completion-history table.
      isDoneToday: row['is_done_today'] as bool,
      missHistory: const [], // TODO(life-os): backed by a future habit_logs table.
    );
  }

  @override
  Future<List<Habit>> fetchHabits() async {
    final rows = await _client.from('lifeos_habits').select().eq('user_id', _userId);
    if ((rows as List).isEmpty) {
      await _seedDefaults();
      final reseeded = await _client.from('lifeos_habits').select().eq('user_id', _userId);
      return (reseeded as List).map((r) => _fromRow(r as Map<String, dynamic>)).toList();
    }
    return rows.map((r) => _fromRow(r as Map<String, dynamic>)).toList();
  }

  Future<void> _seedDefaults() async {
    final seed = LocalHabitsRepository.seedHabits();
    await _client.from('lifeos_habits').insert([
      for (final habit in seed)
        {
          'user_id': _userId,
          'title': habit.title,
          'emoji': habit.emoji,
          'area_key': habit.areaId,
          'difficulty': habit.difficulty.name,
          'xp_reward': habit.xpReward,
          'current_streak': habit.currentStreak,
          'best_streak': habit.bestStreak,
          'is_done_today': habit.isDoneToday,
        },
    ]);
  }

  @override
  Future<void> persistToggle(Habit habit) async {
    await _client.from('lifeos_habits').update({
      'is_done_today': habit.isDoneToday,
      'current_streak': habit.currentStreak,
      'best_streak': habit.bestStreak,
      'last_toggled_date': DateTime.now().toIso8601String().split('T').first,
    }).eq('id', habit.id).eq('user_id', _userId);
  }

  @override
  Future<Habit> createHabit({
    required String title,
    required String emoji,
    required String areaId,
    required HabitDifficulty difficulty,
    required int xpReward,
  }) async {
    final row = await _client
        .from('lifeos_habits')
        .insert({
          'user_id': _userId,
          'title': title,
          'emoji': emoji,
          'area_key': areaId,
          'difficulty': difficulty.name,
          'xp_reward': xpReward,
          'current_streak': 0,
          'best_streak': 0,
          'is_done_today': false,
        })
        .select()
        .single();
    return _fromRow(row);
  }
}
