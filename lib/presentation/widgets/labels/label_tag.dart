import 'package:flutter/material.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

/// A label chip shaped like a tag: rounded corners on the left,
/// pointed tip on the right.
class LabelTag extends StatelessWidget {
  final String name;
  final bool small;
  final VoidCallback? onTap;

  const LabelTag({
    super.key,
    required this.name,
    this.small = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = context.dimensions;

    final backgroundColor = theme.colorScheme.secondaryContainer;
    final textColor = theme.colorScheme.onSecondaryContainer;
    final textStyle =
        small
            ? theme.textTheme.labelSmall?.copyWith(color: textColor)
            : theme.textTheme.labelLarge?.copyWith(color: textColor);

    // the right side gets extra room so the text stays clear of the tip
    final padding =
        small
            ? EdgeInsets.only(
              left: dimensions.spacing.xs,
              right: dimensions.spacing.sm,
              top: dimensions.spacing.xs,
              bottom: dimensions.spacing.xs,
            )
            : EdgeInsets.only(
              left: dimensions.spacing.sm,
              right: dimensions.spacing.md,
              top: dimensions.spacing.xs,
              bottom: dimensions.spacing.xs,
            );

    return GestureDetector(
      onTap: onTap,
      child: ClipPath(
        clipper: const _LabelTagClipper(),
        child: Container(
          color: backgroundColor,
          padding: padding,
          child: Text(
            name,
            style: textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _LabelTagClipper extends CustomClipper<Path> {
  const _LabelTagClipper();

  @override
  Path getClip(Size size) {
    final radius = size.height * 0.25;
    final tipDepth = size.height * 0.35;
    return Path()
      ..moveTo(radius, 0)
      ..lineTo(size.width - tipDepth, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width - tipDepth, size.height)
      ..lineTo(radius, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - radius)
      ..lineTo(0, radius)
      ..quadraticBezierTo(0, 0, radius, 0)
      ..close();
  }

  @override
  bool shouldReclip(_LabelTagClipper oldClipper) => false;
}
