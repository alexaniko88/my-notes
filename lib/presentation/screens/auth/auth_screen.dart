import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:my_notes/domain/models/auth_exception.dart';
import 'package:my_notes/gen/app_localizations.dart';
import 'package:my_notes/presentation/providers/auth/auth_provider.dart';
import 'package:my_notes/presentation/widgets/auth/google_sign_in_button.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  String? _mapAuthError(Object error, AppLocalizations l10n) {
    if (error is AuthCancelledException) return null;
    if (error is AuthNetworkException) return l10n.authErrorNetwork;
    return l10n.authErrorUnknown;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final dimensions = context.dimensions;
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final authError = authState.error;

    final errorStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.error,
    );
    final errorMessage =
        authError != null ? _mapAuthError(authError, l10n) : null;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: dimensions.spacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Gap(dimensions.spacing.xxl),
              const _AppLogo(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GoogleSignInButton(
                      onPressed: isLoading
                          ? null
                          : () => ref
                              .read(authProvider.notifier)
                              .signInWithGoogle(),
                    ),
                    if (errorMessage != null) ...[
                      Gap(dimensions.spacing.sm),
                      Text(errorMessage, style: errorStyle),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = context.dimensions;
    final l10n = context.l10n;

    final titleStyle = theme.textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Column(
      children: [
        Container(
          width: dimensions.imageSize.sm,
          height: dimensions.imageSize.sm,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(dimensions.borderRadius.xl),
          ),
          child: AppIcon(
            name: AppIconName.stickyNote2Outlined,
            size: dimensions.iconSize.xl,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        Gap(dimensions.spacing.md),
        Text(l10n.appTitle, style: titleStyle),
      ],
    );
  }
}
