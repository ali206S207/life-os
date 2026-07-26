import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/areas/presentation/screens/areas_screen.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/goals/presentation/screens/goals_screen.dart';
import 'features/habits/presentation/screens/habits_screen.dart';
import 'features/statistics/presentation/screens/statistics_screen.dart';
import 'features/xp/presentation/providers/achievements_provider.dart';
import 'features/xp/presentation/screens/achievements_screen.dart';

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

/// Bottom-nav shell hosting the top-level feature screens. As more
/// modules land (Calendar, Notes, ...), they get their own tab here or
/// move under in-tab navigation once go_router is wired in.
///
/// Also watches [achievementsProvider] globally so a newly unlocked
/// achievement surfaces as a toast no matter which tab the user is on.
class RootShell extends ConsumerStatefulWidget {
  const RootShell({super.key});

  @override
  ConsumerState<RootShell> createState() => _RootShellState();
}

class _RootShellState extends ConsumerState<RootShell> {
  int _index = 0;

  static const _screens = [
    DashboardScreen(),
    AreasScreen(),
    GoalsScreen(),
    HabitsScreen(),
    AchievementsScreen(),
    StatisticsScreen(),
  ];

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

    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: AppColors.primary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Areas'),
          BottomNavigationBarItem(icon: Icon(Icons.flag_rounded), label: 'Goals'),
          BottomNavigationBarItem(icon: Icon(Icons.repeat_rounded), label: 'Habits'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_rounded), label: 'Achievements'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Stats'),
        ],
      ),
    );
  }
}
