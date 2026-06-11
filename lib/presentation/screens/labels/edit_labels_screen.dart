import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/domain/models/label.dart';
import 'package:my_notes/domain/models/label_exception.dart';
import 'package:my_notes/presentation/providers/labels/labels_provider.dart';
import 'package:my_notes/presentation/widgets/common/app_text_button.dart';
import 'package:my_notes/presentation/widgets/labels/label_create_field.dart';
import 'package:my_notes/presentation/widgets/labels/label_edit_tile.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class EditLabelsScreen extends ConsumerStatefulWidget {
  const EditLabelsScreen({super.key});

  @override
  ConsumerState<EditLabelsScreen> createState() => _EditLabelsScreenState();
}

class _EditLabelsScreenState extends ConsumerState<EditLabelsScreen> {
  final TextEditingController _createController = TextEditingController();
  TextEditingController? _editController;
  bool _isCreating = false;
  String? _editingLabelId;

  @override
  void dispose() {
    _createController.dispose();
    _editController?.dispose();
    super.dispose();
  }

  // The edit TextField is still attached to the controller during the rebuild
  // that removes it, so disposal has to wait until the frame is done.
  void _releaseEditController() {
    final controller = _editController;
    _editController = null;
    if (controller != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
    }
  }

  // Resets the create row and any row edit to idle — call inside setState.
  void _closeAllEditors() {
    _isCreating = false;
    _createController.clear();
    _editingLabelId = null;
    _releaseEditController();
  }

  void _activateCreate() {
    setState(() {
      _closeAllEditors();
      _isCreating = true;
    });
  }

  void _cancelCreate() {
    setState(_closeAllEditors);
  }

  Future<void> _confirmCreate(String name) async {
    try {
      await ref.read(labelsProvider.notifier).add(name);
      if (mounted) {
        setState(_closeAllEditors);
      }
    } on LabelException {
      _showSaveError();
    }
  }

  void _startEdit(Label label) {
    setState(() {
      _closeAllEditors();
      _editController = TextEditingController(text: label.name);
      _editingLabelId = label.id;
    });
  }

  Future<void> _confirmEdit(String id, String name) async {
    try {
      await ref.read(labelsProvider.notifier).rename(id, name);
      if (mounted) {
        setState(_closeAllEditors);
      }
    } on LabelException {
      _showSaveError();
    }
  }

  Future<void> _onDelete(Label label) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteLabelDialogTitle),
        content: Text(l10n.deleteLabelDialogBody),
        actions: [
          AppTextButton(
            label: l10n.exitAppCancel,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          AppTextButton(
            label: l10n.deleteLabelConfirm,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    try {
      await ref.read(labelsProvider.notifier).remove(label.id);
      if (mounted) {
        setState(_closeAllEditors);
      }
    } on LabelException {
      _showSaveError();
    }
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
    final dimensions = context.dimensions;
    final labelsAsync = ref.watch(labelsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.editLabelsTitle),
      ),
      body: labelsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.labelsLoadError)),
        data: (labels) => ListView(
          padding: EdgeInsets.symmetric(vertical: dimensions.spacing.sm),
          children: [
            LabelCreateField(
              isActive: _isCreating,
              controller: _createController,
              onActivate: _activateCreate,
              onCancel: _cancelCreate,
              onConfirm: _confirmCreate,
            ),
            for (final label in labels)
              LabelEditTile(
                key: ValueKey(label.id),
                label: label.name,
                isEditing: _editingLabelId == label.id,
                controller:
                    _editingLabelId == label.id ? _editController : null,
                onStartEdit: () => _startEdit(label),
                onDelete: () => _onDelete(label),
                onConfirm: (name) => _confirmEdit(label.id, name),
              ),
          ],
        ),
      ),
    );
  }
}
