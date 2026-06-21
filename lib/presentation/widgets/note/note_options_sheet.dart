import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';
import 'package:my_notes/shared/extensions/date_time_extensions.dart';

class NoteOptionsSheet extends StatelessWidget {
  final DateTime updatedAt;
  final VoidCallback onDelete;
  final VoidCallback? onAddVoiceNote;

  const NoteOptionsSheet({
    super.key,
    required this.updatedAt,
    required this.onDelete,
    this.onAddVoiceNote,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final dimensions = context.dimensions;

    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final onAddVoiceNote = this.onAddVoiceNote;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              dimensions.spacing.lg,
              dimensions.spacing.lg,
              dimensions.spacing.lg,
              dimensions.spacing.sm,
            ),
            child: Text(
              l10n.noteLastUpdated(updatedAt.toNoteLabel(l10n)),
              style: titleStyle,
            ),
          ),
          if (onAddVoiceNote != null)
            ListTile(
              leading: const AppIcon(name: AppIconName.micOutlined),
              title: Text(l10n.voiceNoteLabel),
              onTap: onAddVoiceNote,
            ),
          ListTile(
            leading: const AppIcon(name: AppIconName.deleteOutlined),
            title: Text(l10n.noteDelete),
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

class TrashedNoteOptionsSheet extends StatelessWidget {
  final VoidCallback onRestore;
  final VoidCallback onDeleteForever;

  const TrashedNoteOptionsSheet({
    super.key,
    required this.onRestore,
    required this.onDeleteForever,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const AppIcon(name: AppIconName.restore),
            title: Text(l10n.noteRestore),
            onTap: onRestore,
          ),
          ListTile(
            leading: const AppIcon(name: AppIconName.deleteForever),
            title: Text(l10n.noteDeleteForever),
            onTap: onDeleteForever,
          ),
        ],
      ),
    );
  }
}
