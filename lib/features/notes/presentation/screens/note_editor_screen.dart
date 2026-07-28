import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/notes_provider.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({super.key, required this.noteId});

  final String noteId;

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  bool _previewMode = false;

  @override
  void initState() {
    super.initState();
    final notes = ref.read(notesProvider).value ?? [];
    final note = notes.firstWhere((n) => n.id == widget.noteId);
    _titleController = TextEditingController(text: note.title);
    _bodyController = TextEditingController(text: note.body);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(notesProvider.notifier).updateNote(
          widget.noteId,
          title: _titleController.text.isEmpty ? 'Untitled' : _titleController.text,
          body: _bodyController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          onChanged: (_) => _save(),
          style: Theme.of(context).textTheme.titleLarge,
          decoration: const InputDecoration(border: InputBorder.none, hintText: 'Title'),
        ),
        actions: [
          IconButton(
            icon: Icon(_previewMode ? Icons.edit_rounded : Icons.visibility_rounded),
            tooltip: _previewMode ? 'Edit' : 'Preview',
            onPressed: () => setState(() => _previewMode = !_previewMode),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: _previewMode
              ? Markdown(
                  data: _bodyController.text.isEmpty ? '_Nothing here yet._' : _bodyController.text,
                  styleSheet: MarkdownStyleSheet(
                    p: Theme.of(context).textTheme.bodyLarge,
                    h1: Theme.of(context).textTheme.displayMedium,
                    h2: Theme.of(context).textTheme.headlineMedium,
                    code: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          backgroundColor: AppColors.darkSurfaceElevated,
                          fontFamily: 'monospace',
                        ),
                    listBullet: Theme.of(context).textTheme.bodyLarge,
                    tableBorder: TableBorder.all(color: AppColors.darkBorder),
                  ),
                )
              : TextField(
                  controller: _bodyController,
                  onChanged: (_) => _save(),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontFamily: 'monospace'),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '# Start writing in Markdown...',
                  ),
                ),
        ),
      ),
    );
  }
}
