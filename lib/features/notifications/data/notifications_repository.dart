import '../domain/smart_notification.dart';

abstract class NotificationsRepository {
  Future<List<SmartNotification>> fetchNotifications();
}

/// Local implementation with realistic seed content matching the
/// "helpful, not stressful" tone from the spec.
///
/// TODO(life-os): Wire actual OS-level scheduled push notifications via
/// `flutter_local_notifications` (+ platform channel setup for
/// iOS/Android/desktop) once this runs on a real device/build target —
/// this repository only covers the in-app inbox and rule content for now.
class LocalNotificationsRepository implements NotificationsRepository {
  @override
  Future<List<SmartNotification>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();

    return [
      SmartNotification(
        id: 'n1',
        emoji: '🧠',
        message: 'You usually study around this time — want to start a session?',
        createdAt: now.subtract(const Duration(minutes: 20)),
      ),
      SmartNotification(
        id: 'n2',
        emoji: '😴',
        message: 'Your sleep schedule is slipping — you\'ve averaged under 6.5h this week.',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      SmartNotification(
        id: 'n3',
        emoji: '🏋️',
        message: 'You\'re 2 workouts away from your monthly goal.',
        createdAt: now.subtract(const Duration(hours: 6)),
        isRead: true,
      ),
      SmartNotification(
        id: 'n4',
        emoji: '💧',
        message: 'Drink water — you\'re behind your usual pace today.',
        createdAt: now.subtract(const Duration(hours: 8)),
        isRead: true,
      ),
    ];
  }
}
