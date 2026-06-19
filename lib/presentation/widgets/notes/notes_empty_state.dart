import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

/// Centered icon + title (+ optional subtitle) shown when a notes list has
/// nothing to display — empty trash, a label with no notes, etc.
class NotesEmptyState extends StatelessWidget {
  final AppIconName icon;
  final String title;
  final String? subtitle;

  const NotesEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = context.dimensions;

    final color = theme.colorScheme.onSurfaceVariant;
    final titleStyle = theme.textTheme.bodyLarge?.copyWith(color: color);
    final subtitleStyle = theme.textTheme.labelSmall?.copyWith(
      color: color,
      fontStyle: FontStyle.italic,
    );
    final subtitleText = subtitle;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dimensions.spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(name: icon, size: dimensions.iconSize.xxl, color: color),
            Gap(dimensions.spacing.md),
            Text(title, style: titleStyle, textAlign: TextAlign.center),
            if (subtitleText != null) ...[
              Gap(dimensions.spacing.sm),
              Text(
                subtitleText,
                style: subtitleStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
