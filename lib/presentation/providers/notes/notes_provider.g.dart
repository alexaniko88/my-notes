// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(noteRepository)
final noteRepositoryProvider = NoteRepositoryProvider._();

final class NoteRepositoryProvider
    extends $FunctionalProvider<NoteRepository, NoteRepository, NoteRepository>
    with $Provider<NoteRepository> {
  NoteRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'noteRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$noteRepositoryHash();

  @$internal
  @override
  $ProviderElement<NoteRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NoteRepository create(Ref ref) {
    return noteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NoteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NoteRepository>(value),
    );
  }
}

String _$noteRepositoryHash() => r'f54200dfddf4fb6cc4303ff3520bc2d1cd1e213b';

@ProviderFor(note)
final noteProvider = NoteFamily._();

final class NoteProvider extends $FunctionalProvider<Note, Note, Note>
    with $Provider<Note> {
  NoteProvider._(
      {required NoteFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'noteProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$noteHash();

  @override
  String toString() {
    return r'noteProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Note> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Note create(Ref ref) {
    final argument = this.argument as String;
    return note(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Note value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Note>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NoteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$noteHash() => r'0745703fb79fae02f1d1dea3d988dc847575ef25';

final class NoteFamily extends $Family
    with $FunctionalFamilyOverride<Note, String> {
  NoteFamily._()
      : super(
          retry: null,
          name: r'noteProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  NoteProvider call(
    String id,
  ) =>
      NoteProvider._(argument: id, from: this);

  @override
  String toString() => r'noteProvider';
}

@ProviderFor(NotesNotifier)
final notesProvider = NotesNotifierProvider._();

final class NotesNotifierProvider
    extends $NotifierProvider<NotesNotifier, List<Note>> {
  NotesNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notesNotifierHash();

  @$internal
  @override
  NotesNotifier create() => NotesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Note> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Note>>(value),
    );
  }
}

String _$notesNotifierHash() => r'a8a8921761a79f26a3fae50b104b20804e795242';

abstract class _$NotesNotifier extends $Notifier<List<Note>> {
  List<Note> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<Note>, List<Note>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<Note>, List<Note>>, List<Note>, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
