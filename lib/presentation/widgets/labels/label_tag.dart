import 'package:flutter/material.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

/// A label chip shaped like a tag: rounded corners on the left,
/// pointed tip on the right.
class LabelTag extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;

  const LabelTag({
    super.key,
    required this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = context.dimensions;

    final backgroundColor = theme.colorScheme.secondaryContainer;
    final textStyle = theme.textTheme.labelLarge?.copyWith(
      color: theme.colorScheme.onSecondaryContainer,
    );

    return GestureDetector(
      onTap: onTap,
      child: ClipPath(
        clipper: const _LabelTagClipper(),
        child: Container(
          color: backgroundColor,
          padding: EdgeInsets.only(
            left: dimensions.spacing.sm,
            // extra room so the text stays clear of the pointed tip
            right: dimensions.spacing.md,
            top: dimensions.spacing.xs,
            bottom: dimensions.spacing.xs,
          ),
          child: Text(name, style: textStyle),
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
