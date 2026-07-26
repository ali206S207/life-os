import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/features/xp/domain/xp_level_calculator.dart';

void main() {
  group('XpLevelCalculator', () {
    test('starts at level 1 with 0 XP', () {
      expect(XpLevelCalculator.levelForTotalXp(0), 1);
    });

    test('levels up after crossing the requirement for level 1 (100 XP)', () {
      expect(XpLevelCalculator.levelForTotalXp(99), 1);
      expect(XpLevelCalculator.levelForTotalXp(100), 2);
    });

    test('requirement grows with level (100 * level)', () {
      expect(XpLevelCalculator.xpRequiredForLevel(1), 100);
      expect(XpLevelCalculator.xpRequiredForLevel(2), 200);
      expect(XpLevelCalculator.xpRequiredForLevel(5), 500);
    });

    test('xpIntoCurrentLevel resets correctly after leveling up', () {
      // 100 XP exactly reaches level 2 with 0 XP into it.
      expect(XpLevelCalculator.xpIntoCurrentLevel(100), 0);
      // 250 -> level 2 requires 200 to reach, so 50 into level 2's 200 requirement.
      expect(XpLevelCalculator.levelForTotalXp(250), 2);
      expect(XpLevelCalculator.xpIntoCurrentLevel(250), 50);
    });

    test('levelProgress is between 0 and 1', () {
      final progress = XpLevelCalculator.levelProgress(250);
      expect(progress, closeTo(50 / 200, 0.0001));
    });
  });
}
