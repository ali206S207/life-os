import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;

  @override
  List<Object?> get props => [id, title, amount, type, category, date];
}

/// A savings/financial goal (e.g. "Emergency Fund: 20,000").
class FinanceGoal extends Equatable {
  const FinanceGoal({
    required this.id,
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
  });

  final String id;
  final String title;
  final double currentAmount;
  final double targetAmount;

  double get progress => targetAmount == 0 ? 0 : (currentAmount / targetAmount).clamp(0.0, 1.0);

  @override
  List<Object?> get props => [id, title, currentAmount, targetAmount];
}
