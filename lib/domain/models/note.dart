import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Note extends Equatable {
  final String id;
  final String? title;
  final String? body;
  final String? label;
  final int? color;
  final int position;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
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

  Note copyWith({
    String? id,
    String? title,
    String? body,
    String? label,
    int? color,
    int? position,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearTitle = false,
    bool clearBody = false,
    bool clearLabel = false,
    bool clearColor = false,
  }) {
    return Note(
      id: id ?? this.id,
      title: clearTitle ? null : title ?? this.title,
      body: clearBody ? null : body ?? this.body,
      label: clearLabel ? null : label ?? this.label,
      color: clearColor ? null : color ?? this.color,
      position: position ?? this.position,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
