import '../domain/transaction.dart';

abstract class FinanceRepository {
  Future<List<Transaction>> fetchTransactions();
  Future<double> fetchMonthlyBudget();
  Future<FinanceGoal> fetchSavingsGoal();
}

class LocalFinanceRepository implements FinanceRepository {
  @override
  Future<List<Transaction>> fetchTransactions() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    return [
      Transaction(
        id: 't1',
        title: 'Freelance project',
        amount: 3500,
        type: TransactionType.income,
        category: 'Freelance',
        date: now.subtract(const Duration(days: 2)),
      ),
      Transaction(
        id: 't2',
        title: 'Groceries',
        amount: 420,
        type: TransactionType.expense,
        category: 'Food',
        date: now.subtract(const Duration(days: 1)),
      ),
      Transaction(
        id: 't3',
        title: 'Gym supplements stock',
        amount: 900,
        type: TransactionType.expense,
        category: 'Business',
        date: now.subtract(const Duration(days: 3)),
      ),
      Transaction(
        id: 't4',
        title: 'Client payment',
        amount: 1200,
        type: TransactionType.income,
        category: 'Freelance',
        date: now.subtract(const Duration(days: 5)),
      ),
      Transaction(
        id: 't5',
        title: 'Internet bill',
        amount: 150,
        type: TransactionType.expense,
        category: 'Bills',
        date: now.subtract(const Duration(days: 6)),
      ),
    ];
  }

  @override
  Future<double> fetchMonthlyBudget() async => 3000;

  @override
  Future<FinanceGoal> fetchSavingsGoal() async {
    return const FinanceGoal(
      id: 'fg1',
      title: 'Emergency Fund',
      currentAmount: 8200,
      targetAmount: 20000,
    );
  }
}
