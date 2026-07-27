import 'package:flutter/material.dart';

/// A single top-level navigation destination, shared between the
/// mobile [BottomNavigationBar] and the desktop [NavigationRail] so the
/// list of destinations is defined exactly once.
class AppNavItem {
  const AppNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
