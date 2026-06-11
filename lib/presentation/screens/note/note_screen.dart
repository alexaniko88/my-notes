import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/domain/models/note_type.dart';
import 'package:my_notes/presentation/providers/labels/labels_provider.dart';
import 'package:my_notes/presentation/providers/notes/notes_provider.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/presentation/widgets/common/app_icon_button.dart';
import 'package:my_notes/presentation/widgets/labels/label_tag.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';
import 'package:my_notes/shared/navigation/app_route.dart';

class NoteScreen extends ConsumerStatefulWidget {
  final String? noteId;
  final NoteType? noteType;

  const NoteScreen({
    super.key,
    this.noteId,
    this.noteType,
  });

  @override
  ConsumerState<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends ConsumerState<NoteScreen>
    with WidgetsBindingObserver {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  final FocusNode _bodyFocusNode = FocusNode();
  List<String> _labelIds = [];
  int? _noteColor;
  String? _noteId;
  bool _isSaving = false;

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
    if (_isSaving) return;
    final title = _titleController.text.isEmpty ? null : _titleController.text;
    final body = _bodyController.text.isEmpty ? null : _bodyController.text;

    if (_noteId == null) {
      if (title == null && body == null) return;
      _isSaving = true;
      try {
        _noteId = await ref.read(notesProvider.notifier).add(
              title: title,
              body: body,
              labelIds: _labelIds,
            );
      } finally {
        _isSaving = false;
      }
    } else {
      final notes = ref.read(notesProvider).asData?.value ?? [];
      final note = notes.where((n) => n.id == _noteId).firstOrNull;
      if (note == null) return;
      _isSaving = true;
      try {
        await ref.read(notesProvider.notifier).updateNote(
              note.copyWith(
                title: title,
                body: body,
                labelIds: _labelIds,
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

  Future<void> _openLabelPicker() async {
    final result = await context.push<List<String>>(
      AppRoute.noteLabels.path,
      extra: List<String>.of(_labelIds),
    );
    if (result != null && mounted) {
      setState(() => _labelIds = result);
    }
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
    _bodyController.selection =
        TextSelection.collapsed(offset: _bodyController.text.length);
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _saveAndPop();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          leading: BackButton(onPressed: _saveAndPop),
          actionsPadding: EdgeInsets.only(right: spacing.sm),
          actions: [
            AppIconButton(
              icon: AppIconName.labelOutlined,
              onPressed: _openLabelPicker,
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
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
                  onTap: _focusBody,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _bodyController,
                          focusNode: _bodyFocusNode,
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
                                    onTap: _openLabelPicker,
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
    );
  }
}
