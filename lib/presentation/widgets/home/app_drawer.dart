import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/presentation/widgets/common/app_text_button.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';
import 'package:my_notes/shared/navigation/app_route.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _onSignOut(BuildContext context) {
    // TODO(auth): call FirebaseAuth.instance.signOut() once firebase_auth is wired up
    context.go(AppRoute.auth.path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final dimensions = context.dimensions;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Padding(
              padding: EdgeInsets.all(dimensions.spacing.md),
              child: AppTextButton(
                label: l10n.signOut,
                leadingIcon: AppIconName.logout,
                color: theme.colorScheme.error,
                onPressed: () => _onSignOut(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
