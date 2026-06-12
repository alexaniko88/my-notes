import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class AppUser extends Equatable {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  const AppUser({
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [id, email, displayName, photoUrl];

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
