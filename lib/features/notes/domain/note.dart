import 'package:equatable/equatable.dart';

/// A single markdown note. Supports images/code/checklists/tables/links
/// simply by virtue of being markdown (rendered via flutter_markdown) —
/// no special-casing needed per content type. [tags] and [linkedNoteIds]
/// provide the lightweight tag + backlink support from the spec.
class Note extends Equatable {
  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.updatedAt,
    this.linkedNoteIds = const [],
  });

  final String id;
  final String title;
  final String body;
  final List<String> tags;
  final DateTime updatedAt;
  final List<String> linkedNoteIds;

  Note copyWith({String? title, String? body, DateTime? updatedAt}) {
    return Note(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      tags: tags,
      updatedAt: updatedAt ?? this.updatedAt,
      linkedNoteIds: linkedNoteIds,
    );
  }

  @override
  List<Object?> get props => [id, title, body, tags, updatedAt, linkedNoteIds];
}
