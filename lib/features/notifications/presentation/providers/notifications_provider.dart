import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/notifications_repository.dart';
import '../../domain/smart_notification.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return LocalNotificationsRepository();
});

class NotificationsNotifier extends AsyncNotifier<List<SmartNotification>> {
  @override
  Future<List<SmartNotification>> build() {
    return ref.read(notificationsRepositoryProvider).fetchNotifications();
  }

  void markRead(String id) {
    state.whenData((items) {
      state = AsyncValue.data([
        for (final item in items)
          if (item.id == id) item.copyWith(isRead: true) else item,
      ]);
    });
  }

  void dismiss(String id) {
    state.whenData((items) {
      state = AsyncValue.data(items.where((item) => item.id != id).toList());
    });
  }

  void markAllRead() {
    state.whenData((items) {
      state = AsyncValue.data([for (final item in items) item.copyWith(isRead: true)]);
    });
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<SmartNotification>>(
  NotificationsNotifier.new,
);

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final items = ref.watch(notificationsProvider).value ?? [];
  return items.where((n) => !n.isRead).length;
});
