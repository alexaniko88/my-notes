import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class NoteScreen extends StatefulWidget {
  final String noteId;

  const NoteScreen({super.key, required this.noteId});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
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

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
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
    );
  }
}
