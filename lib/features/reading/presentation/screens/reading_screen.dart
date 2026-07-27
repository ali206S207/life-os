import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/reading_provider.dart';

class ReadingScreen extends ConsumerWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(booksProvider);
    final streakAsync = ref.watch(readingStreakProvider);
    final totalHours = ref.watch(totalReadingHoursProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl,
          ),
          children: [
            Text('Reading', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: AppSpacing.md),
            GlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('🔥', style: const TextStyle(fontSize: 20)),
                      Text(
                        '${streakAsync.value ?? 0}d streak',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('⏱️', style: const TextStyle(fontSize: 20)),
                      Text(
                        '${totalHours.toStringAsFixed(1)}h total',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            booksAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => const Text('Could not load books.'),
              data: (books) => Column(
                children: [
                  for (final book in books) ...[
                    GlassCard(
                      gradientBorder: book.isFinished,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(book.title, style: Theme.of(context).textTheme.titleLarge),
                                    Text(book.author, style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                              if (book.isFinished)
                                const Text('✅', style: TextStyle(fontSize: 20))
                              else
                                Text(
                                  '${(book.progress * 100).round()}%',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            child: LinearProgressIndicator(
                              value: book.progress,
                              minHeight: 6,
                              backgroundColor: AppColors.darkBorder,
                              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                            ),
                          ),
                          Slider(
                            value: book.currentPage.toDouble(),
                            min: 0,
                            max: book.totalPages.toDouble(),
                            divisions: book.totalPages > 0 ? book.totalPages : null,
                            label: '${book.currentPage} / ${book.totalPages}',
                            activeColor: AppColors.primary,
                            onChanged: (value) =>
                                ref.read(booksProvider.notifier).updatePage(book.id, value.round()),
                          ),
                          if (book.favoriteQuote != null) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              '"${book.favoriteQuote}"',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
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
