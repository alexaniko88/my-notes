import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_notes/domain/models/label.dart';

@immutable
class LabelDto extends Equatable {
  final String id;
  final String name;

  const LabelDto({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  factory LabelDto.fromFirestore(Map<String, dynamic> data, String id) {
    return LabelDto(id: id, name: data['name'] as String? ?? '');
  }

  factory LabelDto.fromLabel(Label label) {
    return LabelDto(id: label.id, name: label.name);
  }

  Label toLabel() {
    return Label(id: id, name: name);
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name};
  }
}
