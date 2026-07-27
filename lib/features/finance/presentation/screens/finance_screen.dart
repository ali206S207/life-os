import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/transaction.dart';
import '../providers/finance_provider.dart';

class FinanceScreen extends ConsumerWidget {
  const FinanceScreen({super.key});

  String _fmt(double v) => v.toStringAsFixed(0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final income = ref.watch(totalIncomeProvider);
    final expenses = ref.watch(totalExpensesProvider);
    final net = ref.watch(netSavingsProvider);
    final budgetUsage = ref.watch(budgetUsageProvider);
    final budget = ref.watch(monthlyBudgetProvider).value ?? 0;
    final savingsGoalAsync = ref.watch(savingsGoalProvider);
    final txnsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl,
          ),
          children: [
            Text('Finance', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Income', style: Theme.of(context).textTheme.bodyMedium),
                        Text('+${_fmt(income)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.success)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Expenses', style: Theme.of(context).textTheme.bodyMedium),
                        Text('-${_fmt(expenses)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.danger)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Net', style: Theme.of(context).textTheme.bodyMedium),
                        Text(_fmt(net), style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Monthly Budget', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '${_fmt(expenses)} / ${_fmt(budget)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      value: budgetUsage.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: AppColors.darkBorder,
                      valueColor: AlwaysStoppedAnimation(
                        budgetUsage > 1 ? AppColors.danger : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            savingsGoalAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => const SizedBox.shrink(),
              data: (goal) => GlassCard(
                gradientBorder: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(goal.title, style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          '${(goal.progress * 100).round()}%',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: LinearProgressIndicator(
                        value: goal.progress,
                        minHeight: 8,
                        backgroundColor: AppColors.darkBorder,
                        valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_fmt(goal.currentAmount)} / ${_fmt(goal.targetAmount)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Recent Transactions', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.md),
            txnsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const Text('Could not load transactions.'),
              data: (txns) => Column(
                children: [
                  for (final txn in txns) ...[
                    GlassCard(
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: (txn.type == TransactionType.income
                                      ? AppColors.success
                                      : AppColors.danger)
                                  .withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              txn.type == TransactionType.income
                                  ? Icons.arrow_downward_rounded
                                  : Icons.arrow_upward_rounded,
                              size: 18,
                              color: txn.type == TransactionType.income
                                  ? AppColors.success
                                  : AppColors.danger,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(txn.title, style: Theme.of(context).textTheme.titleMedium),
                                Text(txn.category, style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          Text(
                            '${txn.type == TransactionType.income ? '+' : '-'}${_fmt(txn.amount)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: txn.type == TransactionType.income
                                      ? AppColors.success
                                      : AppColors.danger,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
