import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/outline_button.dart';
import '../../../../shared/widgets/watchers_logo.dart';
import '../../domain/errors/auth_exception.dart';
import '../providers/auth_controller.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_mode_toggle.dart';
import '../widgets/auth_password_field.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _signup = false;
  bool _obscure = true;
  bool _submitting = false;
  String? _formError;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _validate() {
    if (_signup && _name.text.trim().isEmpty) {
      setState(() => _formError = 'Enter your full name.');
      return false;
    }
    if (_email.text.trim().isEmpty) {
      setState(() => _formError = 'Enter your email address.');
      return false;
    }
    if (!_email.text.contains('@')) {
      setState(() => _formError = 'Enter a valid email address.');
      return false;
    }
    if (_password.text.isEmpty) {
      setState(() => _formError = 'Enter your password.');
      return false;
    }
    setState(() => _formError = null);
    return true;
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (!_validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    final controller = ref.read(authControllerProvider.notifier);
    final success = _signup
        ? await controller.signUp(
            displayName: _name.text,
            email: _email.text,
            password: _password.text,
          )
        : await controller.signIn(_email.text, _password.text);
    if (!mounted) return;
    if (success) {
      context.go(_signup ? '/import' : '/shows');
      return;
    }
    setState(() {
      _submitting = false;
      final error = ref.read(authControllerProvider).error;
      _formError = error is AuthException
          ? error.message
          : 'Something went wrong. Please try again.';
    });
  }

  Future<void> _handleGoogleSignIn() async {
    if (_submitting) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    final controller = ref.read(authControllerProvider.notifier);
    final success = await controller.signInWithGoogle();
    if (!mounted) return;
    if (success) {
      context.go('/shows');
      return;
    }
    setState(() {
      _submitting = false;
      final error = ref.read(authControllerProvider).error;
      if (error is AuthException && error.cancelled) return;
      _formError = error is AuthException
          ? error.message
          : 'Something went wrong. Please try again.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: dark ? AppGradients.auth : null,
          color: dark ? null : palette.bg,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (dark)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.6),
                      radius: 1.1,
                      colors: [
                        AppColors.accent.withValues(alpha: 0.25),
                        AppColors.accent.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.7],
                    ),
                  ),
                ),
              ),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          const WatchersLogo(size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'WATCHERS',
                            style: AppTextStyles.authWordmark.copyWith(
                              color: palette.text,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      AuthModeToggle(
                        signup: _signup,
                        onChanged: (value) => setState(() => _signup = value),
                      ),
                      const SizedBox(height: 24),
                      if (_signup) ...[
                        AuthField(
                          controller: _name,
                          hint: 'Full name',
                          nextFocus: _emailFocus,
                        ),
                        const SizedBox(height: 12),
                      ],
                      AuthField(
                        controller: _email,
                        hint: 'Email address',
                        keyboard: TextInputType.emailAddress,
                        nextFocus: _passwordFocus,
                        focusNode: _emailFocus,
                      ),
                      const SizedBox(height: 12),
                      AuthPasswordField(
                        controller: _password,
                        focusNode: _passwordFocus,
                        obscure: _obscure,
                        onToggle: () => setState(() => _obscure = !_obscure),
                      ),
                      if (!_signup)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Forgot password?',
                              style: AppTextStyles.body(
                                12,
                                weight: FontWeight.w500,
                              ).copyWith(color: palette.accentBright),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      if (_submitting)
                        SizedBox(
                          height: context.sizes.buttonHeight,
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: palette.accentBright,
                              ),
                            ),
                          ),
                        )
                      else
                        GradientButton(
                          label: _signup ? 'Create Account' : 'Sign In',
                          onPressed: _submit,
                        ),
                      if (_formError != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _formError!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Expanded(child: AuthDivider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or continue with',
                              style: AppTextStyles.caption.copyWith(
                                color: palette.textSec,
                              ),
                            ),
                          ),
                          const Expanded(child: AuthDivider()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      OutlineButton(
                        icon: Icons.g_mobiledata,
                        label: 'Google',
                        onPressed: _handleGoogleSignIn,
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              _signup
                                  ? 'Already have an account? '
                                  : "Don't have an account? ",
                              style: AppTextStyles.caption.copyWith(
                                color: palette.textSec,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _signup = !_signup),
                            child: Text(
                              _signup ? 'Sign in' : 'Sign up',
                              style: AppTextStyles.body(
                                12,
                                weight: FontWeight.w600,
                              ).copyWith(color: palette.accentBright),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}