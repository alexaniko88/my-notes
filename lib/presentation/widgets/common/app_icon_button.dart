import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

/// Icon button on a subtle rounded-square background, used for
/// app bar actions.
class AppIconButton extends StatelessWidget {
  final AppIconName icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = context.dimensions;

    final backgroundColor = theme.colorScheme.surfaceContainerHighest;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(dimensions.borderRadius.sm),
    );
    final style = IconButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: shape,
    );

    return IconButton(
      style: style,
      onPressed: onPressed,
      icon: AppIcon(name: icon, color: color, size: size),
    );
  }
}
