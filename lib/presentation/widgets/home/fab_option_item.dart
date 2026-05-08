import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class FabOptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Animation<double> animation;
  final VoidCallback? onPressed;

  const FabOptionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.animation,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = context.dimensions;
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(animation),
        child: FilledButton(
          onPressed: onPressed ?? () {},
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            shape: const StadiumBorder(),
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.spacing.lg,
              vertical: dimensions.spacing.md,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: dimensions.iconSize.md),
              Gap(dimensions.spacing.sm),
              Text(label, style: theme.textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
