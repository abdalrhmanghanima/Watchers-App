import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/tmdb/domain/entities/tmdb_movie.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_show.dart';
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

void main() {
  group('Movie detail from TMDB', () {
    testWidgets('renders TMDB movie data and cast', (tester) async {
      final container = await _goToShell(tester);

      container.read(routerProvider).go('/movies/detail/108');
      await tester.pumpAndSettle();

      expect(find.text('Aether'), findsOneWidget);
      expect(find.text('Synopsis'), findsOneWidget);
      expect(find.text('Sci-Fi'), findsOneWidget);

      await tester.dragUntilVisible(
        find.text('Zara Chen'),
        find.byType(ListView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cast'), findsOneWidget);
      expect(find.text('Zara Chen'), findsOneWidget);
      expect(find.text('Captain Freya Osei'), findsOneWidget);
    });

    testWidgets('shows the error state when TMDB fails', (tester) async {
      final container = await _goToShell(tester, repo: _FailingDetailsRepository());

      container.read(routerProvider).go('/movies/detail/108');
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Aether'), findsNothing);
    });

    testWidgets('shows the not-found state when TMDB has no such movie', (
      tester,
    ) async {
      final container = await _goToShell(tester);

      container.read(routerProvider).go('/movies/detail/999');
      await tester.pumpAndSettle();

      expect(find.text('Movie not found'), findsOneWidget);
    });

    testWidgets('shows a loading indicator while TMDB responds', (tester) async {
      final repo = _GatedDetailsRepository();
      final container = await _goToShell(tester, repo: repo);

      container.read(routerProvider).go('/movies/detail/108');
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      repo.gate.complete();
      await tester.pumpAndSettle();

      expect(find.text('Aether'), findsOneWidget);
    });
  });

  group('Show detail from TMDB', () {
    testWidgets('renders TMDB show data and cast', (tester) async {
      final container = await _goToShell(tester);

      container.read(routerProvider).go('/shows/detail/201');
      await tester.pumpAndSettle();

      expect(find.text('The Agency'), findsWidgets);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Seasons'), findsOneWidget);
      expect(find.text('Ongoing'), findsOneWidget);

      await tester.dragUntilVisible(
        find.text('Garrett Wells'),
        find.byType(ListView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cast'), findsOneWidget);
      expect(find.text('Diana Roth'), findsOneWidget);
      expect(find.text('Garrett Wells'), findsOneWidget);
    });

    testWidgets('shows the error state when TMDB fails', (tester) async {
      final container = await _goToShell(tester, repo: _FailingDetailsRepository());

      container.read(routerProvider).go('/shows/detail/201');
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('The Agency'), findsNothing);
    });

    testWidgets('shows the not-found state when TMDB has no such show', (
      tester,
    ) async {
      final container = await _goToShell(tester);

      container.read(routerProvider).go('/shows/detail/999');
      await tester.pumpAndSettle();

      expect(find.text('Show not found'), findsOneWidget);
    });
  });
}

class _FailingDetailsRepository extends FakeTmdbRepository {
  @override
  Future<TmdbMovie?> getMovieDetails(int movieId) async {
    throw const TmdbException.network();
  }

  @override
  Future<TmdbShow?> getShowDetails(int showId) async {
    throw const TmdbException.network();
  }
}

class _GatedDetailsRepository extends FakeTmdbRepository {
  final Completer<void> gate = Completer<void>();

  @override
  Future<TmdbMovie?> getMovieDetails(int movieId) async {
    await gate.future;
    return super.getMovieDetails(movieId);
  }
}