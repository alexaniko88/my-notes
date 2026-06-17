import 'package:my_notes/domain/models/note.dart';

abstract class NoteRepository {
  Stream<List<Note>> watchAll();

  Future<Note?> getNote(String id);

  Future<String> add(Note note);

  Future<String> update(Note note);

  Future<String> delete(String id);

  /// Marks the note as trashed by stamping its `deletedAt`.
  Future<void> moveToTrash(String id);

  /// Clears a note's `deletedAt`, returning it to the active list.
  Future<void> restore(String id);

  /// Permanently deletes every trashed note whose `deletedAt` is at or before
  /// [cutoff]. Returns the number of notes purged.
  Future<int> purgeExpired(DateTime cutoff);

  /// Removes the label reference from every note that links [labelId].
  Future<void> clearLabel(String labelId);
}
