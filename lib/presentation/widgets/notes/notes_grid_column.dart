import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/presentation/widgets/note/note_card.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';
import 'package:my_notes/shared/navigation/app_route.dart';

/// Which home-screen section a note card belongs to. Drag-and-drop reordering
/// is confined to a single section.
enum NoteSection { pinned, others }

/// Payload carried by a dragged note card: its index within the section's
/// displayed list plus the section it came from.
typedef _DragData = ({int index, NoteSection section});

/// Arranges note cards into two balanced columns (even indices on the left,
/// odd on the right) so cards of differing heights pack tightly. When
/// [section]/[onReorder] are provided the cards become drag-reorderable within
/// that section; otherwise they are plain tappable cards (e.g. the trash list).
class NotesGridColumn extends StatelessWidget {
  final List<Note> notes;
  final String searchQuery;
  final NoteSection? section;
  final void Function(int from, int to)? onReorder;

  const NotesGridColumn({
    super.key,
    required this.notes,
    required this.searchQuery,
    required this.section,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final cardWidth =
        (MediaQuery.sizeOf(context).width - spacing.md * 2 - spacing.sm) / 2;

    final leftItems = [for (var i = 0; i < notes.length; i += 2) (i, notes[i])];
    final rightItems = [
      for (var i = 1; i < notes.length; i += 2) (i, notes[i]),
    ];

    Widget column(List<(int, Note)> items) => Expanded(
      child: _NoteCardColumn(
        items: items,
        cardWidth: cardWidth,
        searchQuery: searchQuery,
        section: section,
        onReorder: onReorder,
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [column(leftItems), Gap(spacing.sm), column(rightItems)],
    );
  }
}

class _NoteCardColumn extends StatelessWidget {
  final List<(int, Note)> items;
  final double cardWidth;
  final String searchQuery;
  final NoteSection? section;
  final void Function(int from, int to)? onReorder;

  const _NoteCardColumn({
    required this.items,
    required this.cardWidth,
    required this.searchQuery,
    required this.section,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) Gap(spacing.sm),
          _DraggableNoteItem(
            key: ValueKey(items[i].$2.id),
            note: items[i].$2,
            index: items[i].$1,
            cardWidth: cardWidth,
            searchQuery: searchQuery,
            section: section,
            onReorder: onReorder,
          ),
        ],
      ],
    );
  }
}

class _DraggableNoteItem extends StatelessWidget {
  static const _highlightDuration = Duration(milliseconds: 150);

  final Note note;
  final int index;
  final double cardWidth;
  final String searchQuery;
  final NoteSection? section;
  final void Function(int from, int to)? onReorder;

  const _DraggableNoteItem({
    super.key,
    required this.note,
    required this.index,
    required this.cardWidth,
    required this.searchQuery,
    required this.section,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final tappableCard = GestureDetector(
      onTap:
          () => context.pushNamed(
            AppRoute.note.name,
            queryParameters: {'id': note.id},
          ),
      child: NoteCard(note: note, searchQuery: searchQuery),
    );

    final reorder = onReorder;
    final section = this.section;
    if (reorder == null || section == null) {
      return tappableCard;
    }

    return DragTarget<_DragData>(
      // Only accept drops from the same section so the Pinned and Others
      // lists reorder independently of one another.
      onWillAcceptWithDetails: (details) => details.data.section == section,
      onAcceptWithDetails: (details) => reorder(details.data.index, index),
      builder: (context, candidateData, _) {
        return AnimatedOpacity(
          duration: _highlightDuration,
          opacity: candidateData.isNotEmpty ? 0.6 : 1.0,
          child: LongPressDraggable<_DragData>(
            data: (index: index, section: section),
            feedback: SizedBox(
              width: cardWidth,
              child: Material(
                color: Colors.transparent,
                child: NoteCard(
                  note: note,
                  searchQuery: searchQuery,
                  isSelected: true,
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: NoteCard(note: note, searchQuery: searchQuery),
            ),
            child: tappableCard,
          ),
        );
      },
    );
  }
}
