import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/reading_repository.dart';
import '../../domain/book.dart';

final readingRepositoryProvider = Provider<ReadingRepository>((ref) {
  return LocalReadingRepository();
});

class BooksNotifier extends AsyncNotifier<List<Book>> {
  @override
  Future<List<Book>> build() {
    return ref.read(readingRepositoryProvider).fetchBooks();
  }

  void updatePage(String bookId, int newPage) {
    state.whenData((books) {
      state = AsyncValue.data([
        for (final book in books)
          if (book.id == bookId)
            Book(
              id: book.id,
              title: book.title,
              author: book.author,
              currentPage: newPage.clamp(0, book.totalPages),
              totalPages: book.totalPages,
              hoursSpent: book.hoursSpent,
              favoriteQuote: book.favoriteQuote,
            )
          else
            book,
      ]);
    });
  }
}

final booksProvider = AsyncNotifierProvider<BooksNotifier, List<Book>>(BooksNotifier.new);

final readingStreakProvider = FutureProvider<int>((ref) {
  return ref.read(readingRepositoryProvider).fetchReadingStreak();
});

/// Derived: total hours spent reading across all books.
final totalReadingHoursProvider = Provider<double>((ref) {
  final books = ref.watch(booksProvider).value ?? [];
  return books.fold<double>(0, (sum, b) => sum + b.hoursSpent);
});
