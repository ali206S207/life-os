import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/assistant_provider.dart';
import '../screens/assistant_screen.dart';

/// Shows the single highest-priority suggestion inline, e.g. on the
/// Dashboard, so proactive advice is visible without a dedicated trip
/// to the Assistant screen. Tapping it opens the full suggestion list.
class AssistantSuggestionCard extends ConsumerWidget {
  const AssistantSuggestionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(assistantSuggestionsProvider);
    if (suggestions.isEmpty) return const SizedBox.shrink();

    final top = suggestions.first;
    return GlassCard(
      gradientBorder: true,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AssistantScreen()),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(top.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Assistant', style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 2),
                Text(top.message, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
