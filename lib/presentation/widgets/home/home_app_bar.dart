import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

/// Home-screen app bar with two modes: the default bar (menu + title + search
/// action) and the search bar (back + query field + clear). The parent owns the
/// search state and is notified via the callbacks.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final Widget title;
  final bool showSearchAction;
  final VoidCallback onStartSearch;
  final VoidCallback onStopSearch;
  final VoidCallback onSearchChanged;

  const HomeAppBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.title,
    required this.showSearchAction,
    required this.onStartSearch,
    required this.onStopSearch,
    required this.onSearchChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (isSearching) {
      return AppBar(
        leading: BackButton(onPressed: onStopSearch),
        title: TextField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            border: InputBorder.none,
          ),
          onChanged: (_) => onSearchChanged(),
        ),
        actions: [
          if (searchController.text.isNotEmpty)
            IconButton(
              icon: const AppIcon(name: AppIconName.close),
              onPressed: () {
                searchController.clear();
                onSearchChanged();
              },
            ),
        ],
      );
    }

    return AppBar(
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: const AppIcon(name: AppIconName.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      ),
      title: title,
      actions: [
        if (showSearchAction)
          IconButton(
            icon: const AppIcon(name: AppIconName.search),
            onPressed: onStartSearch,
          ),
      ],
    );
  }
}
