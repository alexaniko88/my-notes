import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class AudioStorageException extends Equatable implements Exception {
  final String message;
  final Object? cause;

  const AudioStorageException(this.message, {this.cause});

  @override
  List<Object?> get props => [message, cause];

  @override
  String toString() =>
      cause != null
          ? 'AudioStorageException: $message (cause: $cause)'
          : 'AudioStorageException: $message';
}
