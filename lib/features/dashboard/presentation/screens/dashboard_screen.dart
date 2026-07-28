import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/animated_progress_ring.dart';
import '../../../assistant/presentation/widgets/assistant_suggestion_card.dart';
import '../../../notifications/presentation/widgets/notification_bell_button.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../../../xp/presentation/widgets/xp_bar.dart';
import '../providers/daily_actions_provider.dart';

/// The main "what should I do right now" landing screen.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key, this.userName = 'Ali'});

  final String userName;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 18) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionsAsync = ref.watch(dailyActionsProvider);
    final progress = ref.watch(todayProgressProvider);
    final xp = ref.watch(todayXpProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(dailyActionsProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxxl,
            ),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_greeting()}, $userName 👋',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    ),
                  ),
                  const NotificationBellButton(),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              const XpBar(),
              const SizedBox(height: AppSpacing.md),
              const AssistantSuggestionCard(),
              const SizedBox(height: AppSpacing.xxl),
              Center(
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
              ),
              const SizedBox(height: AppSpacing.xxl),
              actionsAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, _) => GlassCard(
                  child: Text(
                    'Could not load today\'s actions.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                data: (actions) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: AppSpacing.md),
                    for (final action in actions) ...[
                      _DailyActionTile(action: action),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyActionTile extends ConsumerWidget {
  const _DailyActionTile({required this.action});

  final dynamic action; // DailyAction — dynamic to avoid an extra import cycle here

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDone = action.isDone as bool;
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      onTap: () => ref.read(dailyActionsProvider.notifier).toggle(action.id as String),
      child: Row(
        children: [
          Text(action.emoji as String, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.title as String,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: isDone ? TextDecoration.lineThrough : null,
                        color: isDone ? AppColors.textMuted : AppColors.textPrimary,
                      ),
                ),
                Text(
                  '${action.time}  ·  +${action.xpReward} XP',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isDone ? AppColors.primaryGradient : null,
              border: Border.all(
                color: isDone ? Colors.transparent : AppColors.darkBorder,
                width: 2,
              ),
            ),
            child: isDone
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }
}
