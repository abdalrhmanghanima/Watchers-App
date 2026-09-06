import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../shared/widgets/outline_button.dart';
import '../../shared/widgets/watchers_logo.dart';
import 'widgets/auth_divider.dart';
import 'widgets/auth_field.dart';
import 'widgets/auth_mode_toggle.dart';
import 'widgets/auth_password_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _signup = false;
  bool _obscure = true;
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

  void _continue() {
    context.go(_signup ? '/import' : '/shows');
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
                      GradientButton(
                        label: _signup ? 'Create Account' : 'Sign In',
                        onPressed: _continue,
                      ),
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
                      Row(
                        children: [
                          Expanded(
                            child: OutlineButton(
                              icon: Icons.g_mobiledata,
                              label: 'Google',
                              onPressed: _continue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlineButton(
                              icon: Icons.apple,
                              label: 'Apple',
                              onPressed: _continue,
                            ),
                          ),
                        ],
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
