import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/tmdb_search_result.dart';
import 'tmdb_providers.dart';

final searchDebounceProvider = Provider<Duration>(
  (_) => const Duration(milliseconds: 300),
);

class TmdbSearchState {
  const TmdbSearchState({
    required this.results,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasError,
    required this.page,
    required this.totalPages,
  });

  const TmdbSearchState.initial()
      : results = const <TmdbSearchResult>[],
        isLoading = false,
        isLoadingMore = false,
        hasError = false,
        page = 0,
        totalPages = 0;

  final List<TmdbSearchResult> results;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final int page;
  final int totalPages;

  bool get hasMore => page < totalPages;

  TmdbSearchState copyWith({
    List<TmdbSearchResult>? results,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasError,
    int? page,
    int? totalPages,
  }) {
    return TmdbSearchState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class TmdbSearchController extends Notifier<TmdbSearchState> {
  Timer? _debounce;
  String _query = '';
  int _generation = 0;

  @override
  TmdbSearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    return const TmdbSearchState.initial();
  }

  void search(String query) {
    final trimmed = query.trim();
    _debounce?.cancel();
    if (trimmed.isEmpty) {
      _generation++;
      _query = '';
      state = const TmdbSearchState.initial();
      return;
    }
    final delay = ref.read(searchDebounceProvider);
    if (delay == Duration.zero) {
      _startSearch(trimmed);
      return;
    }
    _debounce = Timer(delay, () => _startSearch(trimmed));
  }

  void loadMore() {
    final current = state;
    if (_query.isEmpty || current.isLoading || current.isLoadingMore) return;
    if (!current.hasMore) return;
    state = current.copyWith(isLoadingMore: true);
    _fetchPage(_query, current.page + 1, append: true);
  }

  Future<void> _startSearch(String query) async {
    _generation++;
    final generation = _generation;
    _query = query;
    state = const TmdbSearchState.initial().copyWith(isLoading: true);
    await _fetchPage(query, 1, append: false, generation: generation);
  }

  Future<void> _fetchPage(
    String query,
    int page, {
    required bool append,
    int? generation,
  }) async {
    final gen = generation ?? _generation;
    final result = await AsyncValue.guard(
      () => ref.read(tmdbRepositoryProvider).searchMulti(query: query, page: page),
    );
    if (gen != _generation) return;
    final current = state;
    result.when(
      data: (value) {
        final items = value.items
            .where((item) => item.mediaType == 'movie' || item.mediaType == 'tv')
            .toList();
        state = TmdbSearchState(
          results: append ? [...current.results, ...items] : items,
          isLoading: false,
          isLoadingMore: false,
          hasError: false,
          page: value.page,
          totalPages: value.totalPages,
        );
      },
      error: (error, _) {
        state = TmdbSearchState(
          results: append ? current.results : const <TmdbSearchResult>[],
          isLoading: false,
          isLoadingMore: false,
          hasError: !append,
          page: current.page,
          totalPages: current.totalPages,
        );
      },
      loading: () {},
    );
  }
}

final tmdbSearchControllerProvider =
    NotifierProvider<TmdbSearchController, TmdbSearchState>(
      TmdbSearchController.new,
    );