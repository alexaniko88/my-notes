// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_label_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The label the notes list is currently filtered by; null shows all notes.
/// Kept alive so the selection survives drawer close/open for the session.

@ProviderFor(SelectedLabelNotifier)
final selectedLabelProvider = SelectedLabelNotifierProvider._();

/// The label the notes list is currently filtered by; null shows all notes.
/// Kept alive so the selection survives drawer close/open for the session.
final class SelectedLabelNotifierProvider
    extends $NotifierProvider<SelectedLabelNotifier, String?> {
  /// The label the notes list is currently filtered by; null shows all notes.
  /// Kept alive so the selection survives drawer close/open for the session.
  SelectedLabelNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedLabelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedLabelNotifierHash();

  @$internal
  @override
  SelectedLabelNotifier create() => SelectedLabelNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedLabelNotifierHash() =>
    r'77d743cd5a1205faf6ca4c7fc21e627905aefcd1';

/// The label the notes list is currently filtered by; null shows all notes.
/// Kept alive so the selection survives drawer close/open for the session.

abstract class _$SelectedLabelNotifier extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
