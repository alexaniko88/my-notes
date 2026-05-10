import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/presentation/providers/notes/notes_provider.dart';
import 'package:my_notes/presentation/widgets/home/fab_notes.dart';
import 'package:my_notes/presentation/widgets/notes/note_card.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';
import 'package:my_notes/shared/navigation/app_route.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = [
      (Icons.text_fields, l10n.fabOptionText),
      (Icons.image_outlined, l10n.fabOptionImage),
      (Icons.mic_outlined, l10n.fabOptionAudio),
      (Icons.picture_as_pdf_outlined, l10n.fabOptionPdf),
    ];

    return Scaffold(
      appBar: AppBar(title: _PlaygroundTitle(label: l10n.appTitle)),
      body: Stack(
        children: [
          _NotesGrid(emptyLabel: l10n.notesEmptyState),
          FabNotes(options: options),
        ],
      ),
    );
  }
}

class _PlaygroundTitle extends StatefulWidget {
  const _PlaygroundTitle({required this.label});

  final String label;

  @override
  State<_PlaygroundTitle> createState() => _PlaygroundTitleState();
}

class _PlaygroundTitleState extends State<_PlaygroundTitle> {
  static const _pressDuration = Duration(seconds: 3);

  Timer? _timer;

  void _onTapDown(TapDownDetails _) {
    _timer = Timer(_pressDuration, () {
      if (mounted) context.push(AppRoute.playground.path);
    });
  }

  void _onTapUp(TapUpDetails _) => _cancelTimer();

  void _onTapCancel() => _cancelTimer();

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Text(widget.label),
    );
  }
}

class _NotesGrid extends ConsumerStatefulWidget {
  final String emptyLabel;

  const _NotesGrid({required this.emptyLabel});

  @override
  ConsumerState<_NotesGrid> createState() => _NotesGridState();
}

class _NotesGridState extends ConsumerState<_NotesGrid> {
  late List<Note> _notes;

  @override
  void initState() {
    super.initState();
    _notes = List.of(ref.read(notesProvider));
  }

  void _onReorder(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) return;
    setState(() {
      final note = _notes.removeAt(fromIndex);
      _notes.insert(toIndex, note);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(notesProvider, (List<Note>? _, List<Note> next) {
      setState(() => _notes = List.of(next));
    });

    if (_notes.isEmpty) {
      final theme = Theme.of(context);
      return Center(child: Text(widget.emptyLabel, style: theme.textTheme.bodyLarge));
    }

    final spacing = context.dimensions.spacing;
    final cardWidth = (MediaQuery.sizeOf(context).width - spacing.md * 2 - spacing.sm) / 2;

    final leftItems = [for (var i = 0; i < _notes.length; i += 2) (i, _notes[i])];
    final rightItems = [for (var i = 1; i < _notes.length; i += 2) (i, _notes[i])];

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _MasonryColumn(
              items: leftItems,
              cardWidth: cardWidth,
              onReorder: _onReorder,
            ),
          ),
          Gap(spacing.sm),
          Expanded(
            child: _MasonryColumn(
              items: rightItems,
              cardWidth: cardWidth,
              onReorder: _onReorder,
            ),
          ),
        ],
      ),
    );
  }
}

class _MasonryColumn extends StatelessWidget {
  final List<(int, Note)> items;
  final double cardWidth;
  final void Function(int from, int to) onReorder;

  const _MasonryColumn({
    required this.items,
    required this.cardWidth,
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
  final void Function(int from, int to) onReorder;

  const _DraggableNoteItem({
    super.key,
    required this.note,
    required this.index,
    required this.cardWidth,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onAcceptWithDetails: (details) => onReorder(details.data, index),
      builder: (context, candidateData, _) {
        return AnimatedOpacity(
          duration: _highlightDuration,
          opacity: candidateData.isNotEmpty ? 0.6 : 1.0,
          child: LongPressDraggable<int>(
            data: index,
            feedback: SizedBox(
              width: cardWidth,
              child: Material(
                color: Colors.transparent,
                child: NoteCard(note: note),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: NoteCard(note: note),
            ),
            child: NoteCard(note: note),
          ),
        );
      },
    );
  }
}
