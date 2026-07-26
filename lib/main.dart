import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/areas/presentation/screens/areas_screen.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';

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
/// modules land (Goals, Habits, Calendar, ...), they get their own tab
/// here or move under in-tab navigation once go_router is wired in.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _screens = [
    DashboardScreen(),
    AreasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: AppColors.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Areas'),
        ],
      ),
    );
  }
}
