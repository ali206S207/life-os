import '../domain/book.dart';

abstract class ReadingRepository {
  Future<List<Book>> fetchBooks();
  Future<int> fetchReadingStreak();
}

class LocalReadingRepository implements ReadingRepository {
  @override
  Future<List<Book>> fetchBooks() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      Book(
        id: 'b1',
        title: 'Atomic Habits',
        author: 'James Clear',
        currentPage: 210,
        totalPages: 320,
        hoursSpent: 6.5,
        favoriteQuote: 'Your favorite line from this book — tap to edit.',
      ),
      Book(
        id: 'b2',
        title: 'Deep Work',
        author: 'Cal Newport',
        currentPage: 296,
        totalPages: 296,
        hoursSpent: 8,
      ),
      Book(
        id: 'b3',
        title: 'The Pragmatic Programmer',
        author: 'David Thomas & Andrew Hunt',
        currentPage: 40,
        totalPages: 352,
        hoursSpent: 1.5,
      ),
    ];
  }

  @override
  Future<int> fetchReadingStreak() async => 5;
}
