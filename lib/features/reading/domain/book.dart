import 'package:equatable/equatable.dart';

class Book extends Equatable {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.currentPage,
    required this.totalPages,
    required this.hoursSpent,
    this.favoriteQuote,
  });

  final String id;
  final String title;
  final String author;
  final int currentPage;
  final int totalPages;
  final double hoursSpent;
  final String? favoriteQuote;

  double get progress => totalPages == 0 ? 0 : (currentPage / totalPages).clamp(0.0, 1.0);
  bool get isFinished => currentPage >= totalPages;

  @override
  List<Object?> get props => [id, title, author, currentPage, totalPages, hoursSpent, favoriteQuote];
}
