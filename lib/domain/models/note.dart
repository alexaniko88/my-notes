import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Note extends Equatable {
  static const maxLabels = 5;

  final String id;
  final String? title;
  final String? body;
  final List<String> labelIds;
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
    this.labelIds = const [],
    this.color,
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
  ];

  Note copyWith({
    String? id,
    String? title,
    String? body,
    List<String>? labelIds,
    int? color,
    int? position,
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
      labelIds: labelIds ?? this.labelIds,
      color: clearColor ? null : color ?? this.color,
      position: position ?? this.position,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
