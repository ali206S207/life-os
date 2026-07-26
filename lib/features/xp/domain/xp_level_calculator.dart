/// Pure XP/Level math, kept dependency-free so it's trivial to unit test.
///
/// Leveling curve: each level requires progressively more XP
/// (100 * level) to keep early levels fast and later levels meaningful.
class XpLevelCalculator {
  const XpLevelCalculator._();

  static const int _baseXpPerLevel = 100;

  /// Total XP required to go from level [level] to [level] + 1.
  static int xpRequiredForLevel(int level) => _baseXpPerLevel * level;

  /// Given cumulative lifetime XP, returns the current level (starting at 1).
  static int levelForTotalXp(int totalXp) {
    int level = 1;
    int remaining = totalXp;
    while (remaining >= xpRequiredForLevel(level)) {
      remaining -= xpRequiredForLevel(level);
      level++;
    }
    return level;
  }

  /// XP earned *within* the current level (i.e. progress toward the next).
  static int xpIntoCurrentLevel(int totalXp) {
    int level = 1;
    int remaining = totalXp;
    while (remaining >= xpRequiredForLevel(level)) {
      remaining -= xpRequiredForLevel(level);
      level++;
    }
    return remaining;
  }

  /// 0.0–1.0 progress bar fraction toward the next level.
  static double levelProgress(int totalXp) {
    final level = levelForTotalXp(totalXp);
    final into = xpIntoCurrentLevel(totalXp);
    final required = xpRequiredForLevel(level);
    if (required == 0) return 0;
    return (into / required).clamp(0.0, 1.0);
  }
}
