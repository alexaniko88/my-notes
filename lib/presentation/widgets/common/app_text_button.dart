import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class AppTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppIconName? leadingIcon;
  final Color? color;

  const AppTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    final style = TextButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: dimensions.spacing.xs),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      foregroundColor: color,
    );

    final iconName = leadingIcon;
    if (iconName != null) {
      return TextButton.icon(
        onPressed: onPressed,
        style: style,
        icon: AppIcon(name: iconName),
        label: Text(label),
      );
    }

    return TextButton(onPressed: onPressed, style: style, child: Text(label));
  }
}
