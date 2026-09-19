import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/search_result.dart';
import '../adapters/tmdb_content_adapters.dart';
import 'tmdb_search_controller.dart';

class SearchViewModel {
  const SearchViewModel({
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasError,
    required this.hasMore,
    required this.results,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final bool hasMore;
  final List<SearchResult> results;
}

final searchViewModelProvider =
    NotifierProvider<SearchViewModelNotifier, SearchViewModel>(
      SearchViewModelNotifier.new,
    );

class SearchViewModelNotifier extends Notifier<SearchViewModel> {
  @override
  SearchViewModel build() {
    final state = ref.watch(tmdbSearchControllerProvider);
    return SearchViewModel(
      isLoading: state.isLoading,
      isLoadingMore: state.isLoadingMore,
      hasError: state.hasError,
      hasMore: state.hasMore,
      results: state.results.map(tmdbSearchResultToSearchResult).toList(),
    );
  }

  void search(String query) {
    ref.read(tmdbSearchControllerProvider.notifier).search(query);
  }

  void loadMore() {
    ref.read(tmdbSearchControllerProvider.notifier).loadMore();
  }
}