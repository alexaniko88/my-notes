import 'package:flutter/material.dart';
import 'package:my_notes/domain/models/label.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class LabelCreateField extends StatelessWidget {
  final bool isActive;
  final TextEditingController controller;
  final VoidCallback onActivate;
  final VoidCallback onCancel;
  final ValueChanged<String> onConfirm;

  const LabelCreateField({
    super.key,
    required this.isActive,
    required this.controller,
    required this.onActivate,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final dimensions = context.dimensions;

    final hintStyle = theme.textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
    );
    final fieldStyle = theme.textTheme.bodyLarge;
    final borderColor = theme.colorScheme.outline;
    final borderRadius = BorderRadius.circular(dimensions.borderRadius.md);

    if (!isActive) {
      return ListTile(
        leading: const AppIcon(name: AppIconName.add),
        title: Text(l10n.createNewLabel, style: hintStyle),
        onTap: onActivate,
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
            onPressed: onCancel,
            icon: const AppIcon(name: AppIconName.close),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              style: fieldStyle,
              maxLength: Label.maxNameLength,
              decoration: InputDecoration(
                hintText: l10n.createNewLabel,
                hintStyle: hintStyle,
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
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
