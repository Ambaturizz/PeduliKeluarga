import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_environment.dart';
import 'core/config/app_initializer.dart';
import 'state/providers/app_config_provider.dart';

Future<void> main() async {
  final config = await AppInitializer.initialize(
    environment: AppEnvironment.development,
  );

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
      ],
      child: const PeduliKeluargaApp(),
    ),
  );
}
