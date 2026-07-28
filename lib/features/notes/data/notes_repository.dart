import '../domain/note.dart';

abstract class NotesRepository {
  Future<List<Note>> fetchNotes();
}

class LocalNotesRepository implements NotesRepository {
  @override
  Future<List<Note>> fetchNotes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();

    return [
      Note(
        id: 'note1',
        title: 'Weekly Review Template',
        body: '## What went well\n- \n\n## What to improve\n- \n\n## Next week focus\n- [ ] Item one\n- [ ] Item two',
        tags: const ['review', 'template'],
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Note(
        id: 'note2',
        title: 'Flutter Learnings',
        body: '# Riverpod notes\n\n`AsyncNotifier` is great for repository-backed state.\n\n'
            '| Concept | Use |\n|---|---|\n| Provider | derived read-only state |\n| Notifier | mutable state |',
        tags: const ['flutter', 'learning'],
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),
    ];
  }
}
