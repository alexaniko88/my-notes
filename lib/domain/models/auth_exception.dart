import 'package:meta/meta.dart';

@immutable
sealed class AuthException implements Exception {
  const AuthException();
}

@immutable
final class AuthCancelledException extends AuthException {
  const AuthCancelledException();
}

@immutable
final class AuthNetworkException extends AuthException {
  const AuthNetworkException();
}

@immutable
final class AuthUnknownException extends AuthException {
  final String message;

  const AuthUnknownException(this.message);
}
