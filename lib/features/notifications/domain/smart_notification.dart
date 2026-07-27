import 'package:equatable/equatable.dart';

/// A single "smart" notification — informative and pattern-based
/// rather than a generic reminder (e.g. "Your sleep schedule is
/// slipping" instead of "Don't forget to sleep!"). Lives in an inbox
/// the user can read and dismiss, rather than firing as an interruptive
/// push at an arbitrary time.
class SmartNotification extends Equatable {
  const SmartNotification({
    required this.id,
    required this.message,
    required this.emoji,
    required this.createdAt,
    this.isRead = false,
  });

  final String id;
  final String message;
  final String emoji;
  final DateTime createdAt;
  final bool isRead;

  SmartNotification copyWith({bool? isRead}) {
    return SmartNotification(
      id: id,
      message: message,
      emoji: emoji,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [id, message, emoji, createdAt, isRead];
}
