import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_config.dart';
import 'app_environment.dart';

final class AppInitializer {
  const AppInitializer._();

  static Future<AppConfig> initialize({
    required AppEnvironment environment,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);

      if (kReleaseMode) {
        // TODO: Integrate crash reporting service.
      }
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      if (kReleaseMode) {
        // TODO: Integrate crash reporting service.
      }

      return false;
    };

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    return AppConfig.forEnvironment(environment);
  }
}