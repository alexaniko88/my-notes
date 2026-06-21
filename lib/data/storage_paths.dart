abstract class StoragePaths {
  static const users = 'users';
  static const notes = 'notes';

  /// Firebase Storage object path for a note's audio blob:
  /// `users/{userId}/notes/{noteId}.m4a`.
  static String voiceNote(String userId, String noteId) =>
      '$users/$userId/$notes/$noteId.m4a';
}
