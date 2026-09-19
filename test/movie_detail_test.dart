import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/tmdb/domain/entities/paginated_result.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_movie.dart';
import 'package:watchers/features/tmdb/domain/errors/tmdb_exception.dart';
import 'package:watchers/features/tmdb/domain/repositories/tmdb_repository.dart';
import 'package:watchers/shared/navigation/app_router.dart';

import 'helpers/auth_test_harness.dart';
import 'helpers/fake_tmdb_repository.dart';

Future<ProviderContainer> _goToShell(
  WidgetTester tester, {
  TmdbRepository? repo,
}) async {
  final container = await pumpApp(tester, tmdbRepository: repo);
  await goToShell(tester, container);
  return container;
}

Future<ProviderContainer> _goToMovies(WidgetTester tester) async {
  final container = await _goToShell(tester);
  await tester.tap(find.text('MOVIES'));
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets('View Details on the Movies tab opens the movie detail screen', (
    WidgetTester tester,
  ) async {
    await _goToMovies(tester);

    await tester.tap(find.text('View Details'));
    await tester.pumpAndSettle();

    expect(find.text('Meridian'), findsOneWidget);
    expect(find.text('2024 · 2h 8m'), findsOneWidget);
    expect(find.text('Synopsis'), findsOneWidget);
    expect(find.text('Cast'), findsOneWidget);
    expect(find.text('Similar Movies'), findsOneWidget);
    expect(find.text('Mark Watched'), findsOneWidget);
    expect(find.text('Add to Watchlist'), findsOneWidget);
  });

  testWidgets('watched and watchlist actions toggle from the detail screen', (
    WidgetTester tester,
  ) async {
    await _goToMovies(tester);

    await tester.tap(find.text('View Details'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add to Watchlist'));
    await tester.pumpAndSettle();
    expect(find.text('In Watchlist'), findsOneWidget);

    await tester.tap(find.text('Mark Watched'));
    await tester.pumpAndSettle();
    expect(find.text('Watched'), findsOneWidget);
  });

  testWidgets('an unknown movie id renders the movie-not-found state', (
    WidgetTester tester,
  ) async {
    final container = await _goToMovies(tester);

    container.read(routerProvider).go('/movies/detail/unknown');
    await tester.pumpAndSettle();

    expect(find.text('Movie not found'), findsOneWidget);
  });

  testWidgets('movie detail requests similar movies from the dedicated endpoint', (
    WidgetTester tester,
  ) async {
    final repo = FakeTmdbRepository();
    final container = await _goToShell(tester, repo: repo);

    container.read(routerProvider).go('/movies/detail/108');
    await tester.pumpAndSettle();

    expect(repo.similarMovieRequests, contains(108));
  });

  testWidgets('renders similar movies from the dedicated endpoint results', (
    WidgetTester tester,
  ) async {
    final container = await _goToShell(tester);

    container.read(routerProvider).go('/movies/detail/108');
    await tester.pumpAndSettle();

    expect(find.text('Similar Movies'), findsOneWidget);

    await tester.dragUntilVisible(
      find.text('Meridian'),
      find.byType(ListView),
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();

    expect(find.text('Meridian'), findsOneWidget);
    expect(find.text('The Forgotten Shore'), findsOneWidget);
  });

  testWidgets('hides similar movies when the endpoint returns nothing', (
    WidgetTester tester,
  ) async {
    final container = await _goToShell(tester, repo: _EmptySimilarRepository());

    container.read(routerProvider).go('/movies/detail/108');
    await tester.pumpAndSettle();

    expect(find.text('Aether'), findsOneWidget);
    expect(find.text('Similar Movies'), findsNothing);
  });

  testWidgets('shows the error state when the similar endpoint fails', (
    WidgetTester tester,
  ) async {
    final container = await _goToShell(tester, repo: _FailingSimilarRepository());

    container.read(routerProvider).go('/movies/detail/108');
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsOneWidget);
  });
}

class _EmptySimilarRepository extends FakeTmdbRepository {
  @override
  Future<PaginatedResult<TmdbMovie>> getSimilarMovies(
    int movieId, {
    int page = 1,
  }) async {
    similarMovieRequests.add(movieId);
    return PaginatedResult(
      items: const <TmdbMovie>[],
      page: page,
      totalPages: 0,
      totalResults: 0,
    );
  }
}

class _FailingSimilarRepository extends FakeTmdbRepository {
  @override
  Future<PaginatedResult<TmdbMovie>> getSimilarMovies(
    int movieId, {
    int page = 1,
  }) async {
    throw const TmdbException.network();
  }
}
