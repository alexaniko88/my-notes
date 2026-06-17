import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class DrawerAllNotesSection extends StatelessWidget {
  static const _selectedTileShape = StadiumBorder();

  final bool isSelected;
  final VoidCallback? onTap;

  const DrawerAllNotesSection({super.key, this.isSelected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final selectedTileColor = theme.colorScheme.secondaryContainer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          selected: isSelected,
          selectedTileColor: selectedTileColor,
          shape: _selectedTileShape,
          leading: const AppIcon(name: AppIconName.stickyNote2Outlined),
          title: Text(l10n.allNotes),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }
}
