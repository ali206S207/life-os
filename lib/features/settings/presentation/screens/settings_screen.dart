import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl,
          ),
          children: [
            Text('Settings', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: AppSpacing.lg),
            GlassCard(
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text('👤', style: TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ali', style: Theme.of(context).textTheme.titleLarge),
                      Text('Life OS account', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            GlassCard(
              child: Column(
                children: [
                  for (final mode in ThemeMode.values)
                    RadioListTile<ThemeMode>(
                      value: mode,
                      groupValue: themeMode,
                      onChanged: (v) => ref.read(themeModeProvider.notifier).setMode(v!),
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        switch (mode) {
                          ThemeMode.dark => 'Dark',
                          ThemeMode.light => 'Light',
                          ThemeMode.system => 'Match System',
                        },
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Notifications', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            GlassCard(
              child: SwitchListTile(
                value: notificationsEnabled,
                onChanged: (_) => ref.read(notificationsEnabledProvider.notifier).toggle(),
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                title: Text('Smart Notifications', style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(
                  'Pattern-based nudges, not generic reminders.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('About', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            GlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Life OS', style: Theme.of(context).textTheme.bodyLarge),
                  Text('v0.1.0', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
