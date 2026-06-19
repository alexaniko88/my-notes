import 'package:flutter/material.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

/// Small uppercase-style heading above a group of notes (e.g. "Pinned").
class NotesSectionHeader extends StatelessWidget {
  final String title;

  const NotesSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.dimensions.spacing;
    final titleStyle = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
    );

    return Padding(
      padding: EdgeInsets.only(left: spacing.xs, bottom: spacing.sm),
      child: Text(title, style: titleStyle),
    );
  }
}
