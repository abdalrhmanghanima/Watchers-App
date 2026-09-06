import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/show.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/sources/mock_content_repository.dart';
import '../../shared/widgets/watcher_status_bar.dart';
import 'widgets/shows_content.dart';
import 'widgets/shows_header.dart';
import 'widgets/shows_status.dart';

class ShowsScreen extends StatefulWidget {
  const ShowsScreen({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<ShowsScreen> createState() => _ShowsScreenState();
}

class _ShowsScreenState extends State<ShowsScreen> {
  late final ContentRepository _repository =
      widget.repository ?? MockContentRepository();
  late Future<List<Show>> _future;
  final Map<String, bool> _watchedOverrides = {};
  final Map<String, Timer> _watchedPending = {};

  @override
  void initState() {
    super.initState();
    _future = _repository.getShows();
  }

  @override
  void dispose() {
    for (final timer in _watchedPending.values) {
      timer.cancel();
    }
    super.dispose();
  }

  void _reload() {
    setState(() {
      _future = _repository.getShows();
    });
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
    return Scaffold(
      backgroundColor: palette.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WatcherStatusBar(),
            const ShowsHeader(),
            Expanded(
              child: FutureBuilder<List<Show>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return ShowsStatus(
                      icon: Icons.cloud_off_outlined,
                      title: 'Something went wrong',
                      message:
                          "We couldn't load shows. Check your connection and try again.",
                      actionLabel: 'Try again',
                      onAction: _reload,
                    );
                  }
                  final shows = snapshot.data ?? const <Show>[];
                  if (shows.isEmpty) {
                    return ShowsStatus(
                      icon: Icons.live_tv_outlined,
                      title: 'No shows yet',
                      message:
                          'There are no shows to explore right now. Check back soon.',
                    );
                  }
                  return ShowsContent(
                    shows: shows,
                    watchedOverrides: _watchedOverrides,
                    pendingWatched: _watchedPending.keys.toSet(),
                    onToggleWatched: _toggleWatched,
                    onClearWatched: _clearWatched,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
