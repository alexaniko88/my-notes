import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = context.dimensions;
    final l10n = context.l10n;

    final labelStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: dimensions.spacing.lg,
          vertical: dimensions.spacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dimensions.borderRadius.md),
        ),
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GoogleG(size: dimensions.iconSize.md),
          Gap(dimensions.spacing.sm),
          Text(l10n.continueWithGoogle, style: labelStyle),
        ],
      ),
    );
  }
}

class _GoogleG extends StatelessWidget {
  static const _googleBlue = Color(0xFF4285F4);

  final double size;

  const _GoogleG({required this.size});

  @override
  Widget build(BuildContext context) {
    final gStyle = TextStyle(
      fontSize: size * 0.75,
      fontWeight: FontWeight.w700,
      color: _googleBlue,
      height: 1,
    );

    return SizedBox(
      width: size,
      height: size,
      child: Center(child: Text('G', style: gStyle)),
    );
  }
}
