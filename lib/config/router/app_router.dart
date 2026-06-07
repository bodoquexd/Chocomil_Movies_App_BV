/*import 'package:flutter/material.dart';
//que sea mas corto la direccion
import 'package:chocomil_movies_app_bv/presentation/screens/auth/register_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/screens.dart';
//que sea mas corto la direccion
import 'package:chocomil_movies_app_bv/presentation/screens/auth/login_screen.dart';

final appRouter = GoRouter( 
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/register',
      name: RegisterScreen.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const RegisterScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
  ],
);*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens
import 'package:chocomil_movies_app_bv/presentation/screens/screens.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/auth/login_screen.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/auth/register_screen.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/splash/splash_screen.dart';

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
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),

    // Home
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HomeScreen(),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),

    // Login
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),

    // Register
    GoRoute(
      path: '/register',
      name: RegisterScreen.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const RegisterScreen(),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
  ],
);