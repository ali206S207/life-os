import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../assistant/presentation/widgets/assistant_suggestion_card.dart';
import '../../../notifications/presentation/widgets/notification_bell_button.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../../../xp/presentation/widgets/xp_bar.dart';
import '../../domain/dashboard_widget_id.dart';
import '../providers/dashboard_layout_provider.dart';
import '../providers/daily_actions_provider.dart';
import '../widgets/progress_ring_section.dart';
import '../widgets/today_actions_section.dart';

/// The main "what should I do right now" landing screen.
///
/// The body below the header is a drag-and-drop-reorderable list of
/// widgets (XP bar, Assistant, Progress ring, Today's actions) — order
/// is held in [dashboardLayoutProvider] and persists for the session,
/// matching the spec's "customizable dashboard widgets" requirement.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key, this.userName = 'Ali'});

  final String userName;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 18) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildWidget(DashboardWidgetId id) {
    switch (id) {
      case DashboardWidgetId.xpBar:
        return const XpBar();
      case DashboardWidgetId.assistant:
        return const AssistantSuggestionCard();
      case DashboardWidgetId.progressRing:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: ProgressRingSection(),
        );
      case DashboardWidgetId.todayActions:
        return const TodayActionsSection();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(dashboardLayoutProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(dailyActionsProvider.notifier).refresh(),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
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
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl,
                ),
                sliver: SliverReorderableList(
                  itemCount: layout.length,
                  onReorder: (oldIndex, newIndex) =>
                      ref.read(dashboardLayoutProvider.notifier).reorder(oldIndex, newIndex),
                  itemBuilder: (context, index) {
                    final id = layout[index];
                    return Padding(
                      key: ValueKey(id),
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildWidget(id)),
                          ReorderableDragStartListener(
                            index: index,
                            child: const Padding(
                              padding: EdgeInsets.only(left: AppSpacing.xs, top: AppSpacing.sm),
                              child: Icon(Icons.drag_indicator_rounded, color: AppColors.textMuted, size: 20),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
