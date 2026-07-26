import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/life_area.dart';

/// Abstraction over where Life Areas come from. A Supabase-backed
/// implementation will be added in the Supabase Sync milestone, behind
/// this same interface — presentation code never changes.
abstract class LifeAreasRepository {
  Future<List<LifeArea>> fetchAreas();
}

class LocalLifeAreasRepository implements LifeAreasRepository {
  @override
  Future<List<LifeArea>> fetchAreas() async {
    await Future.delayed(const Duration(milliseconds: 250));

    return const [
      LifeArea(
        id: 'fitness',
        title: 'Fitness',
        emoji: '🏋',
        color: AppColors.areaFitness,
        progress: 0.8,
        xp: 420,
        level: 4,
        currentStreak: 12,
        activeGoalsCount: 2,
      ),
      LifeArea(
        id: 'learning',
        title: 'Learning',
        emoji: '📚',
        color: AppColors.areaLearning,
        progress: 0.55,
        xp: 260,
        level: 3,
        currentStreak: 5,
        activeGoalsCount: 1,
      ),
      LifeArea(
        id: 'career',
        title: 'Career',
        emoji: '💼',
        color: AppColors.areaCareer,
        progress: 0.4,
        xp: 180,
        level: 2,
        currentStreak: 0,
        activeGoalsCount: 3,
      ),
      LifeArea(
        id: 'finance',
        title: 'Finance',
        emoji: '💰',
        color: AppColors.areaFinance,
        progress: 0.65,
        xp: 310,
        level: 3,
        currentStreak: 8,
        activeGoalsCount: 1,
      ),
      LifeArea(
        id: 'relationships',
        title: 'Relationships',
        emoji: '❤️',
        color: AppColors.areaRelationships,
        progress: 0.5,
        xp: 150,
        level: 2,
        currentStreak: 3,
        activeGoalsCount: 0,
      ),
      LifeArea(
        id: 'mental_health',
        title: 'Mental Health',
        emoji: '🧠',
        color: AppColors.areaMentalHealth,
        progress: 0.7,
        xp: 300,
        level: 3,
        currentStreak: 6,
        activeGoalsCount: 1,
      ),
      LifeArea(
        id: 'spiritual',
        title: 'Spiritual',
        emoji: '🕌',
        color: AppColors.areaSpiritual,
        progress: 0.9,
        xp: 500,
        level: 5,
        currentStreak: 20,
        activeGoalsCount: 1,
      ),
      LifeArea(
        id: 'fun',
        title: 'Fun',
        emoji: '🎮',
        color: AppColors.areaFun,
        progress: 0.3,
        xp: 90,
        level: 1,
        currentStreak: 1,
        activeGoalsCount: 0,
      ),
    ];
  }
}
