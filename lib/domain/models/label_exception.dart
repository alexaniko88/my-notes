import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class LabelException extends Equatable implements Exception {
  final String message;
  final Object? cause;

  const LabelException(this.message, {this.cause});

  @override
  List<Object?> get props => [message, cause];

  @override
  String toString() =>
      cause != null
          ? 'LabelException: $message (cause: $cause)'
          : 'LabelException: $message';
}
