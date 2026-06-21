import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_notes/domain/models/note_type.dart';

@immutable
class Note extends Equatable {
  static const maxLabels = 5;
  static const trashRetention = Duration(days: 7);

  final String id;
  final NoteType type;
  final String? title;
  final String? body;
  final String? fileUrl;
  final List<String> labelIds;
  final int? color;
  final int position;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Note({
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

  bool get isTrashed => deletedAt != null;

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

  Note copyWith({
    String? id,
    NoteType? type,
    String? title,
    String? body,
    String? fileUrl,
    List<String>? labelIds,
    int? color,
    int? position,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearTitle = false,
    bool clearBody = false,
    bool clearFileUrl = false,
    bool clearColor = false,
    bool clearDeletedAt = false,
  }) {
    return Note(
      id: id ?? this.id,
      type: type ?? this.type,
      title: clearTitle ? null : title ?? this.title,
      body: clearBody ? null : body ?? this.body,
      fileUrl: clearFileUrl ? null : fileUrl ?? this.fileUrl,
      labelIds: labelIds ?? this.labelIds,
      color: clearColor ? null : color ?? this.color,
      position: position ?? this.position,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
    );
  }
}
