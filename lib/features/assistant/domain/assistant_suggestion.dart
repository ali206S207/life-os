import 'package:equatable/equatable.dart';

enum SuggestionPriority { low, medium, high }

/// A single proactive suggestion from the Assistant (e.g. "You skipped
/// the gym yesterday — going today keeps your streak alive"). These are
/// generated from live app state, not stored — see
/// [AssistantSuggestionEngine].
class AssistantSuggestion extends Equatable {
  const AssistantSuggestion({
    required this.id,
    required this.message,
    required this.emoji,
    required this.priority,
  });

  final String id;
  final String message;
  final String emoji;
  final SuggestionPriority priority;

  @override
  List<Object?> get props => [id, message, emoji, priority];
}
