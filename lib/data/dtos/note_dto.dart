import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/domain/models/note_type.dart';

@immutable
class NoteDto extends Equatable {
  final String id;
  final NoteType type;
  final String? title;
  final String? body;
  final String? fileUrl;
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
    this.type = NoteType.text,
    this.title,
    this.body,
    this.fileUrl,
    this.labelIds = const [],
    this.color,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    body,
    fileUrl,
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
      type: _typeFromName(data['type'] as String?),
      title: data['title'] as String?,
      body: data['body'] as String?,
      fileUrl: data['fileUrl'] as String?,
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
      type: note.type,
      title: note.title,
      body: note.body,
      fileUrl: note.fileUrl,
      labelIds: note.labelIds,
      color: note.color,
      position: note.position,
      isPinned: note.isPinned,
      createdAt: Timestamp.fromDate(note.createdAt),
      updatedAt: Timestamp.fromDate(note.updatedAt),
      deletedAt: deletedAt != null ? Timestamp.fromDate(deletedAt) : null,
    );
  }

  // Maps the stored type name back to the enum; unknown or missing values
  // (e.g. notes written before the type field existed) default to text.
  static NoteType _typeFromName(String? name) {
    return NoteType.values.firstWhere(
      (type) => type.name == name,
      orElse: () => NoteType.text,
    );
  }

  Note toNote() {
    return Note(
      id: id,
      type: type,
      title: title,
      body: body,
      fileUrl: fileUrl,
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
      'type': type.name,
      'title': title,
      'body': body,
      'fileUrl': fileUrl,
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
