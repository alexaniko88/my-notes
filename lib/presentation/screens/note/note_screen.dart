import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/domain/models/note_type.dart';
import 'package:my_notes/presentation/providers/notes/notes_provider.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
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
                child: TextField(
                  controller: _bodyController,
                  style: theme.textTheme.bodyLarge,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: l10n.noteBodyHint,
                    hintStyle: bodyHintStyle,
                    border: InputBorder.none,
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
