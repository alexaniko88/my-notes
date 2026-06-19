import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/presentation/providers/labels/labels_provider.dart';
import 'package:my_notes/presentation/providers/labels/selected_label_provider.dart';
import 'package:my_notes/presentation/providers/notes/notes_provider.dart';
import 'package:my_notes/presentation/providers/trash/selected_trash_provider.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/presentation/widgets/home/app_drawer.dart';
import 'package:my_notes/presentation/widgets/home/fab_notes.dart';
import 'package:my_notes/presentation/widgets/home/home_app_bar.dart';
import 'package:my_notes/presentation/widgets/home/playground_title.dart';
import 'package:my_notes/presentation/widgets/notes/notes_grid.dart';
import 'package:my_notes/domain/models/note_type.dart';
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

    final isTrashSelected = ref.watch(selectedTrashProvider);
    final selectedLabelId = ref.watch(selectedLabelProvider);
    final labels = ref.watch(labelsProvider).asData?.value ?? const [];
    final selectedLabelName =
        labels.where((label) => label.id == selectedLabelId).firstOrNull?.name;

    final activeNotes = ref.watch(activeNotesProvider);
    final bool hasNotes;
    if (isTrashSelected) {
      hasNotes = ref.watch(trashedNotesProvider).isNotEmpty;
    } else if (selectedLabelId != null) {
      hasNotes = activeNotes.any((n) => n.labelIds.contains(selectedLabelId));
    } else {
      hasNotes = activeNotes.isNotEmpty;
    }

    final Widget titleWidget;
    if (isTrashSelected) {
      titleWidget = Text(
        l10n.trash,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else if (selectedLabelName != null) {
      titleWidget = Text(
        selectedLabelName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      titleWidget = PlaygroundTitle(label: l10n.appTitle);
    }

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
        appBar: HomeAppBar(
          isSearching: _isSearching,
          searchController: _searchController,
          title: titleWidget,
          showSearchAction: hasNotes,
          onStartSearch: _startSearch,
          onStopSearch: _stopSearch,
          onSearchChanged: () => setState(() {}),
        ),
        body: Stack(
          children: [
            NotesGrid(searchQuery: _searchController.text),
            if (!isTrashSelected) FabNotes(options: options),
          ],
        ),
      ),
    );
  }
}
