import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/goal.dart';
import 'goals_repository.dart';

/// Real persistence for Goals + their linked Systems, backed by the
/// `lifeos_goals` / `lifeos_linked_systems` tables. On a brand-new
/// account with no rows yet, seeds the same starter goals the
/// local/offline build used.
class SupabaseGoalsRepository implements GoalsRepository {
  SupabaseGoalsRepository(this._client);

  final SupabaseClient _client;

  String get _userId => _client.auth.currentUser!.id;

  @override
  Future<List<Goal>> fetchGoals() async {
    final goalRows = await _client.from('lifeos_goals').select().eq('user_id', _userId);
    if ((goalRows as List).isEmpty) {
      await _seedDefaults();
      return fetchGoals();
    }

    final goals = <Goal>[];
    for (final row in goalRows) {
      final goalMap = row as Map<String, dynamic>;
      final systemRows = await _client
          .from('lifeos_linked_systems')
          .select()
          .eq('goal_id', goalMap['id'] as String);

      goals.add(Goal(
        id: goalMap['id'] as String,
        title: goalMap['title'] as String,
        emoji: goalMap['emoji'] as String,
        areaId: goalMap['area_key'] as String,
        linkedSystems: [
          for (final s in systemRows as List)
            LinkedSystem(
              id: (s as Map<String, dynamic>)['id'] as String,
              title: s['title'] as String,
              emoji: s['emoji'] as String,
              currentValue: (s['current_value'] as num).toDouble(),
              targetValue: (s['target_value'] as num).toDouble(),
              unit: s['unit'] as String,
              weight: (s['weight'] as num).toDouble(),
            ),
        ],
      ));
    }
    return goals;
  }

  Future<void> _seedDefaults() async {
    for (final goal in LocalGoalsRepository.seedGoals()) {
      final inserted = await _client
          .from('lifeos_goals')
          .insert({
            'user_id': _userId,
            'title': goal.title,
            'emoji': goal.emoji,
            'area_key': goal.areaId,
          })
          .select()
          .single();

      final goalId = inserted['id'] as String;

      await _client.from('lifeos_linked_systems').insert([
        for (final system in goal.linkedSystems)
          {
            'goal_id': goalId,
            'title': system.title,
            'emoji': system.emoji,
            'current_value': system.currentValue,
            'target_value': system.targetValue,
            'unit': system.unit,
            'weight': system.weight,
          },
      ]);
    }
  }

  @override
  Future<void> persistSystemValue(String systemId, double newValue) async {
    await _client
        .from('lifeos_linked_systems')
        .update({'current_value': newValue}).eq('id', systemId);
  }
}
