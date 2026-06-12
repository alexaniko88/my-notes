import 'package:my_notes/data/repositories/firebase_label_repository.dart';
import 'package:my_notes/domain/models/label.dart';
import 'package:my_notes/domain/models/label_exception.dart';
import 'package:my_notes/domain/repositories/label_repository.dart';
import 'package:my_notes/presentation/providers/auth/auth_provider.dart';
import 'package:my_notes/presentation/providers/labels/selected_label_provider.dart';
import 'package:my_notes/presentation/providers/notes/notes_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'labels_provider.g.dart';

const _uuid = Uuid();

@Riverpod(keepAlive: true)
LabelRepository labelRepository(Ref ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) throw StateError('Not authenticated');
  return FirebaseLabelRepository(userId: user.id);
}

@riverpod
class LabelsNotifier extends _$LabelsNotifier {
  LabelRepository get _repo => ref.read(labelRepositoryProvider);

  @override
  Stream<List<Label>> build() => ref.watch(labelRepositoryProvider).watchAll();

  Future<String> add(String name) async {
    final validName = _validateName(name);
    final id = _uuid.v4();
    await _repo.add(Label(id: id, name: validName));
    return id;
  }

  Future<void> rename(String id, String name) async {
    final validName = _validateName(name, ignoreId: id);
    await _repo.update(Label(id: id, name: validName));
  }

  Future<void> remove(String id) async {
    await _repo.delete(id);
    await ref.read(noteRepositoryProvider).clearLabel(id);
    ref.read(selectedLabelProvider.notifier).clearIf(id);
  }

  String _validateName(String name, {String? ignoreId}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const LabelException('Label name cannot be empty');
    }
    if (trimmed.length > Label.maxNameLength) {
      throw const LabelException('Label name is too long');
    }
    final labels = state.asData?.value ?? [];
    final lowerName = trimmed.toLowerCase();
    final isDuplicate = labels.any(
      (label) => label.id != ignoreId && label.name.toLowerCase() == lowerName,
    );
    if (isDuplicate) {
      throw const LabelException('Label name already exists');
    }
    return trimmed;
  }
}

@riverpod
Label? label(Ref ref, String id) {
  final labels = ref.watch(labelsProvider).asData?.value ?? [];
  return labels.where((label) => label.id == id).firstOrNull;
}
