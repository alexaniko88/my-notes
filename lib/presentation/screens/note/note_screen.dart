import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/domain/models/note_exception.dart';
import 'package:my_notes/domain/models/note_type.dart';
import 'package:my_notes/presentation/providers/labels/labels_provider.dart';
import 'package:my_notes/presentation/providers/notes/notes_provider.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/presentation/widgets/common/app_icon_button.dart';
import 'package:my_notes/presentation/widgets/common/app_text_button.dart';
import 'package:my_notes/presentation/widgets/labels/label_tag.dart';
import 'package:my_notes/presentation/widgets/note/note_options_sheet.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';
import 'package:my_notes/shared/navigation/app_route.dart';

class NoteScreen extends ConsumerStatefulWidget {
  final String? noteId;
  final NoteType? noteType;

  const NoteScreen({super.key, this.noteId, this.noteType});

  @override
  ConsumerState<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends ConsumerState<NoteScreen>
    with WidgetsBindingObserver {
  static const _disabledOpacity = 0.5;

  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  final FocusNode _bodyFocusNode = FocusNode();
  List<String> _labelIds = [];
  int? _noteColor;
  String? _noteId;
  bool _isPinned = false;
  bool _isSaving = false;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _noteId = widget.noteId;

    if (_noteId != null) {
      final note = ref.read(noteProvider(_noteId!));
      _titleController = TextEditingController(text: note?.title ?? '');
      _bodyController = TextEditingController(text: note?.body ?? '');
      _labelIds = [...?note?.labelIds];
      _noteColor = note?.color;
      _isPinned = note?.isPinned ?? false;
    } else {
      _titleController = TextEditingController();
      _bodyController = TextEditingController();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _save();
    }
  }

  Future<void> _save() async {
    if (_isSaving || _isClosing) return;
    final title = _titleController.text.isEmpty ? null : _titleController.text;
    final body = _bodyController.text.isEmpty ? null : _bodyController.text;

    if (_noteId == null) {
      if (title == null && body == null) return;
      _isSaving = true;
      try {
        _noteId = await ref
            .read(notesProvider.notifier)
            .add(
              title: title,
              body: body,
              labelIds: _labelIds,
              isPinned: _isPinned,
            );
      } finally {
        _isSaving = false;
      }
    } else {
      final notes = ref.read(notesProvider).asData?.value ?? [];
      final note = notes.where((n) => n.id == _noteId).firstOrNull;
      if (note == null) return;
      // Trashed notes are read-only; never rewrite them on the way out.
      if (note.isTrashed) return;
      _isSaving = true;
      try {
        await ref
            .read(notesProvider.notifier)
            .updateNote(
              note.copyWith(
                title: title,
                body: body,
                labelIds: _labelIds,
                isPinned: _isPinned,
                clearTitle: title == null,
                clearBody: body == null,
              ),
            );
      } finally {
        _isSaving = false;
      }
    }
  }

  void _saveAndPop() {
    _save();
    GoRouter.of(context).pop();
  }

  void _togglePin() => setState(() => _isPinned = !_isPinned);

  Future<void> _openLabelPicker() async {
    final result = await context.push<List<String>>(
      AppRoute.noteLabels.path,
      extra: List<String>.of(_labelIds),
    );
    if (result != null && mounted) {
      setState(() => _labelIds = result);
    }
  }

