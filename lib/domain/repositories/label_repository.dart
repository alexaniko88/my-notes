import 'package:my_notes/domain/models/label.dart';

abstract class LabelRepository {
  Stream<List<Label>> watchAll();

  Future<Label?> getLabel(String id);

  Future<String> add(Label label);

  Future<String> update(Label label);

  Future<String> delete(String id);
}
