import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes/data/dtos/label_dto.dart';
import 'package:my_notes/data/firestore_paths.dart';
import 'package:my_notes/domain/models/label.dart';
import 'package:my_notes/domain/models/label_exception.dart';
import 'package:my_notes/domain/repositories/label_repository.dart';

class FirebaseLabelRepository implements LabelRepository {
  final CollectionReference<Map<String, dynamic>> _labelsCollection;

  FirebaseLabelRepository({required String userId})
    : _labelsCollection = FirebaseFirestore.instance
          .collection(FirestorePaths.users)
          .doc(userId)
          .collection(FirestorePaths.labels);

  @override
  Stream<List<Label>> watchAll() {
    return _labelsCollection
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) =>
                        LabelDto.fromFirestore(doc.data(), doc.id).toLabel(),
                  )
                  .toList(),
        )
        .handleError((Object e) {
          throw LabelException('Failed to watch labels', cause: e);
        });
  }

  @override
  Future<Label?> getLabel(String id) async {
    try {
      final doc = await _labelsCollection.doc(id).get();
      final data = doc.data();
      if (data == null) {
        return null;
      }
      return LabelDto.fromFirestore(data, doc.id).toLabel();
    } on FirebaseException catch (e) {
      throw LabelException('Failed to get label', cause: e);
    }
  }

  @override
  Future<String> add(Label label) async {
    try {
      await _labelsCollection
          .doc(label.id)
          .set(LabelDto.fromLabel(label).toFirestore());
      return label.id;
    } on FirebaseException catch (e) {
      throw LabelException('Failed to add label', cause: e);
    }
  }

  @override
  Future<String> update(Label label) async {
    try {
      await _labelsCollection
          .doc(label.id)
          .update(LabelDto.fromLabel(label).toFirestore());
      return label.id;
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw LabelException('Label not found', cause: e);
      }
      throw LabelException('Failed to update label', cause: e);
    }
  }

  @override
  Future<String> delete(String id) async {
    try {
      await _labelsCollection.doc(id).delete();
      return id;
    } on FirebaseException catch (e) {
      throw LabelException('Failed to delete label', cause: e);
    }
  }
}