  void _showOptions(Note note) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        if (note.isTrashed) {
          return TrashedNoteOptionsSheet(
            onRestore: () {
              Navigator.of(sheetContext).pop();
              _restoreNote();
            },
            onDeleteForever: () {
              Navigator.of(sheetContext).pop();
              _deleteForever();
            },
          );
        }
        return NoteOptionsSheet(
          updatedAt: note.updatedAt,
          onDelete: () {
            Navigator.of(sheetContext).pop();
            _moveToTrash();
          },
        );
      },
    );
  }

  Future<void> _moveToTrash() async {
    final noteId = _noteId;
    if (noteId == null) return;
    await _runClosingAction(
      () => ref.read(notesProvider.notifier).moveToTrash(noteId),
    );
  }

  Future<void> _restoreNote() async {
    final noteId = _noteId;
    if (noteId == null) return;
    await _runClosingAction(
      () => ref.read(notesProvider.notifier).restore(noteId),
    );
  }

  Future<void> _deleteForever() async {
    final noteId = _noteId;
    if (noteId == null) return;
    final confirmed = await _confirmDeleteForever();
    if (confirmed != true || !mounted) return;
    await _runClosingAction(
      () => ref.read(notesProvider.notifier).delete(noteId),
    );
  }

  // Runs a trash action that should pop the screen on success. On failure the
  // screen stays open, re-enables saving, and surfaces a snackbar.
  Future<void> _runClosingAction(Future<void> Function() action) async {
    _isClosing = true;
    try {
      await action();
      if (mounted) {
        GoRouter.of(context).pop();
      }
    } on NoteException {
      _isClosing = false;
      _showActionError();
    }
  }

  Future<bool?> _confirmDeleteForever() {
    final l10n = context.l10n;
    return showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(l10n.deleteForeverDialogTitle),
            content: Text(l10n.deleteForeverDialogBody),
            actions: [
              AppTextButton(
                label: l10n.exitAppCancel,
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              AppTextButton(
                label: l10n.noteDeleteForever,
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
    );
  }

  void _showActionError() {
    if (!mounted) {
      return;
    }
    final l10n = context.l10n;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.noteActionError)));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _titleController.dispose();
    _bodyController.dispose();
    _bodyFocusNode.dispose();
    super.dispose();
  }

  // Tapping the empty space below the note content focuses the body field
  // with the cursor at the end, as if the field still filled the screen.
  void _focusBody() {
    _bodyFocusNode.requestFocus();
    _bodyController.selection = TextSelection.collapsed(
      offset: _bodyController.text.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final spacing = context.dimensions.spacing;
    final titleHintStyle = theme.textTheme.headlineSmall?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
    );
    final bodyHintStyle = theme.textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
    );
    final noteColor = _noteColor;
    final backgroundColor =
        noteColor != null ? Color(noteColor) : theme.scaffoldBackgroundColor;
    final allLabels = ref.watch(labelsProvider).asData?.value ?? const [];
    final noteLabels =
        allLabels.where((label) => _labelIds.contains(label.id)).toList();
    final noteId = _noteId;
    final note = noteId != null ? ref.watch(noteProvider(noteId)) : null;
    final isTrashed = note?.isTrashed ?? false;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _saveAndPop();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        bottomNavigationBar:
            note == null
                ? null
                : BottomAppBar(
                  color: backgroundColor,
                  child: Row(
                    children: [
                      AppIconButton(
                        icon: AppIconName.moreVert,
                        onPressed: () => _showOptions(note),
                      ),
                    ],
                  ),
                ),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          leading: BackButton(onPressed: _saveAndPop),
          actionsPadding: EdgeInsets.only(right: spacing.sm),
          // Trashed notes expose only the Restore / Delete-forever options
          // (in the bottom bar); every editing action is hidden. Keep new
          // actions inside this list so they stay gated behind isTrashed.
          actions:
              isTrashed
                  ? const []
                  : [
                    AppIconButton(
                      icon:
                          _isPinned
                              ? AppIconName.pushPin
                              : AppIconName.pushPinOutlined,
                      onPressed: _togglePin,
                    ),
                    Gap(spacing.sm),
                    AppIconButton(
                      icon: AppIconName.labelOutlined,
                      onPressed: _openLabelPicker,
                    ),
                  ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
          child: Opacity(
            opacity: isTrashed ? _disabledOpacity : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  readOnly: isTrashed,
                  textCapitalization: TextCapitalization.sentences,
                  style: theme.textTheme.headlineSmall,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: l10n.noteTitleHint,
                    hintStyle: titleHintStyle,
                    border: InputBorder.none,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: isTrashed ? null : _focusBody,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _bodyController,
                            focusNode: _bodyFocusNode,
                            readOnly: isTrashed,
                            textCapitalization: TextCapitalization.sentences,
                            style: theme.textTheme.bodyLarge,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: l10n.noteBodyHint,
                              hintStyle: bodyHintStyle,
                              border: InputBorder.none,
                            ),
                          ),
                          // labels flow right after the body text
                          if (noteLabels.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(
                                top: spacing.sm,
                                bottom: spacing.lg,
                              ),
                              child: Wrap(
                                spacing: spacing.sm,
                                runSpacing: spacing.xs,
                                children: [
                                  for (final label in noteLabels)
                                    LabelTag(
                                      name: label.name,
                                      onTap:
                                          isTrashed ? null : _openLabelPicker,
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
