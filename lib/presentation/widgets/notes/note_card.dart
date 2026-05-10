import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/gen/app_localizations.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final dimensions = context.dimensions;
    final spacing = dimensions.spacing;
    final radius = dimensions.borderRadius;

    final noteColor = note.color;
    final backgroundColor = noteColor != null
        ? Color(noteColor)
        : theme.cardTheme.color ?? theme.colorScheme.surfaceContainerHighest;
    final title = note.title;
    final body = note.body;

    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.md),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (body != null) Gap(spacing.sm),
            ],
            if (body != null)
              Text(
                body,
                style: theme.textTheme.bodyMedium,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
              ),
            Gap(spacing.sm),
            Text(
              l10n.noteLastUpdated(_formatUpdatedAt(note.updatedAt, l10n)),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatUpdatedAt(DateTime dt, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = const Duration(days: 1);
    final yesterday = today.subtract(day);
    final updated = DateTime(dt.year, dt.month, dt.day);

    final time = DateFormat('h:mm a').format(dt);

    if (updated == today) {
      return l10n.noteUpdatedTodayAt(time);
    } else if (updated == yesterday) {
      return l10n.noteUpdatedYesterdayAt(time);
    } else {
      return l10n.noteUpdatedDateAt(DateFormat('MMM d').format(dt), time);
    }
  }
}
