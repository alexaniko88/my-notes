// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'labels_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(labelRepository)
final labelRepositoryProvider = LabelRepositoryProvider._();

final class LabelRepositoryProvider extends $FunctionalProvider<LabelRepository,
    LabelRepository, LabelRepository> with $Provider<LabelRepository> {
  LabelRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'labelRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$labelRepositoryHash();

  @$internal
  @override
  $ProviderElement<LabelRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LabelRepository create(Ref ref) {
    return labelRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LabelRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LabelRepository>(value),
    );
  }
}

String _$labelRepositoryHash() => r'ef0e767461766ef4384f6e722c6fb690d35c87bb';

@ProviderFor(LabelsNotifier)
final labelsProvider = LabelsNotifierProvider._();

final class LabelsNotifierProvider
    extends $StreamNotifierProvider<LabelsNotifier, List<Label>> {
  LabelsNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'labelsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$labelsNotifierHash();

  @$internal
  @override
  LabelsNotifier create() => LabelsNotifier();
}

String _$labelsNotifierHash() => r'814778f0bb03ce74f9cc0e6b6b7825979c475581';

abstract class _$LabelsNotifier extends $StreamNotifier<List<Label>> {
  Stream<List<Label>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Label>>, List<Label>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Label>>, List<Label>>,
        AsyncValue<List<Label>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(label)
final labelProvider = LabelFamily._();

final class LabelProvider extends $FunctionalProvider<Label?, Label?, Label?>
    with $Provider<Label?> {
  LabelProvider._(
      {required LabelFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'labelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$labelHash();

  @override
  String toString() {
    return r'labelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Label?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Label? create(Ref ref) {
    final argument = this.argument as String;
    return label(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Label? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Label?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LabelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$labelHash() => r'cd1fb84795c7041b90e994009fe1a22a94693f82';

final class LabelFamily extends $Family
    with $FunctionalFamilyOverride<Label?, String> {
  LabelFamily._()
      : super(
          retry: null,
          name: r'labelProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  LabelProvider call(
    String id,
  ) =>
      LabelProvider._(argument: id, from: this);

  @override
  String toString() => r'labelProvider';
}
