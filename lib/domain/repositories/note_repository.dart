import 'package:my_notes/domain/models/note.dart';

abstract class NoteRepository {
  List<Note> getAll();
  void add(Note note);
  void update(Note note);
  void delete(String id);
}
