import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Note extends Equatable {
  final String id;
  final String? title;
  final String? body;
  final int? color;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.body,
    this.color,
  });

  @override
  List<Object?> get props =>
      [id, title, body, color, isPinned, createdAt, updatedAt];

  Note copyWith({
    String? id,
    String? title,
    String? body,
    int? color,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearTitle = false,
    bool clearBody = false,
    bool clearColor = false,
  }) {
    return Note(
      id: id ?? this.id,
      title: clearTitle ? null : title ?? this.title,
      body: clearBody ? null : body ?? this.body,
      color: clearColor ? null : color ?? this.color,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
