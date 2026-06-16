// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_trash_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the notes list is currently filtered to show trashed notes.
/// Kept alive so the selection survives drawer close/open for the session.

@ProviderFor(SelectedTrashNotifier)
final selectedTrashProvider = SelectedTrashNotifierProvider._();

/// Whether the notes list is currently filtered to show trashed notes.
/// Kept alive so the selection survives drawer close/open for the session.
final class SelectedTrashNotifierProvider
    extends $NotifierProvider<SelectedTrashNotifier, bool> {
  /// Whether the notes list is currently filtered to show trashed notes.
  /// Kept alive so the selection survives drawer close/open for the session.
  SelectedTrashNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedTrashProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedTrashNotifierHash();

  @$internal
  @override
  SelectedTrashNotifier create() => SelectedTrashNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$selectedTrashNotifierHash() =>
    r'9cb8cb9b557a74882e4f9cca762249326a298f85';

/// Whether the notes list is currently filtered to show trashed notes.
/// Kept alive so the selection survives drawer close/open for the session.

abstract class _$SelectedTrashNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
