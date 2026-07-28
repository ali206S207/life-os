import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../goals/presentation/providers/goals_provider.dart';
import '../../../habits/presentation/providers/habits_provider.dart';
import '../../../learning/presentation/providers/learning_provider.dart';
import '../../../notes/presentation/providers/notes_provider.dart';
import '../../../projects/presentation/providers/projects_provider.dart';
import '../../../reading/presentation/providers/reading_provider.dart';
import '../../domain/search_result.dart';

/// Federates a free-text [query] across every module's already-loaded
/// data (goals, habits, notes, projects, books, courses). This is a
/// client-side fan-out over in-memory providers rather than a backend
/// search index — fine at this data scale, and it stays instant since
/// there's no network round trip.
final universalSearchProvider = Provider.family<List<SearchResult>, String>((ref, query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return [];

  final results = <SearchResult>[];

  for (final goal in ref.watch(goalsProvider).value ?? []) {
    if (goal.title.toLowerCase().contains(q)) {
      results.add(SearchResult(
        referenceId: goal.id,
        title: goal.title,
        subtitle: '${(goal.progress * 100).round()}% complete',
        emoji: goal.emoji,
        category: SearchCategory.goal,
      ));
    }
  }

  for (final habit in ref.watch(habitsProvider).value ?? []) {
    if (habit.title.toLowerCase().contains(q)) {
      results.add(SearchResult(
        referenceId: habit.id,
        title: habit.title,
        subtitle: '${habit.currentStreak}-day streak',
        emoji: habit.emoji,
        category: SearchCategory.habit,
      ));
    }
  }

  for (final note in ref.watch(notesProvider).value ?? []) {
    final matchesTitle = note.title.toLowerCase().contains(q);
    final matchesTag = note.tags.any((t) => t.toLowerCase().contains(q));
    if (matchesTitle || matchesTag) {
      results.add(SearchResult(
        referenceId: note.id,
        title: note.title,
        subtitle: note.tags.map((t) => '#$t').join(' '),
        emoji: '📝',
        category: SearchCategory.note,
      ));
    }
  }

  for (final project in ref.watch(projectsProvider).value ?? []) {
    if (project.title.toLowerCase().contains(q)) {
      results.add(SearchResult(
        referenceId: project.id,
        title: project.title,
        subtitle: '${(project.progress * 100).round()}% complete',
        emoji: project.emoji,
        category: SearchCategory.project,
      ));
    }
  }

  for (final book in ref.watch(booksProvider).value ?? []) {
    if (book.title.toLowerCase().contains(q) || book.author.toLowerCase().contains(q)) {
      results.add(SearchResult(
        referenceId: book.id,
        title: book.title,
        subtitle: book.author,
        emoji: '📚',
        category: SearchCategory.book,
      ));
    }
  }

  for (final course in ref.watch(coursesProvider).value ?? []) {
    if (course.title.toLowerCase().contains(q) || course.subject.toLowerCase().contains(q)) {
      results.add(SearchResult(
        referenceId: course.id,
        title: course.title,
        subtitle: course.subject,
        emoji: '🎓',
        category: SearchCategory.course,
      ));
    }
  }

  return results;
});
