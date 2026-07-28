import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/dashboard_widget_id.dart';

class DashboardLayoutNotifier extends Notifier<List<DashboardWidgetId>> {
  @override
  List<DashboardWidgetId> build() => const [
        DashboardWidgetId.xpBar,
        DashboardWidgetId.assistant,
        DashboardWidgetId.progressRing,
        DashboardWidgetId.todayActions,
      ];

  /// Moves the widget at [oldIndex] to [newIndex], following
  /// [ReorderableListView]'s index convention (newIndex is the target
  /// position *before* the item is removed from its old slot).
  void reorder(int oldIndex, int newIndex) {
    final updated = [...state];
    if (newIndex > oldIndex) newIndex -= 1;
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    state = updated;
  }
}

final dashboardLayoutProvider =
    NotifierProvider<DashboardLayoutNotifier, List<DashboardWidgetId>>(
  DashboardLayoutNotifier.new,
);
