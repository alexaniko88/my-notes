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

String _$noteRepositoryHash() => r'0b399e600acb9a155b99283ed3b060738299a727';

@ProviderFor(audioStorageRepository)
final audioStorageRepositoryProvider = AudioStorageRepositoryProvider._();

final class AudioStorageRepositoryProvider
    extends
        $FunctionalProvider<
          AudioStorageRepository,
          AudioStorageRepository,
          AudioStorageRepository
        >
    with $Provider<AudioStorageRepository> {
  AudioStorageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioStorageRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioStorageRepositoryHash();

  @$internal
  @override
  $ProviderElement<AudioStorageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AudioStorageRepository create(Ref ref) {
    return audioStorageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioStorageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioStorageRepository>(value),
    );
  }
}

String _$audioStorageRepositoryHash() =>
    r'a38370ebb39bed0f6d180a446ba95c09ca97f87f';

@ProviderFor(NotesNotifier)
final notesProvider = NotesNotifierProvider._();

final class NotesNotifierProvider
    extends $StreamNotifierProvider<NotesNotifier, List<Note>> {
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
}

String _$notesNotifierHash() => r'1d83b091332ade4122c5d8d0891ad7af8c0e6be2';

abstract class _$NotesNotifier extends $StreamNotifier<List<Note>> {
  Stream<List<Note>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Note>>, List<Note>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Note>>, List<Note>>,
              AsyncValue<List<Note>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(note)
final noteProvider = NoteFamily._();

final class NoteProvider extends $FunctionalProvider<Note?, Note?, Note?>
    with $Provider<Note?> {
  NoteProvider._({
    required NoteFamily super.from,
    required String super.argument,
  }) : super(
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
  $ProviderElement<Note?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Note? create(Ref ref) {
    final argument = this.argument as String;
    return note(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Note? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Note?>(value),
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

String _$noteHash() => r'9eb48421da1f6cc19e5f297f15d462ba7857e259';

final class NoteFamily extends $Family
    with $FunctionalFamilyOverride<Note?, String> {
  NoteFamily._()
    : super(
        retry: null,
        name: r'noteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NoteProvider call(String id) => NoteProvider._(argument: id, from: this);

  @override
  String toString() => r'noteProvider';
}

/// Active (non-trashed) notes, preserving the repository's position order.

@ProviderFor(activeNotes)
final activeNotesProvider = ActiveNotesProvider._();

/// Active (non-trashed) notes, preserving the repository's position order.

final class ActiveNotesProvider
    extends $FunctionalProvider<List<Note>, List<Note>, List<Note>>
    with $Provider<List<Note>> {
  /// Active (non-trashed) notes, preserving the repository's position order.
  ActiveNotesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeNotesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeNotesHash();

  @$internal
  @override
  $ProviderElement<List<Note>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Note> create(Ref ref) {
    return activeNotes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Note> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Note>>(value),
    );
  }
}

String _$activeNotesHash() => r'f066d58b0e9d930d7c7185c3d6d2f5f81acf5d7c';

/// Trashed notes, most recently deleted first.

@ProviderFor(trashedNotes)
final trashedNotesProvider = TrashedNotesProvider._();

/// Trashed notes, most recently deleted first.

final class TrashedNotesProvider
    extends $FunctionalProvider<List<Note>, List<Note>, List<Note>>
    with $Provider<List<Note>> {
  /// Trashed notes, most recently deleted first.
  TrashedNotesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trashedNotesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trashedNotesHash();

  @$internal
  @override
  $ProviderElement<List<Note>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Note> create(Ref ref) {
    return trashedNotes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Note> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Note>>(value),
    );
  }
}

String _$trashedNotesHash() => r'c178e8ecf69690df3bd35277653b5a829e086b88';
