import 'package:my_notes/data/repositories/firebase_auth_repository.dart';
import 'package:my_notes/domain/models/app_user.dart';
import 'package:my_notes/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => FirebaseAuthRepository();

@Riverpod(keepAlive: true)
Stream<AppUser?> authState(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  FutureOr<void> build() {}

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(_repo.signInWithGoogle);
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    await AsyncValue.guard(_repo.signOut);
  }
}
