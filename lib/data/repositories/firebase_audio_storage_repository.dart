import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_notes/data/storage_paths.dart';
import 'package:my_notes/domain/models/audio_storage_exception.dart';
import 'package:my_notes/domain/repositories/audio_storage_repository.dart';

class FirebaseAudioStorageRepository implements AudioStorageRepository {
  static const _contentType = 'audio/mp4';

  final String _userId;
  final FirebaseStorage _storage;

  FirebaseAudioStorageRepository({
    required String userId,
    FirebaseStorage? storage,
  }) : _userId = userId,
       _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<String> upload({
    required String noteId,
    required String filePath,
  }) async {
    try {
      final ref = _storage.ref(StoragePaths.voiceNote(_userId, noteId));
      await ref.putFile(
        File(filePath),
        SettableMetadata(contentType: _contentType),
      );
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw AudioStorageException('Failed to upload voice note', cause: e);
    }
  }

  @override
  Future<void> delete(String noteId) async {
    try {
      await _storage.ref(StoragePaths.voiceNote(_userId, noteId)).delete();
    } on FirebaseException catch (e) {
      // Blob already gone (or never uploaded) — nothing to clean up.
      if (e.code == 'object-not-found') {
        return;
      }
      throw AudioStorageException('Failed to delete voice note', cause: e);
    }
  }
}
