import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/features/search/search_screen.dart';
import 'package:watchers/features/search/widgets/search_content.dart';
import 'package:watchers/features/search/widgets/search_result_row.dart';
import 'package:watchers/features/tmdb/domain/entities/paginated_result.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_search_result.dart';
import 'package:watchers/features/tmdb/domain/errors/tmdb_exception.dart';
import 'package:watchers/features/tmdb/domain/repositories/tmdb_repository.dart';

import 'helpers/auth_test_harness.dart';
import 'helpers/fake_tmdb_repository.dart';

void main() {
  TmdbSearchResult result(int id, String title, {String mediaType = 'movie'}) {
    return TmdbSearchResult(
      id: id,
      title: title,
      mediaType: mediaType,
      posterUrl: 'https://example.com/poster-$id.jpg',
      overview: 'Overview for $title',
      releaseDate: DateTime(2024, 1, 1),
      rating: 7.5,
    );
  }

  Future<ProviderContainer> pumpSearchScreen(
    WidgetTester tester, {
    TmdbRepository? repo,
  }) async {
    final container = createTestContainer(tmdbRepository: repo);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: AppTheme.dark(), home: const SearchScreen()),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> typeQuery(WidgetTester tester, String query) async {
    await tester.enterText(find.byType(TextField), query);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
  }

  group('SearchScreen with TMDB search', () {
    testWidgets('renders movie and TV search results', (tester) async {
      final repo = _StaticSearchRepository([
        result(101, 'Meridian', mediaType: 'movie'),
        result(203, 'Meridian Falls', mediaType: 'tv'),
      ]);
      await pumpSearchScreen(tester, repo: repo);

      await typeQuery(tester, 'meridian');

      expect(find.byType(SearchResultRow), findsNWidgets(2));
      expect(
        find.descendant(
          of: find.byType(SearchResultRow).first,
          matching: find.text('Meridian'),
        ),
        findsOneWidget,
      );
      expect(
        find.ancestor(
          of: find.text('Meridian Falls'),
          matching: find.byType(SearchResultRow),
        ),
        findsOneWidget,
      );
      expect(find.text('2 results for "meridian"'), findsOneWidget);
    });

    testWidgets('shows the empty state when nothing matches', (tester) async {
      await pumpSearchScreen(tester, repo: _StaticSearchRepository([]));

      await typeQuery(tester, 'zzz');

      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('shows the error state when the search fails', (tester) async {
      await pumpSearchScreen(
        tester,
        repo: _FailingSearchRepository(const TmdbException.network()),
      );

      await typeQuery(tester, 'meridian');

      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('shows retry once the repository recovers', (tester) async {
      final repo = _FailingThenWorkingSearchRepository(
        _StaticSearchRepository([result(101, 'Meridian')]),
      );
      await pumpSearchScreen(tester, repo: repo);

      await typeQuery(tester, 'meridian');
      expect(find.text('Something went wrong'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.byType(SearchResultRow), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(SearchResultRow),
          matching: find.text('Meridian'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('paginates by loading the next page when scrolling',
        (tester) async {
      final repo = _PagedSearchRepository(perPage: 40, totalPages: 2);
      await pumpSearchScreen(tester, repo: repo);

      await typeQuery(tester, 'meridian');
      await tester.pumpAndSettle();
      expect(find.text('40 results for "meridian"'), findsOneWidget);
      expect(repo.requestedPages, {1});

      await tester.drag(find.byType(ListView), const Offset(0, -4000));
      await tester.pumpAndSettle();

      expect(repo.requestedPages, containsAll(<int>{1, 2}));
      expect(repo.multiCalls, 2);
      expect(find.text('Result 79'), findsOneWidget);
    });

    testWidgets('tapping a movie result opens the movie detail page',
        (tester) async {
      final repo = _StaticSearchRepository([
        result(101, 'Meridian', mediaType: 'movie'),
        result(203, 'Meridian Falls', mediaType: 'tv'),
      ]);
      await pumpApp(tester, tmdbRepository: repo);
      await goToShell(tester, createTestContainer());
      await tester.tap(find.text('SEARCH'));
      await tester.pumpAndSettle();
      await typeQuery(tester, 'meridian');

      await tester.tap(
        find.descendant(
          of: find.byType(SearchResultRow).first,
          matching: find.text('Meridian'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Synopsis'), findsOneWidget);
      expect(find.byType(SearchContent), findsNothing);
    });
  });
}

class _StaticSearchRepository extends FakeTmdbRepository {
  _StaticSearchRepository(this.searchResults);

  final List<TmdbSearchResult> searchResults;

  @override
  Future<PaginatedResult<TmdbSearchResult>> searchMulti({
    required String query,
    int page = 1,
  }) async {
    return PaginatedResult(
      items: searchResults,
      page: page,
      totalPages: 1,
      totalResults: searchResults.length,
    );
  }
}

class _FailingSearchRepository extends FakeTmdbRepository {
  _FailingSearchRepository(this.failure);

  final Object failure;

  @override
  Future<PaginatedResult<TmdbSearchResult>> searchMulti({
    required String query,
    int page = 1,
  }) async {
    throw failure;
  }
}

class _FailingThenWorkingSearchRepository extends FakeTmdbRepository {
  _FailingThenWorkingSearchRepository(this.inner)
      : failedAlready = false;

  final FakeTmdbRepository inner;
  bool failedAlready;

  @override
  Future<PaginatedResult<TmdbSearchResult>> searchMulti({
    required String query,
    int page = 1,
  }) async {
    if (!failedAlready) {
      failedAlready = true;
      throw const TmdbException.network();
    }
    return inner.searchMulti(query: query, page: page);
  }
}

class _PagedSearchRepository extends FakeTmdbRepository {
  _PagedSearchRepository({required this.perPage, required this.totalPages});

  final int perPage;
  final int totalPages;
  final Set<int> requestedPages = <int>{};
  int multiCalls = 0;

  @override
  Future<PaginatedResult<TmdbSearchResult>> searchMulti({
    required String query,
    int page = 1,
  }) async {
    multiCalls++;
    requestedPages.add(page);
    final items = <TmdbSearchResult>[];
    for (var i = 0; i < perPage; i++) {
      final n = (page - 1) * perPage + i;
      items.add(
        TmdbSearchResult(
          id: n,
          title: 'Result $n',
          mediaType: 'movie',
          posterUrl: 'https://example.com/poster-$n.jpg',
          overview: 'Overview for Result $n',
          releaseDate: DateTime(2024, 1, 1),
          rating: 7.0,
        ),
      );
    }
    return PaginatedResult(
      items: items,
      page: page,
      totalPages: totalPages,
      totalResults: perPage * totalPages,
    );
  }
}