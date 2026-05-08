import 'package:my_notes/data/repositories/in_memory_note_repository.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/domain/repositories/note_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'notes_provider.g.dart';

const _uuid = Uuid();

@Riverpod(keepAlive: true)
NoteRepository noteRepository(Ref ref) => InMemoryNoteRepository();

@riverpod
class NotesNotifier extends _$NotesNotifier {
  NoteRepository get _repo => ref.read(noteRepositoryProvider);

  @override
  List<Note> build() => _repo.getAll();

  void add({String? title, String? body, int? color}) {
    final now = DateTime.now();
    _repo.add(Note(
      id: _uuid.v4(),
      title: title,
      body: body,
      color: color,
      isPinned: false,
      createdAt: now,
      updatedAt: now,
    ));
    state = _repo.getAll();
  }

  void update(Note note) {
    _repo.update(note.copyWith(updatedAt: DateTime.now()));
    state = _repo.getAll();
  }

  void delete(String id) {
    _repo.delete(id);
    state = _repo.getAll();
  }

  void togglePin(String id) {
    final note = state.firstWhere((n) => n.id == id);
    update(note.copyWith(isPinned: !note.isPinned));
  }
}
