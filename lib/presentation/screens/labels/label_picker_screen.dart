import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/domain/models/label.dart';
import 'package:my_notes/domain/models/label_exception.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/presentation/providers/labels/labels_provider.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

/// Multi-select label picker. Pops with the selected label ids as a
/// `List<String>`; persisting them on the note is the caller's job.
class LabelPickerScreen extends ConsumerStatefulWidget {
  final List<String> initialSelectedIds;

  const LabelPickerScreen({
    super.key,
    this.initialSelectedIds = const [],
  });

  @override
  ConsumerState<LabelPickerScreen> createState() => _LabelPickerScreenState();
}

class _LabelPickerScreenState extends ConsumerState<LabelPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final Set<String> _selectedIds = {...widget.initialSelectedIds};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _pop() {
    context.pop(_selectedIds.toList());
  }

  void _toggle(String labelId) {
    if (_selectedIds.contains(labelId)) {
      setState(() => _selectedIds.remove(labelId));
      return;
    }
    if (_selectedIds.length >= Note.maxLabels) {
      _showMaxReached();
      return;
    }
    setState(() => _selectedIds.add(labelId));
  }

  Future<void> _createLabel(String name) async {
    if (_selectedIds.length >= Note.maxLabels) {
      _showMaxReached();
      return;
    }
    try {
      final id = await ref.read(labelsProvider.notifier).add(name);
      if (!mounted) {
        return;
      }
      setState(() {
        _searchController.clear();
        _selectedIds.add(id);
      });
    } on LabelException {
      _showSaveError();
    }
  }

  void _showMaxReached() {
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.labelMaxReached(Note.maxLabels))),
    );
  }

  void _showSaveError() {
    if (!mounted) {
      return;
    }
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.labelSaveError)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final hintStyle = theme.textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
    );
    final labelsAsync = ref.watch(labelsProvider);
    final query = _searchController.text.trim();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: _pop),
          title: TextField(
            controller: _searchController,
            maxLength: Label.maxNameLength,
            decoration: InputDecoration(
              hintText: l10n.labelSearchHint,
              hintStyle: hintStyle,
              border: InputBorder.none,
              counterText: '',
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        body: labelsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(child: Text(l10n.labelsLoadError)),
          data: (labels) {
            final lowerQuery = query.toLowerCase();
            final filteredLabels = query.isEmpty
                ? labels
                : labels
                    .where((l) => l.name.toLowerCase().contains(lowerQuery))
                    .toList();
            final hasExactMatch =
                labels.any((l) => l.name.toLowerCase() == lowerQuery);
            final showCreateRow = query.isNotEmpty && !hasExactMatch;

            return ListView(
              children: [
                if (showCreateRow)
                  ListTile(
                    leading: const AppIcon(name: AppIconName.add),
                    title: Text(l10n.labelCreateNew(query)),
                    onTap: () => _createLabel(query),
                  ),
                for (final label in filteredLabels)
                  ListTile(
                    leading: const AppIcon(name: AppIconName.labelOutlined),
                    title: Text(label.name),
                    trailing: Checkbox(
                      value: _selectedIds.contains(label.id),
                      onChanged: (_) => _toggle(label.id),
                    ),
                    onTap: () => _toggle(label.id),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
