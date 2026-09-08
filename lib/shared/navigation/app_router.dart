import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/search_result.dart';
import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/comments/comments_screen.dart';
import '../../features/import/import_ready_screen.dart';
import '../../features/import/import_screen.dart';
import '../../features/main_shell/main_shell.dart';
import '../../features/movies/movie_detail_screen.dart';
import '../../features/movies/movie_list_screen.dart';
import '../../features/movies/movies_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/settings_screen.dart';
import '../../features/profile/watched_movies_screen.dart';
import '../../features/profile/watched_shows_screen.dart';
import '../../features/profile/watchlist_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/shows/episode_detail/episode_detail_screen.dart';
import '../../features/shows/episodes_screen.dart';
import '../../features/shows/show_detail_screen.dart';
import '../../features/shows/shows_screen.dart';
import '../../features/splash/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ValueNotifier<AsyncValue<AuthUser?>>(
    ref.read(authControllerProvider),
  );
  ref.listen<AsyncValue<AuthUser?>>(authControllerProvider, (_, next) {
    authNotifier.value = next;
  });
  ref.onDispose(authNotifier.dispose);

  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final showsNavigatorKey = GlobalKey<NavigatorState>();
  final moviesNavigatorKey = GlobalKey<NavigatorState>();
  final searchNavigatorKey = GlobalKey<NavigatorState>();
  final profileNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final auth = authNotifier.value;
      if (!auth.hasValue || auth.isLoading) return null;
      final authenticated = auth.value != null;
      final location = state.uri.path;
      if (authenticated) {
        if (location == '/') return '/shows';
        return null;
      }
      if (location == '/' || location == '/auth') return null;
      return '/auth';
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: '/import',
        builder: (context, state) => const ImportScreen(),
      ),
      GoRoute(
        path: '/import/success',
        builder: (context, state) => const ImportReadyScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: showsNavigatorKey,
            routes: [
              GoRoute(
                path: '/shows',
                builder: (context, state) => const ShowsScreen(),
                routes: [
                  GoRoute(
                    path: 'detail/:id',
                    builder: (context, state) =>
                        ShowDetailScreen(showId: state.pathParameters['id']!),
                    routes: [
                      GoRoute(
                        path: 'episodes/:season',
                        builder: (context, state) => EpisodesScreen(
                          showId: state.pathParameters['id']!,
                          season:
                              int.tryParse(
                                state.pathParameters['season'] ?? '',
                              ) ??
                              1,
                        ),
                      ),
                      GoRoute(
                        path: 'episode/:season/:episode',
                        builder: (context, state) => EpisodeDetailScreen(
                          showId: state.pathParameters['id']!,
                          season:
                              int.tryParse(
                                state.pathParameters['season'] ?? '',
                              ) ??
                              1,
                          episode:
                              int.tryParse(
                                state.pathParameters['episode'] ?? '',
                              ) ??
                              1,
                        ),
                      ),
                      GoRoute(
                        path: 'episode-comments/:itemId',
                        builder: (context, state) => CommentsScreen(
                          itemId: state.pathParameters['itemId']!,
                          itemType: ContentType.episode,
                        ),
                      ),
                      GoRoute(
                        path: 'comments',
                        builder: (context, state) => CommentsScreen(
                          itemId: state.pathParameters['id']!,
                          itemType: ContentType.show,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: moviesNavigatorKey,
            routes: [
              GoRoute(
                path: '/movies',
                builder: (context, state) => const MoviesScreen(),
                routes: [
                  GoRoute(
                    path: 'list',
                    builder: (context, state) {
                      final args = state.extra as MovieListArgs;
                      return MovieListScreen(
                        title: args.title,
                        movies: args.movies,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'detail/:id',
                    builder: (context, state) =>
                        MovieDetailScreen(movieId: state.pathParameters['id']!),
                    routes: [
                      GoRoute(
                        path: 'comments',
                        builder: (context, state) => CommentsScreen(
                          itemId: state.pathParameters['id']!,
                          itemType: ContentType.movie,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: searchNavigatorKey,
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                  GoRoute(
                    path: 'watchlist',
                    builder: (context, state) => const WatchlistScreen(),
                  ),
                  GoRoute(
                    path: 'watched-shows',
                    builder: (context, state) => const WatchedShowsScreen(),
                  ),
                  GoRoute(
                    path: 'watched-movies',
                    builder: (context, state) => const WatchedMoviesScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});