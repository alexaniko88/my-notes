abstract class AudioStorageRepository {
  /// Uploads the local audio file at [filePath] for the note [noteId] and
  /// returns its download URL. Throws [AudioStorageException] on failure
  /// (including when offline — Storage uploads are not queued like Firestore
  /// writes).
  Future<String> upload({required String noteId, required String filePath});

  /// Deletes the stored audio blob for [noteId]. A no-op if no blob exists.
  Future<void> delete(String noteId);
}
