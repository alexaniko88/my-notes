import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/presentation/providers/auth/auth_provider.dart';
import 'package:my_notes/presentation/screens/auth/auth_screen.dart';
import 'package:my_notes/presentation/screens/home_screen.dart';
import 'package:my_notes/presentation/screens/note/note_screen.dart';
import 'package:my_notes/presentation/screens/playground/playground_item_screen.dart';
import 'package:my_notes/presentation/screens/playground/playground_screen.dart';
import 'package:my_notes/shared/navigation/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final listenable = _AuthListenable();
  ref.listen(authStateProvider, (_, __) => listenable.notify());
  ref.onDispose(listenable.dispose);

  return GoRouter(
    initialLocation: AppRoute.auth.path,
    refreshListenable: listenable,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      if (authState.isLoading) return null;
      final isLoggedIn = authState.asData?.value != null;
      final isOnAuth = state.matchedLocation == AppRoute.auth.path;
      if (!isLoggedIn && !isOnAuth) return AppRoute.auth.path;
      if (isLoggedIn && isOnAuth) return AppRoute.home.path;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoute.auth.path,
        name: AppRoute.auth.name,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoute.playground.path,
        name: AppRoute.playground.name,
        builder: (context, state) => const PlaygroundScreen(),
      ),
      GoRoute(
        path: AppRoute.playgroundItem.path,
        name: AppRoute.playgroundItem.name,
        builder: (context, state) => PlaygroundItemScreen(
          config: state.extra!
              as PlaygroundItemConfig, // always set — only pushed from PlaygroundScreen with extra
        ),
      ),
      GoRoute(
        path: AppRoute.note.path,
        name: AppRoute.note.name,
        builder: (context, state) => NoteScreen(
          noteId: state.pathParameters[
              'id']!, // go_router guarantees :id present on this route
        ),
      ),
    ],
  );
}

class _AuthListenable extends ChangeNotifier {
  void notify() => notifyListeners();
}
