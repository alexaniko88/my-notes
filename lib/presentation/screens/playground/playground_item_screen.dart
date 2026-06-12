import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class PlaygroundItemConfig {
  const PlaygroundItemConfig({required this.label, required this.variants});

  final String label;
  final List<PlaygroundVariant> variants;
}

class PlaygroundVariant {
  const PlaygroundVariant({required this.label, required this.child});

  final String label;
  final Widget child;
}

class PlaygroundItemScreen extends StatelessWidget {
  const PlaygroundItemScreen({super.key, required this.config});

  final PlaygroundItemConfig config;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Scaffold(
      appBar: AppBar(title: Text(config.label)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              config.variants.map((v) => _VariantSection(variant: v)).toList(),
        ),
      ),
    );
  }
}

class _VariantSection extends StatelessWidget {
  const _VariantSection({required this.variant});

  final PlaygroundVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          variant.label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        Gap(spacing.xs),
        variant.child,
        Gap(spacing.md),
      ],
    );
  }
}
