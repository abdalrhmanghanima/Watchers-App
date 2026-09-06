import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../shared/widgets/watchers_logo.dart';
import 'imported_stats_store.dart';
import 'widgets/imported_stats_summary.dart';

class ImportReadyScreen extends StatelessWidget {
  const ImportReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final stats = ImportedStatsStore.instance.stats;
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
                      Text(
                        'Your stats are ready',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.displayTitle.copyWith(
                          color: palette.text,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'We imported your Watchers history. Here is a taste '
                        'of what you have been up to.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body(14).copyWith(
                          color: palette.textSec,
                        ),
                      ),
                      const SizedBox(height: 28),
                      if (stats != null) ImportedStatsSummary(stats: stats),
                      const SizedBox(height: 28),
                      GradientButton(
                        label: 'Continue to Watchers',
                        onPressed: () => context.go('/shows'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'You can always reset your imported stats later in '
                        'Profile.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.captionSmall.copyWith(
                          color: palette.textSec,
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
    );
  }
}