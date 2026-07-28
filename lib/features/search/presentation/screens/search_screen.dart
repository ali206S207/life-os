import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../goals/presentation/screens/goal_detail_screen.dart';
import '../../../habits/presentation/screens/habits_screen.dart';
import '../../../learning/presentation/screens/learning_screen.dart';
import '../../../notes/presentation/screens/note_editor_screen.dart';
import '../../../projects/presentation/screens/projects_screen.dart';
import '../../../reading/presentation/screens/reading_screen.dart';
import '../../domain/search_result.dart';
import '../providers/search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openResult(SearchResult result) {
    Widget destination;
    switch (result.category) {
      case SearchCategory.goal:
        destination = GoalDetailScreen(goalId: result.referenceId);
        break;
      case SearchCategory.note:
        destination = NoteEditorScreen(noteId: result.referenceId);
        break;
      case SearchCategory.habit:
        destination = const HabitsScreen();
        break;
      case SearchCategory.project:
        destination = const ProjectsScreen();
        break;
      case SearchCategory.book:
        destination = const ReadingScreen();
        break;
      case SearchCategory.course:
        destination = const LearningScreen();
        break;
      case SearchCategory.transaction:
        destination = const ProjectsScreen();
        break;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => destination));
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(universalSearchProvider(_query));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (v) => setState(() => _query = v),
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search goals, habits, notes, books...',
          ),
        ),
      ),
      body: SafeArea(
        child: _query.trim().isEmpty
            ? Center(
                child: Text(
                  'Search across everything in Life OS.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            : results.isEmpty
                ? Center(
                    child: Text('No results for "$_query".', style: Theme.of(context).textTheme.bodyMedium),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl,
                    ),
                    children: [
                      for (final result in results) ...[
                        GlassCard(
                          onTap: () => _openResult(result),
                          child: Row(
                            children: [
                              Text(result.emoji, style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(result.title, style: Theme.of(context).textTheme.titleMedium),
                                    Text(result.subtitle, style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.darkSurfaceElevated,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                ),
                                child: Text(
                                  result.category.label,
                                  style: Theme.of(context).textTheme.labelSmall,
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
    );
  }
}
