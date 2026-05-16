import 'package:go_router/go_router.dart';
import 'package:my_notes/presentation/screens/home_screen.dart';
import 'package:my_notes/presentation/screens/note/note_screen.dart';
import 'package:my_notes/presentation/screens/playground/playground_item_screen.dart';
import 'package:my_notes/presentation/screens/playground/playground_screen.dart';
import 'package:my_notes/shared/navigation/app_route.dart';

final appRouter = GoRouter(
  initialLocation: AppRoute.home.path,
  routes: [
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
        config: state.extra! as PlaygroundItemConfig, // always set — only pushed from PlaygroundScreen with extra
      ),
    ),
    GoRoute(
      path: AppRoute.note.path,
      name: AppRoute.note.name,
      builder: (context, state) => NoteScreen(
        noteId: state.pathParameters['id']!, // go_router guarantees :id present on this route
      ),
    ),
  ],
);
