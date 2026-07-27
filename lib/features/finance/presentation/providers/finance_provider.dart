import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/finance_repository.dart';
import '../../domain/transaction.dart';

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return LocalFinanceRepository();
});

final transactionsProvider = FutureProvider<List<Transaction>>((ref) {
  return ref.read(financeRepositoryProvider).fetchTransactions();
});

final monthlyBudgetProvider = FutureProvider<double>((ref) {
  return ref.read(financeRepositoryProvider).fetchMonthlyBudget();
});

final savingsGoalProvider = FutureProvider<FinanceGoal>((ref) {
  return ref.read(financeRepositoryProvider).fetchSavingsGoal();
});

/// Derived: total income this period.
final totalIncomeProvider = Provider<double>((ref) {
  final txns = ref.watch(transactionsProvider).value ?? [];
  return txns
      .where((t) => t.type == TransactionType.income)
      .fold<double>(0, (sum, t) => sum + t.amount);
});

/// Derived: total expenses this period.
final totalExpensesProvider = Provider<double>((ref) {
  final txns = ref.watch(transactionsProvider).value ?? [];
  return txns
      .where((t) => t.type == TransactionType.expense)
      .fold<double>(0, (sum, t) => sum + t.amount);
});

/// Derived: net savings (income - expenses).
final netSavingsProvider = Provider<double>((ref) {
  return ref.watch(totalIncomeProvider) - ref.watch(totalExpensesProvider);
});

/// Derived: 0.0-1.0+ fraction of the monthly budget spent so far.
final budgetUsageProvider = Provider<double>((ref) {
  final budget = ref.watch(monthlyBudgetProvider).value ?? 0;
  final spent = ref.watch(totalExpensesProvider);
  if (budget == 0) return 0;
  return spent / budget;
});
