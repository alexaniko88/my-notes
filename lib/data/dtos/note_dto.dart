import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_notes/domain/models/note.dart';

@immutable
class NoteDto extends Equatable {
  final String id;
  final String? title;
  final String? body;
  final List<String> labelIds;
  final int? color;
  final int position;
  final bool isPinned;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final Timestamp? deletedAt;

  const NoteDto({
    required this.id,
    required this.position,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.body,
    this.labelIds = const [],
    this.color,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    labelIds,
    color,
    position,
    isPinned,
    createdAt,
    updatedAt,
    deletedAt,
  ];

  factory NoteDto.fromFirestore(Map<String, dynamic> data, String id) {
    return NoteDto(
      id: id,
      title: data['title'] as String?,
      body: data['body'] as String?,
      labelIds:
          (data['labelIds'] as List<dynamic>?)?.cast<String>() ?? const [],
      color: data['color'] as int?,
      position: data['position'] as int? ?? 0,
      isPinned: data['isPinned'] as bool? ?? false,
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: data['updatedAt'] as Timestamp? ?? Timestamp.now(),
      deletedAt: data['deletedAt'] as Timestamp?,
    );
  }

  factory NoteDto.fromNote(Note note) {
    final deletedAt = note.deletedAt;
    return NoteDto(
      id: note.id,
      title: note.title,
      body: note.body,
      labelIds: note.labelIds,
      color: note.color,
      position: note.position,
      isPinned: note.isPinned,
      createdAt: Timestamp.fromDate(note.createdAt),
      updatedAt: Timestamp.fromDate(note.updatedAt),
      deletedAt: deletedAt != null ? Timestamp.fromDate(deletedAt) : null,
    );
  }

  Note toNote() {
    return Note(
      id: id,
      title: title,
      body: body,
      labelIds: labelIds,
      color: color,
      position: position,
      isPinned: isPinned,
      createdAt: createdAt.toDate(),
      updatedAt: updatedAt.toDate(),
      deletedAt: deletedAt?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'labelIds': labelIds,
      'color': color,
      'position': position,
      'isPinned': isPinned,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}
