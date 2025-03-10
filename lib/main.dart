import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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

class MainApp extends ConsumerWidget {
  MainApp({super.key});
  ThemeMode? themeMode = ThemeMode.light; // initial brightness

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialLightTheme = ThemeData.light(useMaterial3: false);
    final materialDarkTheme = ThemeData.dark();

    const darkDefaultCupertinoTheme = CupertinoThemeData(
      brightness: Brightness.dark,
    );
    final cupertinoDarkTheme = MaterialBasedCupertinoThemeData(
      materialTheme: materialDarkTheme.copyWith(
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: Brightness.dark,
          barBackgroundColor: darkDefaultCupertinoTheme.barBackgroundColor,
          textTheme: CupertinoTextThemeData(
            primaryColor: Colors.white,
            navActionTextStyle: darkDefaultCupertinoTheme
                .textTheme
                .navActionTextStyle
                .copyWith(color: const Color(0xF0F9F9F9)),
            navLargeTitleTextStyle: darkDefaultCupertinoTheme
                .textTheme
                .navLargeTitleTextStyle
                .copyWith(color: const Color(0xF0F9F9F9)),
          ),
        ),
      ),
    );
    final cupertinoLightTheme = MaterialBasedCupertinoThemeData(
      materialTheme: materialLightTheme,
    );
    final appRouter = AppRouter(ref);
    return PlatformProvider(
      settings: PlatformSettingsData(
        iosUsesMaterialWidgets: true,
        iosUseZeroPaddingForAppbarPlatformIcon: true,
      ),
      builder:
          (context) => PlatformTheme(
            themeMode: themeMode,
            materialLightTheme: materialLightTheme,
            materialDarkTheme: materialDarkTheme,
            cupertinoLightTheme: cupertinoLightTheme,
            cupertinoDarkTheme: cupertinoDarkTheme,
            matchCupertinoSystemChromeBrightness: false,
            onThemeModeChanged: (themeMode) {
              this.themeMode = themeMode; /* you can save to storage */
            },
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
