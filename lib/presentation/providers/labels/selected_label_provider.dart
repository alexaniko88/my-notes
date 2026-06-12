import 'package:my_notes/presentation/providers/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_label_provider.g.dart';

/// The label the notes list is currently filtered by; null shows all notes.
/// Kept alive so the selection survives drawer close/open for the session.
@Riverpod(keepAlive: true)
class SelectedLabelNotifier extends _$SelectedLabelNotifier {
  @override
  String? build() {
    // reset the selection whenever the signed-in user changes
    ref.watch(authStateProvider);
    return null;
  }

  void toggle(String labelId) {
    state = state == labelId ? null : labelId;
  }

  void clearIf(String labelId) {
    if (state == labelId) {
      state = null;
    }
  }
}
