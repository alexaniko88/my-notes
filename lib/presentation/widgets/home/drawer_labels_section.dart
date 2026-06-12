import 'package:flutter/material.dart';
import 'package:my_notes/domain/models/label.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/presentation/widgets/common/app_text_button.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class DrawerLabelsSection extends StatelessWidget {
  static const _selectedTileShape = StadiumBorder();

  // standard one-line ListTile height; itemExtent must match it so the
  // maxVisibleLabels cap is exact
  final _labelTileHeight = 56.0;

  final List<Label> labels;
  final String? selectedLabelId;
  final int maxVisibleLabels;
  final VoidCallback? onEdit;
  final VoidCallback? onCreateLabel;
  final ValueChanged<Label>? onLabelTap;

  const DrawerLabelsSection({
    super.key,
    required this.labels,
    this.selectedLabelId,
    this.maxVisibleLabels = 5,
    this.onEdit,
    this.onCreateLabel,
    this.onLabelTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final dimensions = context.dimensions;

    final headerStyle = theme.textTheme.titleSmall;
    final selectedTileColor = theme.colorScheme.secondaryContainer;
    final labelTapCallback = onLabelTap;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (labels.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dimensions.spacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.labelsSectionTitle, style: headerStyle),
                AppTextButton(label: l10n.labelsEdit, onPressed: onEdit),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: _labelTileHeight * maxVisibleLabels,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemExtent: _labelTileHeight,
              itemCount: labels.length,
              itemBuilder: (context, index) {
                final label = labels[index];
                return ListTile(
                  selected: label.id == selectedLabelId,
                  selectedTileColor: selectedTileColor,
                  shape: _selectedTileShape,
                  leading: const AppIcon(name: AppIconName.labelOutlined),
                  title: Text(label.name),
                  onTap:
                      labelTapCallback == null
                          ? null
                          : () => labelTapCallback(label),
                );
              },
            ),
          ),
        ],
        ListTile(
          leading: const AppIcon(name: AppIconName.add),
          title: Text(l10n.createNewLabel),
          onTap: onCreateLabel,
        ),
        if (labels.isNotEmpty) const Divider(),
      ],
    );
  }
}
