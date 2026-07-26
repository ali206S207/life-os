import 'package:equatable/equatable.dart';

/// A measurable system linked to a [Goal] (e.g. "Weight", "Calories",
/// "Workout" all feeding into a "Reach 70kg" goal). Updating a system's
/// current value is what actually moves the parent goal's progress —
/// goals themselves are never edited directly.
class LinkedSystem extends Equatable {
  const LinkedSystem({
    required this.id,
    required this.title,
    required this.emoji,
    required this.currentValue,
    required this.targetValue,
    required this.unit,
    this.weight = 1.0,
  });

  final String id;
  final String title;
  final String emoji;
  final double currentValue;
  final double targetValue;
  final String unit;

  /// Relative contribution of this system to the parent goal's overall
  /// progress (systems don't have to weigh equally — e.g. "Calories"
  /// might matter more than "Water" for a weight goal).
  final double weight;

  /// 0.0–1.0 progress of this system alone.
  double get progress {
    if (targetValue == 0) return 0;
    final p = currentValue / targetValue;
    return p.clamp(0.0, 1.0);
  }

  @override
  List<Object?> get props => [id, title, emoji, currentValue, targetValue, unit, weight];
}

/// A user goal (e.g. "Reach 70kg"). Progress is *derived* from its
/// linked systems, never set directly — this is what the spec means by
/// "every update should automatically affect the goal progress".
class Goal extends Equatable {
  const Goal({
    required this.id,
    required this.title,
    required this.emoji,
    required this.areaId,
    required this.linkedSystems,
    this.deadline,
  });

  final String id;
  final String title;
  final String emoji;
  final String areaId;
  final List<LinkedSystem> linkedSystems;
  final DateTime? deadline;

  /// Weighted average progress across all linked systems.
  double get progress {
    if (linkedSystems.isEmpty) return 0;
    final totalWeight = linkedSystems.fold<double>(0, (s, e) => s + e.weight);
    if (totalWeight == 0) return 0;
    final weighted = linkedSystems.fold<double>(
      0,
      (sum, s) => sum + (s.progress * s.weight),
    );
    return (weighted / totalWeight).clamp(0.0, 1.0);
  }

  Goal copyWithSystem(LinkedSystem updated) {
    return Goal(
      id: id,
      title: title,
      emoji: emoji,
      areaId: areaId,
      deadline: deadline,
      linkedSystems: [
        for (final s in linkedSystems)
          if (s.id == updated.id) updated else s,
      ],
    );
  }

  @override
  List<Object?> get props => [id, title, emoji, areaId, linkedSystems, deadline];
}
