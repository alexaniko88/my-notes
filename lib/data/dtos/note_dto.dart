import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_notes/domain/models/note.dart';

@immutable
class NoteDto extends Equatable {
  final String id;
  final String? title;
  final String? body;
  final String? label;
  final int? color;
  final int position;
  final bool isPinned;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  const NoteDto({
    required this.id,
    required this.position,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.body,
    this.label,
    this.color,
  });

  @override
  List<Object?> get props => [id, title, body, label, color, position, isPinned, createdAt, updatedAt];

  factory NoteDto.fromFirestore(Map<String, dynamic> data, String id) {
    return NoteDto(
      id: id,
      title: data['title'] as String?,
      body: data['body'] as String?,
      label: data['label'] as String?,
      color: data['color'] as int?,
      position: data['position'] as int? ?? 0,
      isPinned: data['isPinned'] as bool? ?? false,
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: data['updatedAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  factory NoteDto.fromNote(Note note) {
    return NoteDto(
      id: note.id,
      title: note.title,
      body: note.body,
      label: note.label,
      color: note.color,
      position: note.position,
      isPinned: note.isPinned,
      createdAt: Timestamp.fromDate(note.createdAt),
      updatedAt: Timestamp.fromDate(note.updatedAt),
    );
  }

  Note toNote() {
    return Note(
      id: id,
      title: title,
      body: body,
      label: label,
      color: color,
      position: position,
      isPinned: isPinned,
      createdAt: createdAt.toDate(),
      updatedAt: updatedAt.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'label': label,
      'color': color,
      'position': position,
      'isPinned': isPinned,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
