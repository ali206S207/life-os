import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/assistant_provider.dart';

class AssistantScreen extends ConsumerWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(assistantSuggestionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Assistant')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl,
          ),
          children: [
            if (suggestions.isEmpty)
              GlassCard(
                child: Text(
                  'Nothing to flag right now — you\'re on track.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            else
              for (final suggestion in suggestions) ...[
                GlassCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(suggestion.emoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          suggestion.message,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
          ],
        ),
      ),
    );
  }
}
