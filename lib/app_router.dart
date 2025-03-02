import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes_flutter/feautures/auth/presentation/pages/auth_page.dart';
import 'package:my_notes_flutter/feautures/auth/presentation/providers/auth_provider.dart';
import 'package:my_notes_flutter/feautures/notes/presentation/pages/home_page.dart';

class AppRouter {
  final GoRouter router;

  // The constructor takes a WidgetRef so we can read auth state.
  AppRouter(WidgetRef ref)
      : router = GoRouter(
          // Use a custom ChangeNotifier to refresh the router on auth changes.
          refreshListenable: _AuthChangeNotifier(ref),
          redirect: (context, state) {
            // Get the current auth state
            final authState = ref.read(authStateProvider);
            final isLoggedIn = authState.when(
              data: (user) => user != null,
              loading: () => false,
              error: (_, __) => false,
            );

            // Check if the current route is the login page.
            final isLoggingIn = state.matchedLocation == '/login';

            // Redirect logic:
            // If not logged in and not on login, force login.
            if (!isLoggedIn && !isLoggingIn) return '/login';
            // If logged in and on login page, redirect to home.
            if (isLoggedIn && isLoggingIn) return '/';
            // Otherwise, no redirection.
            return null;
          },
          routes: [
            GoRoute(
              path: '/login',
              builder: (context, state) => const LoginPage(),
            ),
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
            ),
          ],
        );
}

/// A simple ChangeNotifier that listens to auth state changes via Riverpod.
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(WidgetRef ref) {
    ref.listen(authStateProvider, (_, __) {
      notifyListeners();
    });
  }
}
