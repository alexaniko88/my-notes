import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';
import 'package:my_notes/shared/extensions/date_time_extensions.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.searchQuery = '',
  });

  final Note note;
  final String searchQuery;

  TextSpan _highlight({
    required String text,
    TextStyle? highlightStyle,
    required Color highlightColor,
  }) {
    if (searchQuery.isEmpty) {
      return TextSpan(
        text: text,
        style: highlightStyle,
      );
    }

    final q = searchQuery.toLowerCase();
    final lower = text.toLowerCase();
    final spans = <TextSpan>[];
    var start = 0;

    while (true) {
      final index = lower.indexOf(q, start);
      if (index == -1) {
        spans.add(
          TextSpan(
            text: text.substring(start),
            style: highlightStyle,
          ),
        );
        break;
      }
      if (index > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, index),
            style: highlightStyle,
          ),
        );
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + q.length),
          style: highlightStyle?.copyWith(
            backgroundColor: highlightColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
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
    final backgroundColor = noteColor != null ? Color(noteColor) : theme.cardColor;
    final title = note.title;
    final body = note.body;

    final titleStyle = theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold);
    final bodyStyle = theme.textTheme.bodyMedium;
    final highlightColor = context.colors.searchHighlight;
    final lastUpdatedTheme = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
      fontStyle: FontStyle.italic,
    );

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
              Text.rich(
                _highlight(
                  text: title,
                  highlightStyle: titleStyle,
                  highlightColor: highlightColor,
                ),
              ),
              if (body != null) Gap(spacing.sm),
            ],
            if (body != null)
              Text.rich(
                _highlight(
                  text: body,
                  highlightStyle: bodyStyle,
                  highlightColor: highlightColor,
                ),
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
              ),
            Gap(spacing.sm),
            Text(
              l10n.noteLastUpdated(note.updatedAt.toNoteLabel(l10n)),
              style: lastUpdatedTheme,
            ),
          ],
        ),
      ),
    );
  }

}
