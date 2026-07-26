import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/providers/daily_actions_provider.dart';
import '../../../habits/presentation/providers/habits_provider.dart';
import '../domain/xp_level_calculator.dart';

/// Lifetime XP banked from *previous* days (i.e. everything before today).
/// A real backend would persist this via Supabase/Hive; for now it's a
/// simple in-memory notifier seeded with a realistic starting value so
/// the level system has something to build on immediately.
class BankedXpNotifier extends Notifier<int> {
  @override
  int build() => 1240;

  void addToBank(int xp) => state += xp;
}

final bankedXpProvider = NotifierProvider<BankedXpNotifier, int>(BankedXpNotifier.new);

/// Total lifetime XP = banked XP + everything earned today across
/// features (Dashboard actions + Habits). Adding a new XP-earning
/// feature later just means adding its "today" provider to this sum.
final totalXpProvider = Provider<int>((ref) {
  final banked = ref.watch(bankedXpProvider);
  final actionsXp = ref.watch(todayXpProvider);
  final habitsXp = ref.watch(habitsXpTodayProvider);
  return banked + actionsXp + habitsXp;
});

final todayTotalXpProvider = Provider<int>((ref) {
  return ref.watch(todayXpProvider) + ref.watch(habitsXpTodayProvider);
});

/// Derived level/progress info, recomputed live as XP changes.
class LevelInfo {
  const LevelInfo({
    required this.level,
    required this.xpIntoLevel,
    required this.xpRequiredForLevel,
    required this.progress,
    required this.totalXp,
  });

  final int level;
  final int xpIntoLevel;
  final int xpRequiredForLevel;
  final double progress;
  final int totalXp;
}

final levelInfoProvider = Provider<LevelInfo>((ref) {
  final total = ref.watch(totalXpProvider);
  return LevelInfo(
    level: XpLevelCalculator.levelForTotalXp(total),
    xpIntoLevel: XpLevelCalculator.xpIntoCurrentLevel(total),
    xpRequiredForLevel:
        XpLevelCalculator.xpRequiredForLevel(XpLevelCalculator.levelForTotalXp(total)),
    progress: XpLevelCalculator.levelProgress(total),
    totalXp: total,
  );
});
