import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes_flutter/common/bottom_nav_screen.dart';
import 'package:my_notes_flutter/core/local_storage_manager.dart';
import 'package:my_notes_flutter/feautures/auth/presentation/pages/auth_page.dart';
import 'package:my_notes_flutter/feautures/auth/presentation/providers/auth_provider.dart';
import 'package:my_notes_flutter/feautures/onboarding/presentation/onboarding_page.dart';

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

          if (!isOnboardingComplete &&
              state.uri.toString() != OnboardingPage.pagePath) {
            return OnboardingPage.pagePath;
          }
          if (!isLoggedIn &&
              state.uri.toString() != AuthPage.pagePath &&
              isOnboardingComplete) {
            return AuthPage.pagePath;
          }
          if (isLoggedIn &&
              (state.uri.toString() == AuthPage.pagePath ||
                  state.uri.toString() == OnboardingPage.pagePath)) {
            return MainScreen.pagePath;
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
            path: MainScreen.pagePath,
            builder: (context, state) => const MainScreen(),
          ),
          // Fallback route, redirect to MainScreen
          GoRoute(path: '/', builder: (context, state) => const MainScreen()),
        ],
      );
}

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(WidgetRef ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
    ref.listen(localStorageServiceProvider, (_, __) => notifyListeners());
  }
}
