import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/domain/models/note_type.dart';
import 'package:my_notes/presentation/providers/labels/selected_label_provider.dart';
import 'package:my_notes/presentation/providers/notes/notes_provider.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/presentation/widgets/home/app_drawer.dart';
import 'package:my_notes/presentation/widgets/home/fab_notes.dart';
import 'package:my_notes/presentation/widgets/notes/note_card.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';
import 'package:my_notes/shared/navigation/app_route.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  void _createTextNote() {
    context.pushNamed(AppRoute.note.name, extra: NoteType.text);
  }

  void _startSearch() => setState(() => _isSearching = true);

  void _stopSearch() {
    _searchController.clear();
    setState(() => _isSearching = false);
  }

  Future<void> _confirmExit(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(l10n.exitAppTitle),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(l10n.exitAppCancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(l10n.exitAppConfirm),
              ),
            ],
          ),
    );
    if (confirmed ?? false) SystemNavigator.pop();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = [
      (AppIconName.textFields, l10n.fabOptionText, _createTextNote),
      (AppIconName.imageOutlined, l10n.fabOptionImage, null),
      (AppIconName.micOutlined, l10n.fabOptionAudio, null),
      (AppIconName.pictureAsPdfOutlined, l10n.fabOptionPdf, null),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (_isSearching) {
          _stopSearch();
        } else {
          _confirmExit(context);
        }
      },
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar:
            _isSearching
                ? AppBar(
                  leading: BackButton(onPressed: _stopSearch),
                  title: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: l10n.searchHint,
                      border: InputBorder.none,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  actions: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const AppIcon(name: AppIconName.close),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      ),
                  ],
                )
                : AppBar(
                  leading: Builder(
                    builder:
                        (context) => IconButton(
                          icon: const AppIcon(name: AppIconName.menu),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                  ),
                  title: _PlaygroundTitle(label: l10n.appTitle),
                  actions: [
                    IconButton(
                      icon: const AppIcon(name: AppIconName.search),
                      onPressed: _startSearch,
                    ),
                  ],
                ),
        body: Stack(
          children: [
            _NotesGrid(
              emptyLabel: l10n.notesEmptyState,
              noResultsLabel: l10n.searchNoResults,
              labelNoNotesLabel: l10n.labelNoNotes,
              searchQuery: _searchController.text,
            ),
            FabNotes(options: options),
          ],
        ),
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
  final String noResultsLabel;
  final String labelNoNotesLabel;
  final String searchQuery;

  const _NotesGrid({
    required this.emptyLabel,
    required this.noResultsLabel,
    required this.labelNoNotesLabel,
    required this.searchQuery,
  });

  @override
  ConsumerState<_NotesGrid> createState() => _NotesGridState();
}

class _NotesGridState extends ConsumerState<_NotesGrid> {
  late List<Note> _notes;

  @override
  void initState() {
    super.initState();
    _notes = List.of(ref.read(notesProvider).asData?.value ?? []);
  }

  void _onReorder(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) return;
    setState(() {
      final note = _notes.removeAt(fromIndex);
      _notes.insert(toIndex, note);
    });
  }

  List<Note> _applyLabelFilter(String? labelId) {
    if (labelId == null) return _notes;
    return _notes.where((n) => n.labelIds.contains(labelId)).toList();
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
    ref.listen(notesProvider, (
      AsyncValue<List<Note>>? _,
      AsyncValue<List<Note>> next,
    ) {
      final notes = next.asData?.value;
      if (notes != null) {
        setState(() => _notes = List.of(notes));
      }
    });

    final theme = Theme.of(context);
    final query = widget.searchQuery;
    final selectedLabelId = ref.watch(selectedLabelProvider);
    final labelFilteredNotes = _applyLabelFilter(selectedLabelId);
    final displayedNotes = _applyQuery(labelFilteredNotes, query);

    if (_notes.isEmpty) {
      return Center(
        child: Text(widget.emptyLabel, style: theme.textTheme.bodyLarge),
      );
    }

    if (labelFilteredNotes.isEmpty) {
      return Center(
        child: Text(widget.labelNoNotesLabel, style: theme.textTheme.bodyLarge),
      );
    }

    if (displayedNotes.isEmpty) {
      return Center(
        child: Text(widget.noResultsLabel, style: theme.textTheme.bodyLarge),
      );
    }

    final spacing = context.dimensions.spacing;
    final cardWidth =
        (MediaQuery.sizeOf(context).width - spacing.md * 2 - spacing.sm) / 2;

    final leftItems = [
      for (var i = 0; i < displayedNotes.length; i += 2) (i, displayedNotes[i]),
    ];
    final rightItems = [
      for (var i = 1; i < displayedNotes.length; i += 2) (i, displayedNotes[i]),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _MasonryColumn(
              items: leftItems,
              cardWidth: cardWidth,
              searchQuery: query,
              onReorder: _onReorder,
            ),
          ),
          Gap(spacing.sm),
          Expanded(
            child: _MasonryColumn(
              items: rightItems,
              cardWidth: cardWidth,
              searchQuery: query,
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
  final String searchQuery;
  final void Function(int from, int to) onReorder;

  const _MasonryColumn({
    required this.items,
    required this.cardWidth,
    required this.searchQuery,
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
  final void Function(int from, int to) onReorder;

  const _DraggableNoteItem({
    super.key,
    required this.note,
    required this.index,
    required this.cardWidth,
    required this.searchQuery,
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
                child: NoteCard(note: note, searchQuery: searchQuery),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: NoteCard(note: note, searchQuery: searchQuery),
            ),
            child: GestureDetector(
              onTap:
                  () => context.pushNamed(
                    AppRoute.note.name,
                    queryParameters: {'id': note.id},
                  ),
              child: NoteCard(note: note, searchQuery: searchQuery),
            ),
          ),
        );
      },
    );
  }
}
