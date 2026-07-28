import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/notes_repository.dart';
import '../../domain/note.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return LocalNotesRepository();
});

class NotesNotifier extends AsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() {
    return ref.read(notesRepositoryProvider).fetchNotes();
  }

  void createNote() {
    state.whenData((notes) {
      final note = Note(
        id: const Uuid().v4(),
        title: 'Untitled',
        body: '',
        tags: const [],
        updatedAt: DateTime.now(),
      );
      state = AsyncValue.data([note, ...notes]);
    });
  }

  void updateNote(String id, {String? title, String? body}) {
    state.whenData((notes) {
      state = AsyncValue.data([
        for (final note in notes)
          if (note.id == id)
            note.copyWith(title: title, body: body, updatedAt: DateTime.now())
          else
            note,
      ]);
    });
  }

  void deleteNote(String id) {
    state.whenData((notes) {
      state = AsyncValue.data(notes.where((n) => n.id != id).toList());
    });
  }
}

final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);

/// Universal search hook for later: notes matching a free-text query
/// across title/body/tags.
final noteSearchResultsProvider = Provider.family<List<Note>, String>((ref, query) {
  final notes = ref.watch(notesProvider).value ?? [];
  if (query.trim().isEmpty) return notes;
  final q = query.toLowerCase();
  return notes.where((n) =>
      n.title.toLowerCase().contains(q) ||
      n.body.toLowerCase().contains(q) ||
      n.tags.any((t) => t.toLowerCase().contains(q))).toList();
});
