import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_typography.dart';
import 'core/utils/responsive.dart';
import 'features/areas/presentation/screens/areas_screen.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/goals/presentation/screens/goals_screen.dart';
import 'features/habits/presentation/screens/habits_screen.dart';
import 'features/reading/presentation/screens/reading_screen.dart';
import 'features/statistics/presentation/screens/statistics_screen.dart';
import 'features/xp/presentation/providers/achievements_provider.dart';
import 'features/xp/presentation/screens/achievements_screen.dart';
import 'shared/models/app_nav_item.dart';
import 'shared/widgets/more_hub_screen.dart';

void main() {
  // Supabase.initialize(...) will be wired here in the "Supabase Sync" milestone.
  runApp(const ProviderScope(child: LifeOsApp()));
}

class LifeOsApp extends StatelessWidget {
  const LifeOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life OS',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const RootShell(),
    );
  }
}

/// Root navigation shell, responsive across mobile and desktop/PC:
/// - Narrow widths (phones): a 4-item bottom bar (Today/Areas/Goals/Habits)
///   plus a 5th "More" destination that opens [MoreHubScreen] for
///   everything else — a bottom bar with 7+ items stops being usable.
/// - Wide widths (tablet/desktop/PC): a persistent [NavigationRail] with
///   every destination shown directly, since vertical space isn't scarce
///   there and a "More" indirection would just add a click for no reason.
///
/// Also watches [achievementsProvider] globally so a newly unlocked
/// achievement surfaces as a toast no matter which screen is active.
class RootShell extends ConsumerStatefulWidget {
  const RootShell({super.key});

  @override
  ConsumerState<RootShell> createState() => _RootShellState();
}

class _RootShellState extends ConsumerState<RootShell> {
  int _index = 0;

  static const _primaryScreens = [
    DashboardScreen(),
    AreasScreen(),
    GoalsScreen(),
    HabitsScreen(),
  ];

  static const _primaryNavItems = [
    AppNavItem(icon: Icons.home_rounded, label: 'Today'),
    AppNavItem(icon: Icons.grid_view_rounded, label: 'Areas'),
    AppNavItem(icon: Icons.flag_rounded, label: 'Goals'),
    AppNavItem(icon: Icons.repeat_rounded, label: 'Habits'),
  ];

  static const _secondaryNavItems = [
    AppNavItem(icon: Icons.emoji_events_rounded, label: 'Achievements'),
    AppNavItem(icon: Icons.bar_chart_rounded, label: 'Stats'),
    AppNavItem(icon: Icons.menu_book_rounded, label: 'Reading'),
  ];

  static const _secondaryScreens = [
    AchievementsScreen(),
    StatisticsScreen(),
    ReadingScreen(),
  ];

  static const _moreNavItem = AppNavItem(icon: Icons.more_horiz_rounded, label: 'More');

  void _openSecondaryScreen(AppNavItem item) {
    final i = _secondaryNavItems.indexOf(item);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _secondaryScreens[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(achievementsProvider, (previous, next) {
      if (previous == null) return;
      final prevUnlocked = previous.where((a) => a.isUnlocked).map((a) => a.id).toSet();
      final newlyUnlocked = next.where(
        (a) => a.isUnlocked && !prevUnlocked.contains(a.id),
      );
      for (final achievement in newlyUnlocked) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${achievement.emoji} Achievement unlocked: ${achievement.title}'),
            backgroundColor: AppColors.darkSurfaceElevated,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final isDesktop = AppBreakpoints.isDesktop(context);

    if (isDesktop) {
      final allItems = [..._primaryNavItems, ..._secondaryNavItems];
      final allScreens = [..._primaryScreens, ..._secondaryScreens];
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              backgroundColor: AppColors.darkSurface,
              labelType: AppBreakpoints.isWideDesktop(context)
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.selected,
              extended: AppBreakpoints.isWideDesktop(context),
              minExtendedWidth: 180,
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text('🧭', style: TextStyle(fontSize: 28)),
              ),
              destinations: [
                for (final item in allItems)
                  NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(item.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1, color: AppColors.darkBorder),
            Expanded(
              child: IndexedStack(index: _index, children: allScreens),
            ),
          ],
        ),
      );
    }

    final mobileIndex = _index < _primaryScreens.length ? _index : 0;
    return Scaffold(
      body: IndexedStack(index: mobileIndex, children: _primaryScreens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: mobileIndex,
        onTap: (i) {
          if (i == _primaryNavItems.length) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MoreHubScreen(
                  items: _secondaryNavItems,
                  onSelect: _openSecondaryScreen,
                ),
              ),
            );
            return;
          }
          setState(() => _index = i);
        },
        selectedItemColor: AppColors.primary,
        type: BottomNavigationBarType.fixed,
        items: [
          for (final item in _primaryNavItems)
            BottomNavigationBarItem(icon: Icon(item.icon), label: item.label),
          BottomNavigationBarItem(icon: Icon(_moreNavItem.icon), label: _moreNavItem.label),
        ],
      ),
    );
  }
}
