import 'package:flutter/material.dart';

/// Breakpoints Life OS uses to decide between a mobile-style layout
/// (bottom navigation, single column) and a desktop/tablet-style layout
/// (side navigation rail, multi-column grids) — the app targets both a
/// mobile app and a PC program from the same codebase, so screens should
/// consult these rather than hardcoding a single layout.
class AppBreakpoints {
  AppBreakpoints._();

  static const double tablet = 700;
  static const double desktop = 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;

  static bool isWideDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;
}
