import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/common/app_button.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppButton.secondary(
      label: context.l10n.continueWithGoogle,
      onPressed: onPressed,
    );
  }
}
