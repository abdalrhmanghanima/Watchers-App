import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/show.dart';
import '../../data/providers/content_repository_provider.dart';
import '../../features/tmdb/presentation/providers/show_ui_providers.dart';
import '../../shared/widgets/watcher_status_bar.dart';
import 'widgets/shows_content.dart';
import 'widgets/shows_header.dart';
import 'widgets/shows_status.dart';

class ShowsScreen extends ConsumerStatefulWidget {
  const ShowsScreen({super.key});

  @override
  ConsumerState<ShowsScreen> createState() => _ShowsScreenState();
}

class _ShowsScreenState extends ConsumerState<ShowsScreen> {
  final Map<String, bool> _watchedOverrides = {};
  final Map<String, Timer> _watchedPending = {};

  @override
  void dispose() {
    for (final timer in _watchedPending.values) {
      timer.cancel();
    }
    super.dispose();
  }

  void _applyWatched(String key) {
    setState(() {
      _watchedOverrides[key] = true;
      _watchedPending.remove(key)?.cancel();
    });
  }

  void _toggleWatched(String key) {
    if (_watchedOverrides[key] == true) {
      setState(() {
        _watchedOverrides[key] = false;
        _watchedPending.remove(key)?.cancel();
      });
      return;
    }
    if (_watchedPending.containsKey(key)) {
      setState(() {
        _watchedPending.remove(key)?.cancel();
      });
      return;
    }
    setState(() {
      _watchedPending[key] = Timer(const Duration(milliseconds: 2000), () {
        if (!mounted) return;
        _applyWatched(key);
      });
    });
  }

  void _clearWatched(String key) {
    setState(() {
      _watchedOverrides[key] = false;
      _watchedPending.remove(key)?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final userShowsAsync = ref.watch(userShowsProvider);
    final popular =
        ref.watch(showsPopularProviderAdapter).value ?? const <Show>[];
    final airingToday =
        ref.watch(showsAiringTodayProviderAdapter).value ?? const <Show>[];
    return Scaffold(
      backgroundColor: palette.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WatcherStatusBar(),
            const ShowsHeader(),
            Expanded(
              child: userShowsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => ShowsStatus(
                  icon: Icons.cloud_off_outlined,
                  title: 'Something went wrong',
                  message:
                      "We couldn't load shows. Check your connection and try again.",
                  actionLabel: 'Try again',
                  onAction: () => ref.invalidate(userShowsProvider),
                ),
                data: (shows) => ShowsContent(
                  shows: shows,
                  popularShows: popular,
                  airingTodayShows: airingToday,
                  watchedOverrides: _watchedOverrides,
                  pendingWatched: _watchedPending.keys.toSet(),
                  onToggleWatched: _toggleWatched,
                  onClearWatched: _clearWatched,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
