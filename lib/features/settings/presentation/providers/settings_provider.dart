import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.dark;

  void setMode(ThemeMode mode) => state = mode;
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

/// Simple in-app toggle for whether Smart Notifications should be
/// generated at all. Actual OS-level push delivery is a separate TODO
/// (see the Notifications repository) — this just controls the in-app
/// inbox/badge.
class NotificationsEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

final notificationsEnabledProvider =
    NotifierProvider<NotificationsEnabledNotifier, bool>(NotificationsEnabledNotifier.new);
