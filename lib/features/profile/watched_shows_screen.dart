import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/show.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/sources/mock_content_repository.dart';
import '../../shared/widgets/watcher_status_bar.dart';
import 'widgets/profile_empty_state.dart';
import 'widgets/profile_page_header.dart';
import 'widgets/show_grid.dart';

class WatchedShowsScreen extends StatefulWidget {
  const WatchedShowsScreen({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<WatchedShowsScreen> createState() => _WatchedShowsScreenState();
}

class _WatchedShowsScreenState extends State<WatchedShowsScreen> {
  late final ContentRepository _repository =
      widget.repository ?? MockContentRepository();
  late Future<List<Show>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.getShows();
  }

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Scaffold(
      backgroundColor: palette.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WatcherStatusBar(),
            const ProfilePageHeader(title: 'Shows'),
            Expanded(
              child: FutureBuilder<List<Show>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  final watchedShows = snapshot.data!
                      .where((s) => (s.progress ?? 0) > 0)
                      .toList();
                  if (watchedShows.isEmpty) {
                    return const ProfileEmptyState(
                      title: 'No watched shows',
                      message: 'Start watching shows to see them here',
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 40),
                    children: [
                      const SizedBox(height: 16),
                      ShowGrid(
                        shows: watchedShows,
                        onShowTap: (show) =>
                            context.push('/shows/detail/${show.id}'),
                      ),
                    ],
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
