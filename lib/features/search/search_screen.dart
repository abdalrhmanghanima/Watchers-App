import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/search_result.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/sources/mock_content_repository.dart';
import '../../shared/widgets/watcher_status_bar.dart';
import 'widgets/browse_categories.dart';
import 'widgets/search_content.dart';
import 'widgets/search_field.dart';
import 'widgets/search_recent_list.dart';
import 'widgets/search_status.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const List<String> _initialRecent = [
    'Meridian',
    'The Agency',
    'Veil',
    'Night Protocol',
  ];

  late final ContentRepository _repository =
      widget.repository ?? MockContentRepository();
  final TextEditingController _controller = TextEditingController();
  final List<String> _recent = List.of(_initialRecent);
  Future<List<SearchResult>>? _future;
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    setState(() {
      _query = value;
      final trimmed = value.trim();
      _future = trimmed.isEmpty ? null : _repository.search(trimmed);
    });
  }

  void _applyQuery(String value) {
    _controller.text = value;
    _onQueryChanged(value);
  }

  void _clearQuery() {
    _controller.clear();
    setState(() {
      _query = '';
      _future = null;
    });
  }

  void _retry() {
    _onQueryChanged(_query);
  }

  void _removeRecent(String item) {
    setState(() {
      _recent.remove(item);
    });
  }

  void _clearRecent() {
    setState(_recent.clear);
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
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.sizes.pagePadding,
                4,
                context.sizes.pagePadding,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search',
                    style: AppTextStyles.displayTitle.copyWith(
                      color: palette.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SearchField(
                    controller: _controller,
                    showClear: _query.isNotEmpty,
                    onChanged: _onQueryChanged,
                    onClear: _clearQuery,
                  ),
                ],
              ),
            ),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_query.trim().isEmpty) {
      return ListView(
        padding: const EdgeInsets.only(bottom: AppConstants.bottomNavOffset),
        children: [
          SearchRecentList(
            items: _recent,
            onSelect: _applyQuery,
            onRemove: _removeRecent,
            onClear: _clearRecent,
          ),
          BrowseCategories(onCategoryTap: _applyQuery),
        ],
      );
    }
    return FutureBuilder<List<SearchResult>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return SearchStatus(
            icon: Icons.cloud_off_outlined,
            title: 'Something went wrong',
            message:
                "We couldn't search right now. Check your connection and try again.",
            actionLabel: 'Try again',
            onAction: _retry,
          );
        }
        final results = snapshot.data ?? const <SearchResult>[];
        if (results.isEmpty) {
          return SearchStatus(
            icon: Icons.search_off,
            title: 'No results found',
            message:
                'Nothing matched "${_query.trim()}". Try a different search.',
            actionLabel: 'Clear search',
            onAction: _clearQuery,
          );
        }
        return SearchContent(query: _query, results: results);
      },
    );
  }
}
