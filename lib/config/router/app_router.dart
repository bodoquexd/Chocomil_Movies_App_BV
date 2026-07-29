import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/screens.dart';
import 'package:chocomil_movies_app_bv/presentation/layouts/main_layout.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Splash
    GoRoute(
      path: '/splash',
      name: 'splash',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),

    //
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),

    // Register
    GoRoute(
      path: '/register',
      name: RegisterScreen.name,
      pageBuilder: (context, state) {
        final Map<String, dynamic>? initialData =
            state.extra as Map<String, dynamic>?;

        return CustomTransitionPage(
          key: state.pageKey,
          child: RegisterScreen(initialData: initialData),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),

    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        // Home
        GoRoute(
          path: '/home',
          name: HomeScreen.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        ),

        // Watchlist
        GoRoute(
          path: '/watchlist',
          name: 'watchlist',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const WatchlistScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        ),

        // Favorites
        GoRoute(
          path: '/favorites',
          name: 'favorites',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const FavoritesScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        ),

        // Profile
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ProfileScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        ),
      ],
    ),
  ],
);
