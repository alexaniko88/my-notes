import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes/data/dtos/note_dto.dart';
import 'package:my_notes/data/firestore_paths.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/domain/models/note_exception.dart';
import 'package:my_notes/domain/repositories/note_repository.dart';

class FirebaseNoteRepository implements NoteRepository {
  final CollectionReference<Map<String, dynamic>> _notesCollection;

  FirebaseNoteRepository({required String userId})
    : _notesCollection = FirebaseFirestore.instance
          .collection(FirestorePaths.users)
          .doc(userId)
          .collection(FirestorePaths.notes);

  @override
  Stream<List<Note>> watchAll() {
    return _notesCollection
        .orderBy('position')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => NoteDto.fromFirestore(doc.data(), doc.id).toNote(),
                  )
                  .toList(),
        )
        .handleError((Object e) {
          throw NoteException('Failed to watch notes', cause: e);
        });
  }

  @override
  Future<Note?> getNote(String id) async {
    try {
      final doc = await _notesCollection.doc(id).get();
      final data = doc.data();
      if (data == null) {
        return null;
      }
      return NoteDto.fromFirestore(data, doc.id).toNote();
    } on FirebaseException catch (e) {
      throw NoteException('Failed to get note', cause: e);
    }
  }

  @override
  Future<String> add(Note note) async {
    try {
      await _notesCollection
          .doc(note.id)
          .set(NoteDto.fromNote(note).toFirestore());
      return note.id;
    } on FirebaseException catch (e) {
      throw NoteException('Failed to add note', cause: e);
    }
  }

  @override
  Future<String> update(Note note) async {
    try {
      await _notesCollection
          .doc(note.id)
          .update(NoteDto.fromNote(note).toFirestore());
      return note.id;
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw NoteException('Note not found', cause: e);
      }
      throw NoteException('Failed to update note', cause: e);
    }
  }

  @override
  Future<String> delete(String id) async {
    try {
      await _notesCollection.doc(id).delete();
      return id;
    } on FirebaseException catch (e) {
      throw NoteException('Failed to delete note', cause: e);
    }
  }

  @override
  Future<void> moveToTrash(String id) async {
    try {
      await _notesCollection.doc(id).update({'deletedAt': Timestamp.now()});
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw NoteException('Note not found', cause: e);
      }
      throw NoteException('Failed to move note to trash', cause: e);
    }
  }

  @override
  Future<void> restore(String id) async {
    try {
      await _notesCollection.doc(id).update({'deletedAt': null});
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw NoteException('Note not found', cause: e);
      }
      throw NoteException('Failed to restore note', cause: e);
    }
  }

  @override
  Future<int> purgeExpired(DateTime cutoff) async {
    try {
      final snapshot =
          await _notesCollection
              .where(
                'deletedAt',
                isLessThanOrEqualTo: Timestamp.fromDate(cutoff),
              )
              .get();
      if (snapshot.docs.isEmpty) {
        return 0;
      }
      final batch = _notesCollection.firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      return snapshot.docs.length;
    } on FirebaseException catch (e) {
      throw NoteException('Failed to purge expired notes', cause: e);
    }
  }

  @override
  Future<void> clearLabel(String labelId) async {
    try {
      final snapshot =
          await _notesCollection
              .where('labelIds', arrayContains: labelId)
              .get();
      if (snapshot.docs.isEmpty) {
        return;
      }
      final batch = _notesCollection.firestore.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          'labelIds': FieldValue.arrayRemove([labelId]),
        });
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw NoteException('Failed to clear label from notes', cause: e);
    }
  }
}
