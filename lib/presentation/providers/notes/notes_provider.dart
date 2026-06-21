import 'dart:async';

import 'package:my_notes/data/repositories/firebase_audio_storage_repository.dart';
import 'package:my_notes/data/repositories/firebase_note_repository.dart';
import 'package:my_notes/domain/models/audio_storage_exception.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/domain/models/note_exception.dart';
import 'package:my_notes/domain/models/note_type.dart';
import 'package:my_notes/domain/repositories/audio_storage_repository.dart';
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

@Riverpod(keepAlive: true)
AudioStorageRepository audioStorageRepository(Ref ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) throw StateError('Not authenticated');
  return FirebaseAudioStorageRepository(userId: user.id);
}

@riverpod
class NotesNotifier extends _$NotesNotifier {
  NoteRepository get _repo => ref.read(noteRepositoryProvider);

  @override
  Stream<List<Note>> build() {
    final repo = ref.watch(noteRepositoryProvider);
    // Best-effort cleanup of notes whose trash retention has elapsed; runs
    // once when the notes stream initializes (app launch / auth change).
    unawaited(_purgeExpiredTrash(repo));
    return repo.watchAll();
  }

  Future<void> _purgeExpiredTrash(NoteRepository repo) async {
    final cutoff = DateTime.now().subtract(Note.trashRetention);
    try {
      await repo.purgeExpired(cutoff);
    } on NoteException {
      // Purge is best-effort; ignore failures and retry on the next launch.
    }
  }

  Future<String> add({
    NoteType type = NoteType.text,
    String? title,
    String? body,
    String? filePath,
    List<String> labelIds = const [],
    int? color,
    bool isPinned = false,
  }) async {
    final validLabelIds = _validateLabelIds(labelIds);
    final id = _uuid.v4();
    final fileUrl = await _uploadFile(id, type, filePath);
    final now = DateTime.now();
    final notes = state.asData?.value ?? [];
    await _repo.add(
      Note(
        id: id,
        type: type,
        title: title,
        body: body,
        fileUrl: fileUrl,
        labelIds: validLabelIds,
        color: color,
        position: notes.length,
        isPinned: isPinned,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return id;
  }

  /// Uploads a note's local [filePath] (if any) to the right Storage location
  /// for its [type] and returns the download URL. Runs before the note is
  /// created so the note only exists once it has a durable URL. Throws
  /// [AudioStorageException] on failure (e.g. offline — Storage uploads are
  /// not queued like Firestore writes).
  Future<String?> _uploadFile(String id, NoteType type, String? filePath) {
    if (filePath == null) {
      return Future.value();
    }
    return switch (type) {
      NoteType.voice => ref
          .read(audioStorageRepositoryProvider)
          .upload(noteId: id, filePath: filePath),
      NoteType.text || NoteType.image || NoteType.pdf =>
        throw UnimplementedError(
          'File upload for $type notes is not implemented yet',
        ),
    };
  }

  Future<void> updateNote(Note note) async {
    await _repo.update(note.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> delete(String id) async {
    final notes = state.asData?.value ?? [];
    final note = notes.where((n) => n.id == id).firstOrNull;
    // Permanently removing a voice note must also remove its Storage blob.
    // Best-effort: a failed cleanup shouldn't block deleting the note itself.
    if (note != null && note.type == NoteType.voice) {
      try {
        await ref.read(audioStorageRepositoryProvider).delete(id);
      } on AudioStorageException {
        // Leave the blob; the note is still removed from Firestore below.
      }
    }
    await _repo.delete(id);
  }

  Future<void> moveToTrash(String id) async {
    await _repo.moveToTrash(id);
  }

  Future<void> restore(String id) async {
    await _repo.restore(id);
  }

  /// Persists the given active-note ordering, writing each note's list index
  /// as its `position`. Only notes whose position actually changed are sent.
  Future<void> persistOrder(List<Note> orderedActive) async {
    final changed = <String, int>{};
    for (var index = 0; index < orderedActive.length; index++) {
      final note = orderedActive[index];
      if (note.position != index) {
        changed[note.id] = index;
      }
    }
    if (changed.isEmpty) return;
    await _repo.updatePositions(changed);
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

/// Active (non-trashed) notes, preserving the repository's position order.
@riverpod
List<Note> activeNotes(Ref ref) {
  final notes = ref.watch(notesProvider).asData?.value ?? const [];
  return notes.where((n) => !n.isTrashed).toList();
}

/// Trashed notes, most recently deleted first.
@riverpod
List<Note> trashedNotes(Ref ref) {
  final notes = ref.watch(notesProvider).asData?.value ?? const [];
  final trashed = notes.where((n) => n.isTrashed).toList();
  trashed.sort((a, b) {
    final aDeleted = a.deletedAt;
    final bDeleted = b.deletedAt;
    if (aDeleted == null || bDeleted == null) {
      return 0;
    }
    return bDeleted.compareTo(aDeleted);
  });
  return trashed;
}
