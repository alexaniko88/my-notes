import 'package:flutter/material.dart';
import 'package:my_notes/domain/models/label.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class LabelEditTile extends StatelessWidget {
  final String label;
  final bool isEditing;
  final TextEditingController? controller;
  final VoidCallback onStartEdit;
  final VoidCallback onDelete;
  final ValueChanged<String> onConfirm;

  const LabelEditTile({
    super.key,
    required this.label,
    required this.isEditing,
    required this.onStartEdit,
    required this.onDelete,
    required this.onConfirm,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = context.dimensions;

    final fieldStyle = theme.textTheme.bodyLarge;
    final borderColor = theme.colorScheme.outline;
    final borderRadius = BorderRadius.circular(dimensions.borderRadius.md);

    final editController = controller;
    if (!isEditing || editController == null) {
      return ListTile(
        leading: const AppIcon(name: AppIconName.labelOutlined),
        title: Text(label),
        trailing: IconButton(
          onPressed: onStartEdit,
          icon: const AppIcon(name: AppIconName.editOutlined),
        ),
        onTap: onStartEdit,
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: dimensions.spacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: borderRadius,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onDelete,
            icon: const AppIcon(name: AppIconName.deleteOutlined),
          ),
          Expanded(
            child: TextField(
              controller: editController,
              autofocus: true,
              style: fieldStyle,
              maxLength: Label.maxNameLength,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: editController,
            builder: (context, value, _) {
              final text = value.text.trim();
              return IconButton(
                onPressed: text.isEmpty ? null : () => onConfirm(text),
                icon: const AppIcon(name: AppIconName.check),
              );
            },
          ),
        ],
      ),
    );
  }
}
