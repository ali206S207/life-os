import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/animated_progress_ring.dart';
import '../providers/daily_actions_provider.dart';

class ProgressRingSection extends ConsumerWidget {
  const ProgressRingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(todayProgressProvider);
    final xp = ref.watch(todayXpProvider);

    return Center(
      child: AnimatedProgressRing(
        progress: progress,
        centerLabel: Text(
          '${(progress * 100).round()}%',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerSubLabel: Text(
          '+$xp XP today',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
