import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/domain/repositories/note_repository.dart';

// Fake in-memory implementation — replace with FirebaseNoteRepository when persistence is ready.
class InMemoryNoteRepository implements NoteRepository {
  final List<Note> _notes = [];

  @override
  List<Note> getAll() => List.unmodifiable(_notes);

  @override
  void add(Note note) => _notes.add(note);

  @override
  void update(Note note) {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) _notes[index] = note;
  }

  @override
  void delete(String id) => _notes.removeWhere((n) => n.id == id);
}
