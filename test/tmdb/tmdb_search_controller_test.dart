import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/tmdb/data/dtos/paginated_response_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/search_result_dto.dart';
import 'package:watchers/features/tmdb/domain/errors/tmdb_exception.dart';
import 'package:watchers/features/tmdb/presentation/providers/tmdb_providers.dart';
import 'package:watchers/features/tmdb/presentation/providers/tmdb_search_controller.dart';

import 'helpers/fake_tmdb_remote_data_source.dart';

void main() {
  late FakeTmdbRemoteDataSource dataSource;
  late ProviderContainer container;

  setUp(() {
    dataSource = FakeTmdbRemoteDataSource();
    container = ProviderContainer(
      overrides: [
        tmdbRemoteDataSourceProvider.overrideWithValue(dataSource),
        searchDebounceProvider.overrideWithValue(Duration.zero),
      ],
    );
    addTearDown(container.dispose);
  });

  group('TmdbSearchController', () {
    test('starts with an empty result set', () {
      final state = container.read(tmdbSearchControllerProvider);

      expect(state.results, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.hasMore, isFalse);
    });

    test('runs a search and filters out people results', () async {
      dataSource.searchedMulti['dune:1'] = _searchPage([
        _movieResult(1, 'Dune'),
        _movieResult(2, 'Dune 2', 'person'),
      ]);

      container.read(tmdbSearchControllerProvider.notifier).search('dune');

      final state = await _settledSearch(container);

      expect(state.hasError, isFalse);
      expect(state.results.single.id, 1);
    });

    test('clears results for an empty or whitespace query', () async {
      dataSource.searchedMulti['x:1'] = _searchPage([_movieResult(1, 'X')]);
      container.read(tmdbSearchControllerProvider.notifier).search('x');
      await _settledSearch(container);

      container.read(tmdbSearchControllerProvider.notifier).search('   ');

      expect(container.read(tmdbSearchControllerProvider).results, isEmpty);
    });

    test('surfaces provider errors in the controller state', () async {
      dataSource.failWith(const TmdbException.network());

      container.read(tmdbSearchControllerProvider.notifier).search('dune');

      final state = await _settledSearch(container);

      expect(state.hasError, isTrue);
      expect(state.results, isEmpty);
    });

    test('respects the debounce duration provider', () {
      final debouncedContainer = ProviderContainer(
        overrides: [
          tmdbRemoteDataSourceProvider.overrideWithValue(dataSource),
          searchDebounceProvider.overrideWithValue(
            const Duration(milliseconds: 50),
          ),
        ],
      );
      addTearDown(debouncedContainer.dispose);

      final controller =
          debouncedContainer.read(tmdbSearchControllerProvider.notifier);
      controller.search('dune');

      expect(
        debouncedContainer.read(tmdbSearchControllerProvider).results,
        isEmpty,
      );
    });

    test('pagination appends the next page and stops at the last page',
        () async {
      dataSource.searchedMulti['dune:1'] = _searchPage(
        [_movieResult(1, 'Dune')],
        totalPages: 2,
      );
      dataSource.searchedMulti['dune:2'] = _searchPage(
        [_movieResult(2, 'Dune 2')],
        page: 2,
        totalPages: 2,
      );

      final notifier = container.read(tmdbSearchControllerProvider.notifier);
      notifier.search('dune');
      final first = await _settledSearch(container);

      expect(first.results, hasLength(1));
      expect(first.page, 1);
      expect(first.hasMore, isTrue);

      notifier.loadMore();
      final second = await _settledSearch(container);

      expect(second.results, hasLength(2));
      expect(second.page, 2);
      expect(second.hasMore, isFalse);
    });

    test('duplicate page requests are prevented', () async {
      final counting = _CountingDataSource();
      counting.searchedMulti['dune:1'] = _searchPage(
        [_movieResult(1, 'Dune')],
        totalPages: 2,
      );
      counting.searchedMulti['dune:2'] = _searchPage(
        [_movieResult(2, 'Dune 2')],
        page: 2,
        totalPages: 2,
      );
      final container = ProviderContainer(
        overrides: [
          tmdbRemoteDataSourceProvider.overrideWithValue(counting),
          searchDebounceProvider.overrideWithValue(Duration.zero),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(tmdbSearchControllerProvider.notifier);
      notifier.search('dune');
      await _settledSearch(container);

      notifier.loadMore();
      notifier.loadMore();
      notifier.loadMore();
      final state = await _settledSearch(container);

      expect(counting.multiCalls, 2);
      expect(state.results, hasLength(2));
      expect(state.page, 2);
    });

    test('changing the query resets pagination to page one', () async {
      dataSource.searchedMulti['dune:1'] = _searchPage(
        [_movieResult(1, 'Dune')],
        totalPages: 2,
      );
      dataSource.searchedMulti['dune:2'] = _searchPage(
        [_movieResult(2, 'Dune 2')],
        page: 2,
        totalPages: 2,
      );
      dataSource.searchedMulti['star:1'] = _searchPage([
        _movieResult(3, 'Star'),
      ]);

      final notifier = container.read(tmdbSearchControllerProvider.notifier);
      notifier.search('dune');
      await _settledSearch(container);
      notifier.loadMore();
      await _settledSearch(container);

      notifier.search('star');
      final state = await _settledSearch(container);

      expect(state.results.single.id, 3);
      expect(state.page, 1);
      expect(state.hasMore, isFalse);
    });

    test('stale page requests do not append into a new query', () async {
      dataSource.searchedMulti['dune:1'] = _searchPage(
        [_movieResult(1, 'Dune')],
        totalPages: 2,
      );
      dataSource.searchedMulti['star:1'] = _searchPage([
        _movieResult(3, 'Star'),
      ]);

      final notifier = container.read(tmdbSearchControllerProvider.notifier);
      notifier.search('dune');
      notifier.search('star');

      final state = await _settledSearch(container);

      expect(state.results.single.id, 3);
      expect(state.page, 1);
    });
  });
}

Future<TmdbSearchState> _settledSearch(ProviderContainer container) async {
  final current = container.read(tmdbSearchControllerProvider);
  if (!current.isLoading && !current.isLoadingMore) {
    return current;
  }
  final completer = Completer<TmdbSearchState>();
  late final ProviderSubscription subscription;
  subscription = container.listen<TmdbSearchState>(
    tmdbSearchControllerProvider,
    (previous, next) {
      if (!next.isLoading && !next.isLoadingMore && !completer.isCompleted) {
        completer.complete(next);
        subscription.close();
      }
    },
  );
  return completer.future;
}

class _CountingDataSource extends FakeTmdbRemoteDataSource {
  int multiCalls = 0;

  @override
  Future<PaginatedResponseDto<SearchResultDto>> searchMulti({
    required String query,
    int page = 1,
  }) {
    multiCalls++;
    return super.searchMulti(query: query, page: page);
  }
}

PaginatedResponseDto<SearchResultDto> _searchPage(
  List<SearchResultDto> items, {
  int page = 1,
  int totalPages = 1,
}) {
  return PaginatedResponseDto<SearchResultDto>(
    items: items,
    page: page,
    totalPages: totalPages,
    totalResults: items.length,
  );
}

SearchResultDto _movieResult(int id, String title, [String mediaType = 'movie']) {
  return SearchResultDto.fromJson({
    'id': id,
    'title': title,
    'name': title,
    'media_type': mediaType,
  });
}