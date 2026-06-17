import 'package:my_notes/presentation/providers/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_trash_provider.g.dart';

/// Whether the notes list is currently filtered to show trashed notes.
/// Kept alive so the selection survives drawer close/open for the session.
@Riverpod(keepAlive: true)
class SelectedTrashNotifier extends _$SelectedTrashNotifier {
  @override
  bool build() {
    // reset the selection whenever the signed-in user changes
    ref.watch(authStateProvider);
    return false;
  }

  void toggle() {
    state = !state;
  }

  void clear() {
    state = false;
  }
}
