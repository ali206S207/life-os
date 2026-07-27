import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';
import '../models/app_nav_item.dart';
import 'glass_card.dart';

/// Grid of secondary destinations (Achievements, Stats, Reading, ...)
/// that don't fit the primary mobile bottom nav. Desktop shows these
/// directly in the NavigationRail instead, since it has vertical room
/// to spare — this hub only exists for the narrow/mobile layout.
class MoreHubScreen extends StatelessWidget {
  const MoreHubScreen({super.key, required this.items, required this.onSelect});

  final List<AppNavItem> items;
  final void Function(AppNavItem item) onSelect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.9,
          ),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final item = items[i];
            return GlassCard(
              onTap: () => onSelect(item),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 28),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
