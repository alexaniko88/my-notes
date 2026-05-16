import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/gen/app_localizations.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.searchQuery = '',
  });

  final Note note;
  final String searchQuery;

  TextSpan _highlight(String text, TextStyle base) {
    if (searchQuery.isEmpty) return TextSpan(text: text, style: base);

    final q = searchQuery.toLowerCase();
    final lower = text.toLowerCase();
    final spans = <TextSpan>[];
    var start = 0;

    while (true) {
      final index = lower.indexOf(q, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start), style: base));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: base));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + q.length),
        style: base.copyWith(
          backgroundColor: Colors.yellow,
          fontWeight: FontWeight.bold,
        ),
      ));
      start = index + q.length;
    }

    return TextSpan(children: spans);
  }

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

    final titleStyle = theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold) ?? const TextStyle();
    final bodyStyle = theme.textTheme.bodyMedium ?? const TextStyle();

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
              Text.rich(_highlight(title, titleStyle)),
              if (body != null) Gap(spacing.sm),
            ],
            if (body != null)
              Text.rich(
                _highlight(body, bodyStyle),
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
