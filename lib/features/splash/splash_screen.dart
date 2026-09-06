import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../shared/widgets/watchers_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..forward();

  late final Animation<double> _logoAnimation = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.05, 0.7, curve: Curves.easeOutCubic),
  );

  late final Animation<double> _glowAnimation = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.85, curve: Curves.easeInOut),
  );

  late final Animation<double> _brandAnimation = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.4, 0.95, curve: Curves.easeOutCubic),
  );

  late final Animation<double> _ctaAnimation = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final logoSize = (size.width * 0.42).clamp(96.0, 168.0);
    final glowSize = logoSize * 3.1 > size.width ? size.width : logoSize * 3.1;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppGradients.splash),
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: FadeTransition(
                  opacity: _glowAnimation,
                  child: Container(
                    width: glowSize,
                    height: glowSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0.28),
                          AppColors.accentBrightDark.withValues(alpha: 0.06),
                          AppColors.accent.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.55, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: logoSize * 2.1,
                  height: logoSize * 2.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.12),
                      width: 1,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: _logoAnimation,
                        child: ScaleTransition(
                          scale: Tween<double>(
                            begin: 0.92,
                            end: 1.0,
                          ).animate(_logoAnimation),
                          child: WatchersLogo(size: logoSize),
                        ),
                      ),
                      SizedBox(height: logoSize * 0.3),
                      FadeTransition(
                        opacity: _brandAnimation,
                        child: SlideTransition(
                          position: Tween(
                            begin: const Offset(0, 0.08),
                            end: Offset.zero,
                          ).animate(_brandAnimation),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'WATCHERS',
                                style: AppTextStyles.splashWordmark,
                              ),
                              const SizedBox(height: 14),
                              const _SplashTagline(),
                              const SizedBox(height: 28),
                              const _SplashDivider(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 32,
                right: 32,
                bottom: 24,
                child: FadeTransition(
                  opacity: _ctaAnimation,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(_ctaAnimation),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: GradientButton(
                            label: 'Get Started',
                            onPressed: () => context.go('/auth'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Free forever · No subscription required',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.accentBrightDark.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashTagline extends StatelessWidget {
  const _SplashTagline();

  @override
  Widget build(BuildContext context) {
    return Text(
      'TRACK WHAT YOU WATCH',
      style: AppTextStyles.badge.copyWith(
        color: AppColors.accentBrightDark.withValues(alpha: 0.8),
        fontSize: 11,
        letterSpacing: 2.75,
      ),
    );
  }
}

class _SplashDivider extends StatelessWidget {
  const _SplashDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: AppGradients.cta,
      ),
    );
  }
}
