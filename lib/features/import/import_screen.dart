import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/imported_stats_repository.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../shared/widgets/outline_button.dart';
import '../../shared/widgets/watchers_logo.dart';
import 'imported_stats_store.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key, this.repository});

  final ImportedStatsRepository? repository;

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  late final ImportedStatsRepository _repository;
  bool _importing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? LocalDatasetImportRepository();
  }

  Future<void> _import() async {
    setState(() {
      _importing = true;
      _error = null;
    });
    try {
      final stats = await _repository.importStats();
      ImportedStatsStore.instance.handleImport(stats);
      if (!mounted) return;
      context.go('/import/success');
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _importing = false;
        _error = 'Could not import your data. Please try again.';
      });
    }
  }

  void _skip() {
    ImportedStatsStore.instance.clear();
    context.go('/shows');
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
                      Text(
                        'Import your Watchers history',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.displayTitle.copyWith(
                          color: palette.text,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Bring your stats from your previous tracking app so '
                        'your profile is ready right away.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body(14).copyWith(
                          color: palette.textSec,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _DatasetCard(),
                      const SizedBox(height: 24),
                      if (_importing)
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
                          label: 'Import my stats',
                          icon: Icons.download_outlined,
                          onPressed: _import,
                        ),
                      const SizedBox(height: 12),
                      OutlineButton(
                        label: 'Skip for now',
                        onPressed: _importing ? null : _skip,
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      Text(
                        'Your data stays on this device and is never uploaded.',
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

class _DatasetCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface2,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: palette.accentBg,
              borderRadius: BorderRadius.circular(AppConstants.radiusInput),
            ),
            child: Icon(
              Icons.description_outlined,
              size: 20,
              color: palette.accentBright,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'watchers_export.csv',
                  style: AppTextStyles.body(13, weight: FontWeight.w600)
                      .copyWith(color: palette.text),
                ),
                const SizedBox(height: 2),
                Text(
                  'Watches, ratings, comments and more',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.captionSmall.copyWith(
                    color: palette.textSec,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: palette.surface3,
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Text(
              'Ready',
              style: AppTextStyles.badge.copyWith(color: palette.textSec),
            ),
          ),
        ],
      ),
    );
  }
}