import 'package:my_notes/domain/models/note.dart';

abstract class NoteRepository {
  Stream<List<Note>> watchAll();

  Future<Note?> getNote(String id);

  Future<String> add(Note note);

  Future<String> update(Note note);

  Future<String> delete(String id);

  /// Removes the label reference from every note that links [labelId].
  Future<void> clearLabel(String labelId);
}
