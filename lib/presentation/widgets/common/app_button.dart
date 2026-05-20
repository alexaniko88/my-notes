import 'package:flutter/material.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

enum _AppButtonType { primary, secondary }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final _AppButtonType _type;

  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
  }) : _type = _AppButtonType.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
  }) : _type = _AppButtonType.secondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = context.dimensions;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(dimensions.borderRadius.md),
    );

    return switch (_type) {
      _AppButtonType.primary => FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: dimensions.spacing.md),
            shape: shape,
          ),
          child: Text(label),
        ),
      _AppButtonType.secondary => OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.spacing.lg,
              vertical: dimensions.spacing.md,
            ),
            shape: shape,
            side: BorderSide(color: theme.colorScheme.outline),
          ),
          child: Text(label),
        ),
    };
  }
}
