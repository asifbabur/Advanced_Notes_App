import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes_flutter/common/bottom_nav_screen.dart';
import 'package:my_notes_flutter/core/local_storage_manager.dart';
import 'package:my_notes_flutter/feautures/auth/presentation/pages/auth_page.dart';
import 'package:my_notes_flutter/feautures/auth/presentation/providers/auth_provider.dart';
import 'package:my_notes_flutter/feautures/home/data/models/note.dart';
import 'package:my_notes_flutter/feautures/home/presentation/pages/home_page.dart';
import 'package:my_notes_flutter/feautures/home/presentation/pages/notes_page.dart';
import 'package:my_notes_flutter/feautures/onboarding/presentation/onboarding_page.dart';
import 'package:my_notes_flutter/feautures/profile/presentation/profile_screen.dart';

class AppRouter {
  final GoRouter router;

  AppRouter(WidgetRef ref)
    : router = GoRouter(
        refreshListenable: _AuthChangeNotifier(ref),
        initialLocation:
            ref.read(localStorageServiceProvider).isOnboardingComplete
                ? AuthPage.pagePath
                : OnboardingPage.pagePath,

        redirect: (context, state) {
          final authState = ref.read(authStateProvider);
          final isLoggedIn = authState.when(
            data: (user) => user != null,
            loading: () => false,
            error: (_, __) => false,
          );
          final isOnboardingComplete =
              ref.read(localStorageServiceProvider).isOnboardingComplete;
          final currentPath = state.uri.toString();

          if (!isOnboardingComplete && currentPath != OnboardingPage.pagePath) {
            return OnboardingPage.pagePath;
          }
          if (!isLoggedIn &&
              currentPath != AuthPage.pagePath &&
              isOnboardingComplete) {
            return AuthPage.pagePath;
          }
          if (isLoggedIn &&
              (currentPath == AuthPage.pagePath ||
                  currentPath == OnboardingPage.pagePath)) {
            return '/main/notes';
          }
          if (currentPath == '/main') {
            return '/main/notes';
          }
          return null;
        },

        routes: [
          GoRoute(
            path: OnboardingPage.pagePath,
            builder: (context, state) => const OnboardingPage(),
          ),

          GoRoute(
            path: AuthPage.pagePath,
            builder: (context, state) => const AuthPage(),
          ),

          GoRoute(
            path: AddEditNotePage.pagePath,
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>? ?? {};
              return AddEditNotePage(
                isEdit: args['isEdit'] ?? false,
                note: args['note'] as Note?,
              );
            },
          ),

          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return MainScreen(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/main/notes',
                    builder: (context, state) => const HomePage(),
                  ),
                ],
              ),

              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/main/profile',
                    builder: (context, state) => const ProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(WidgetRef ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
    ref.listen(localStorageServiceProvider, (_, __) => notifyListeners());
  }
}
