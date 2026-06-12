import 'package:my_notes/data/repositories/firebase_note_repository.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/domain/models/note_exception.dart';
import 'package:my_notes/domain/repositories/note_repository.dart';
import 'package:my_notes/presentation/providers/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'notes_provider.g.dart';

const _uuid = Uuid();

@Riverpod(keepAlive: true)
NoteRepository noteRepository(Ref ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) throw StateError('Not authenticated');
  return FirebaseNoteRepository(userId: user.id);
}

@riverpod
class NotesNotifier extends _$NotesNotifier {
  NoteRepository get _repo => ref.read(noteRepositoryProvider);

  @override
  Stream<List<Note>> build() => ref.watch(noteRepositoryProvider).watchAll();

  Future<String> add({
    String? title,
    String? body,
    List<String> labelIds = const [],
    int? color,
  }) async {
    final validLabelIds = _validateLabelIds(labelIds);
    final now = DateTime.now();
    final notes = state.asData?.value ?? [];
    final id = _uuid.v4();
    await _repo.add(
      Note(
        id: id,
        title: title,
        body: body,
        labelIds: validLabelIds,
        color: color,
        position: notes.length,
        isPinned: false,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return id;
  }

  Future<void> updateNote(Note note) async {
    await _repo.update(note.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
  }

  Future<void> togglePin(String id) async {
    final notes = state.asData?.value ?? [];
    final note = notes.where((n) => n.id == id).firstOrNull;
    if (note == null) return;
    await updateNote(note.copyWith(isPinned: !note.isPinned));
  }

  Future<void> setLabels(String noteId, List<String> labelIds) async {
    final validLabelIds = _validateLabelIds(labelIds);
    final notes = state.asData?.value ?? [];
    final note = notes.where((n) => n.id == noteId).firstOrNull;
    if (note == null) return;
    await updateNote(note.copyWith(labelIds: validLabelIds));
  }

  List<String> _validateLabelIds(List<String> labelIds) {
    final uniqueLabelIds = labelIds.toSet().toList();
    if (uniqueLabelIds.length > Note.maxLabels) {
      throw NoteException('A note can have at most ${Note.maxLabels} labels');
    }
    return uniqueLabelIds;
  }
}

@riverpod
Note? note(Ref ref, String id) {
  final notes = ref.watch(notesProvider).asData?.value ?? [];
  return notes.where((n) => n.id == id).firstOrNull;
}
