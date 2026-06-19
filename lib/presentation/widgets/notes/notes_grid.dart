import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/domain/models/note_exception.dart';
import 'package:my_notes/presentation/providers/labels/selected_label_provider.dart';
import 'package:my_notes/presentation/providers/notes/notes_provider.dart';
import 'package:my_notes/presentation/providers/trash/selected_trash_provider.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/presentation/widgets/notes/notes_grid_column.dart';
import 'package:my_notes/presentation/widgets/notes/notes_empty_state.dart';
import 'package:my_notes/presentation/widgets/notes/notes_section_header.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

/// A displayed group of note cards: an optional header plus the notes to show,
/// tied back to the [source] list they are reordered within.
typedef _Section =
    ({
      String? header,
      List<Note> notes,
      NoteSection section,
      List<Note> source,
    });

/// The scrolling body of the home screen: pinned/others sections (or the trash
/// list), with independent drag-reorder per section.
class NotesGrid extends ConsumerStatefulWidget {
  final String searchQuery;

  const NotesGrid({super.key, required this.searchQuery});

  @override
  ConsumerState<NotesGrid> createState() => _NotesGridState();
}

class _NotesGridState extends ConsumerState<NotesGrid> {
  // Pinned and unpinned notes are tracked separately so each section can be
  // reordered independently; both are re-synced whenever the source changes.
  late List<Note> _pinned;
  late List<Note> _others;

  @override
  void initState() {
    super.initState();
    _syncFrom(ref.read(activeNotesProvider));
  }

  void _syncFrom(List<Note> notes) {
    _pinned = notes.where((n) => n.isPinned).toList();
    _others = notes.where((n) => !n.isPinned).toList();
  }

  // Reorders within a single section. [from]/[to] index into the displayed
  // (filtered) list, so they are mapped back to the underlying [source] list
  // by note identity to stay correct under an active label/search filter.
  void _reorderWithin(
    List<Note> source,
    List<Note> displayed,
    int from,
    int to,
  ) {
    if (from == to) return;
    final movedNote = displayed[from];
    final targetNote = displayed[to];
    final sourceFrom = source.indexOf(movedNote);
    final sourceTo = source.indexOf(targetNote);
    if (sourceFrom == -1 || sourceTo == -1) return;
    setState(() {
      final note = source.removeAt(sourceFrom);
      source.insert(sourceTo, note);
    });
    unawaited(_persistReorder());
  }

  // Persists the new ordering of both sections. Best-effort: a failed write
  // leaves the stored order intact, which the next stream emission restores.
  Future<void> _persistReorder() async {
    try {
      await ref.read(notesProvider.notifier).persistOrder([
        ..._pinned,
        ..._others,
      ]);
    } on NoteException {
      // Ignored — reordering is non-critical and self-heals on the next sync.
    }
  }

  List<Note> _applyLabelFilter(List<Note> notes, String? labelId) {
    if (labelId == null) return notes;
    return notes.where((n) => n.labelIds.contains(labelId)).toList();
  }

  List<Note> _applyQuery(List<Note> notes, String query) {
    if (query.isEmpty) return notes;
    final q = query.toLowerCase();
    return notes
        .where(
          (n) =>
              (n.title?.toLowerCase().contains(q) ?? false) ||
              (n.body?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(activeNotesProvider, (List<Note>? _, List<Note> next) {
      setState(() => _syncFrom(next));
    });

    final l10n = context.l10n;
    final query = widget.searchQuery;
    final isTrashSelected = ref.watch(selectedTrashProvider);

    if (isTrashSelected) {
      final trashedNotes = ref.watch(trashedNotesProvider);
      if (trashedNotes.isEmpty) {
        return NotesEmptyState(
          icon: AppIconName.deleteOutlined,
          title: l10n.trashEmptyState,
          subtitle: l10n.trashRetentionNotice,
        );
      }
      return _scrollContainer([
        NotesGridColumn(
          notes: trashedNotes,
          searchQuery: query,
          section: null,
          onReorder: null,
        ),
      ]);
    }

    final selectedLabelId = ref.watch(selectedLabelProvider);
    final pinnedFiltered = _applyLabelFilter(_pinned, selectedLabelId);
    final othersFiltered = _applyLabelFilter(_others, selectedLabelId);
    final pinnedDisplayed = _applyQuery(pinnedFiltered, query);
    final othersDisplayed = _applyQuery(othersFiltered, query);

    if (_pinned.isEmpty && _others.isEmpty) {
      return _centeredMessage(l10n.notesEmptyState);
    }
    if (pinnedFiltered.isEmpty && othersFiltered.isEmpty) {
      return NotesEmptyState(
        icon: AppIconName.labelOutlined,
        title: l10n.labelNoNotes,
      );
    }
    if (pinnedDisplayed.isEmpty && othersDisplayed.isEmpty) {
      return _centeredMessage(l10n.searchNoResults);
    }

    // Section headers only appear once something is pinned; with no pinned
    // notes the grid stays a single headerless list, as before.
    final sections = <_Section>[
      if (pinnedDisplayed.isNotEmpty)
        (
          header: l10n.sectionPinned,
          notes: pinnedDisplayed,
          section: NoteSection.pinned,
          source: _pinned,
        ),
      if (othersDisplayed.isNotEmpty)
        (
          header: pinnedDisplayed.isNotEmpty ? l10n.sectionOthers : null,
          notes: othersDisplayed,
          section: NoteSection.others,
          source: _others,
        ),
    ];

    final spacing = context.dimensions.spacing;
    final children = <Widget>[];
    for (final section in sections) {
      if (children.isNotEmpty) children.add(Gap(spacing.lg));
      final header = section.header;
      if (header != null) children.add(NotesSectionHeader(title: header));
      children.add(
        NotesGridColumn(
          notes: section.notes,
          searchQuery: query,
          section: section.section,
          onReorder:
              (from, to) =>
                  _reorderWithin(section.source, section.notes, from, to),
        ),
      );
    }

    return _scrollContainer(children);
  }

  Widget _centeredMessage(String text) {
    final theme = Theme.of(context);
    return Center(child: Text(text, style: theme.textTheme.bodyLarge));
  }

  Widget _scrollContainer(List<Widget> children) {
    final spacing = context.dimensions.spacing;
    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
