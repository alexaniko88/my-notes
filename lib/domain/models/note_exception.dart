import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class NoteException extends Equatable implements Exception {
  final String message;
  final Object? cause;

  const NoteException(this.message, {this.cause});

  @override
  List<Object?> get props => [message, cause];

  @override
  String toString() =>
      cause != null
          ? 'NoteException: $message (cause: $cause)'
          : 'NoteException: $message';
}
