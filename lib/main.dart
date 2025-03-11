import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/core/local_storage_manager.dart';
import 'package:my_notes_flutter/core/utils.dart';
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

      final Notifications _notifications = Notifications();

      await _notifications.initialize();

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
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]).then((_) {
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
      });
    },
    (error, stackTrace) {
      FirebaseAnalytics.instance.logEvent(
        name: 'dart_error',
        parameters: {'error': error.toString(), 'stack': stackTrace.toString()},
      );
    },
  );
}

class MainApp extends ConsumerStatefulWidget {
  MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  final Notifications _notifications = Notifications();
  late StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
    super.initState();

    // Listen for auth state changes
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _notifications.requestNotificationPermission();

        _notifications.setupFirebaseMessaging(); // Setup FCM listener
        _notifications.listenToSharedNotes(
          ref,
        ); // Start listening for shared notes
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(ref);

    return PlatformProvider(
      settings: PlatformSettingsData(iosUsesMaterialWidgets: true),
      builder:
          (context) => PlatformTheme(
            themeMode: ThemeMode.light,
            materialLightTheme: ThemeData.light(useMaterial3: false),
            materialDarkTheme: ThemeData.dark(),
            builder:
                (context) => PlatformApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'My Notes App',
                  routerDelegate: appRouter.router.routerDelegate,
                  routeInformationParser:
                      appRouter.router.routeInformationParser,
                  routeInformationProvider:
                      appRouter.router.routeInformationProvider,
                ),
          ),
    );
  }
}
