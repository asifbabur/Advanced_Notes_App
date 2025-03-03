import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/core/local_storage_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_router.dart';
import 'firebase_options.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final sharedPreferences = await SharedPreferences.getInstance();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      // Global error handler
      FlutterError.onError = (FlutterErrorDetails details) {
        FirebaseAnalytics.instance.logEvent(
          name: 'flutter_error',
          parameters: {'error': details.exceptionAsString()},
        );
        FlutterError.presentError(
          details,
        ); // Optional: Show error in debug mode
      };
      runApp(
        ProviderScope(
          overrides: [
            localStorageServiceProvider.overrideWithValue(
              LocalStorageManager(sharedPreferences),
            ),
          ],
          child: MainApp(),
        ),
      );
    },
    (error, stackTrace) {
      FirebaseAnalytics.instance.logEvent(
        name: 'dart_error',
        parameters: {'error': error.toString(), 'stack': stackTrace.toString()},
      );
    },
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = AppRouter(ref);
    return MaterialApp.router(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      title: 'My Notes App',
      routerDelegate: appRouter.router.routerDelegate,
      routeInformationParser: appRouter.router.routeInformationParser,
      routeInformationProvider: appRouter.router.routeInformationProvider,
    );
  }
}
