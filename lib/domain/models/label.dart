import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Label extends Equatable {
  static const maxNameLength = 30;

  final String id;
  final String name;

  const Label({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];

  Label copyWith({
    String? id,
    String? name,
  }) {
    return Label(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
