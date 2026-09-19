import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/show.dart';
import '../../shared/widgets/watcher_back_button.dart';
import '../../shared/widgets/watcher_status_bar.dart';
import 'widgets/show_grid.dart';

class ShowListArgs {
  const ShowListArgs({required this.title, required this.shows});

  final String title;
  final List<Show> shows;
}

class ShowListScreen extends StatelessWidget {
  const ShowListScreen({super.key, required this.title, required this.shows});

  final String title;
  final List<Show> shows;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    return Scaffold(
      backgroundColor: palette.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WatcherStatusBar(),
            Padding(
              padding: EdgeInsets.fromLTRB(
                sizes.pagePadding,
                4,
                sizes.pagePadding,
                16,
              ),
              child: Row(
                children: [
                  const WatcherBackButton(),
                  SizedBox(width: sizes.itemGap),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.pageTitle.copyWith(
                        color: palette.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 40),
                children: [
                  const SizedBox(height: 8),
                  ShowGrid(
                    shows: shows,
                    onShowTap: (show) =>
                        context.push('/shows/detail/${show.id}'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
