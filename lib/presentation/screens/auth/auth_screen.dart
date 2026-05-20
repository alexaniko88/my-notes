import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/presentation/widgets/auth/google_sign_in_button.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';
import 'package:my_notes/shared/navigation/app_route.dart';

enum _AuthMode { signIn, signUp }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const _fadeDuration = Duration(milliseconds: 120);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  _AuthMode _mode = _AuthMode.signIn;
  _AuthMode? _pendingMode;
  double _formOpacity = 1.0;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _switchMode(_AuthMode mode) {
    if (_formOpacity < 1.0) return;
    setState(() {
      _pendingMode = mode;
      _formOpacity = 0.0;
      _errorMessage = null;
    });
  }

  void _onFadeEnd() {
    final pending = _pendingMode;
    if (pending == null) return;
    setState(() {
      _mode = pending;
      _pendingMode = null;
      _formOpacity = 1.0;
    });
  }

  void _onSignIn() {
    final l10n = context.l10n;
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _errorMessage = l10n.authErrorEmptyFields);
      return;
    }
    context.goNamed(AppRoute.home.name);
  }

  void _onSignUp() {
    context.goNamed(AppRoute.home.name);
  }

  void _onToggleObscure() =>
      setState(() => _obscurePassword = !_obscurePassword);

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;
    final errorMsg = _errorMessage;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: dimensions.spacing.xl,
            vertical: dimensions.spacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Gap(dimensions.spacing.xxl),
              const _AppLogo(),
              Gap(dimensions.spacing.xl),
              AnimatedOpacity(
                opacity: _formOpacity,
                duration: _fadeDuration,
                onEnd: _onFadeEnd,
                child: _mode == _AuthMode.signIn
                    ? _SignInForm(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        obscurePassword: _obscurePassword,
                        onToggleObscure: _onToggleObscure,
                        errorMessage: errorMsg,
                        onSignIn: _onSignIn,
                        onSwitchToSignUp: () => _switchMode(_AuthMode.signUp),
                      )
                    : _SignUpForm(
                        onSignUp: _onSignUp,
                        onSwitchToSignIn: () => _switchMode(_AuthMode.signIn),
                      ),
              ),
              Gap(dimensions.spacing.xxl),
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
          child: Icon(
            Icons.sticky_note_2_outlined,
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

class _SignInForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final String? errorMessage;
  final VoidCallback onSignIn;
  final VoidCallback onSwitchToSignUp;

  const _SignInForm({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.errorMessage,
    required this.onSignIn,
    required this.onSwitchToSignUp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = context.dimensions;
    final l10n = context.l10n;
    final error = errorMessage;

    final errorStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.error,
    );
    final togglePromptStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(dimensions.borderRadius.md),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: l10n.emailLabel,
            prefixIcon: const Icon(Icons.email_outlined),
            border: inputBorder,
          ),
        ),
        Gap(dimensions.spacing.sm),
        TextField(
          controller: passwordController,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSignIn(),
          decoration: InputDecoration(
            labelText: l10n.passwordLabel,
            prefixIcon: const Icon(Icons.lock_outlined),
            border: inputBorder,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: onToggleObscure,
            ),
          ),
        ),
        if (error != null) ...[
          Gap(dimensions.spacing.sm),
          Text(error, style: errorStyle),
        ],
        Gap(dimensions.spacing.lg),
        FilledButton(
          onPressed: onSignIn,
          style: FilledButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: dimensions.spacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(dimensions.borderRadius.md),
            ),
          ),
          child: Text(l10n.signIn),
        ),
        Gap(dimensions.spacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.noAccount, style: togglePromptStyle),
            Gap(dimensions.spacing.xs),
            TextButton(
              onPressed: onSwitchToSignUp,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: dimensions.spacing.xs,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(l10n.signUp),
            ),
          ],
        ),
      ],
    );
  }
}

class _SignUpForm extends StatelessWidget {
  final VoidCallback onSignUp;
  final VoidCallback onSwitchToSignIn;

  const _SignUpForm({
    required this.onSignUp,
    required this.onSwitchToSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = context.dimensions;
    final l10n = context.l10n;

    final titleStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w600,
    );
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final togglePromptStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.signUp, style: titleStyle, textAlign: TextAlign.center),
        Gap(dimensions.spacing.xs),
        Text(
          l10n.gmailOnly,
          style: subtitleStyle,
          textAlign: TextAlign.center,
        ),
        Gap(dimensions.spacing.xl),
        GoogleSignInButton(onPressed: onSignUp),
        Gap(dimensions.spacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.haveAccount, style: togglePromptStyle),
            Gap(dimensions.spacing.xs),
            TextButton(
              onPressed: onSwitchToSignIn,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: dimensions.spacing.xs,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(l10n.signIn),
            ),
          ],
        ),
      ],
    );
  }
}
