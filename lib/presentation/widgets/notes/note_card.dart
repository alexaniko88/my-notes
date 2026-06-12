import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:my_notes/domain/models/label.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/presentation/providers/labels/labels_provider.dart';
import 'package:my_notes/presentation/widgets/labels/label_tag.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';
import 'package:my_notes/shared/extensions/date_time_extensions.dart';

class NoteCard extends ConsumerWidget {
  final Note note;
  final String searchQuery;

  const NoteCard({super.key, required this.note, this.searchQuery = ''});

  TextSpan _highlight({
    required String text,
    TextStyle? highlightStyle,
    required Color highlightColor,
  }) {
    if (searchQuery.isEmpty) {
      return TextSpan(text: text, style: highlightStyle);
    }

    final q = searchQuery.toLowerCase();
    final lower = text.toLowerCase();
    final spans = <TextSpan>[];
    var start = 0;

    while (true) {
      final index = lower.indexOf(q, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start), style: highlightStyle));
        break;
      }
      if (index > start) {
        spans.add(
          TextSpan(text: text.substring(start, index), style: highlightStyle),
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
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final dimensions = context.dimensions;
    final spacing = dimensions.spacing;
    final radius = dimensions.borderRadius;

    final allLabels = ref.watch(labelsProvider).asData?.value ?? const [];
    final noteLabels =
        allLabels.where((label) => note.labelIds.contains(label.id)).toList();

    final noteColor = note.color;
    final backgroundColor =
        noteColor != null ? Color(noteColor) : theme.cardColor;
    final title = note.title;
    final body = note.body;

    final titleStyle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.bold,
    );
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
            if (noteLabels.isNotEmpty) ...[
              Gap(spacing.sm),
              _NoteCardLabels(labels: noteLabels),
            ],
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

/// A single line of small label tags. The Stack sizes itself to one
/// invisible reference tag, and the Wrap is clipped to that height — so
/// only the tags that fit on the first line are visible, at any text scale.
class _NoteCardLabels extends StatelessWidget {
  final List<Label> labels;

  const _NoteCardLabels({required this.labels});

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          ExcludeSemantics(
            child: Opacity(
              opacity: 0,
              child: LabelTag(name: labels.first.name, small: true),
            ),
          ),
          Positioned.fill(
            child: Wrap(
              clipBehavior: Clip.hardEdge,
              spacing: spacing.xs,
              children: [
                for (final label in labels)
                  LabelTag(name: label.name, small: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
