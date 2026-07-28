import 'package:equatable/equatable.dart';

enum SearchCategory { goal, habit, note, project, book, course, transaction }

extension SearchCategoryLabel on SearchCategory {
  String get label {
    switch (this) {
      case SearchCategory.goal:
        return 'Goal';
      case SearchCategory.habit:
        return 'Habit';
      case SearchCategory.note:
        return 'Note';
      case SearchCategory.project:
        return 'Project';
      case SearchCategory.book:
        return 'Book';
      case SearchCategory.course:
        return 'Course';
      case SearchCategory.transaction:
        return 'Transaction';
    }
  }
}

/// A single unified search hit. [referenceId] is the underlying
/// entity's id (goal id, note id, ...) so the search screen can route
/// to the right place on tap.
class SearchResult extends Equatable {
  const SearchResult({
    required this.referenceId,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.category,
  });

  final String referenceId;
  final String title;
  final String subtitle;
  final String emoji;
  final SearchCategory category;

  @override
  List<Object?> get props => [referenceId, title, subtitle, emoji, category];
}
