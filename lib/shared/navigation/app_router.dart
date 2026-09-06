import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_screen.dart';
import '../../features/comments/comments_screen.dart';
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
import '../../features/import/import_ready_screen.dart';
import '../../features/import/import_screen.dart';
import '../../data/models/search_result.dart';

abstract final class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _showsNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _moviesNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _searchNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _profileNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter instance = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(path: '/import', builder: (context, state) => const ImportScreen()),
      GoRoute(
        path: '/import/success',
        builder: (context, state) => const ImportReadyScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _showsNavigatorKey,
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
            navigatorKey: _moviesNavigatorKey,
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
            navigatorKey: _searchNavigatorKey,
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
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
}
