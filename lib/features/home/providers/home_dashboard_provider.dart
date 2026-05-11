import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../state/providers/app_mode_provider.dart';
import '../data/home_dummy_data.dart';

final homeRealtimeClockProvider = StreamProvider.autoDispose<DateTime>((ref) {
  return Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
});

final homeDashboardProvider = Provider<HomeDashboardData>((ref) {
  final mode = ref.watch(appModeControllerProvider);
  final now = ref.watch(homeRealtimeClockProvider).maybeWhen(
        data: (value) => value,
        orElse: () => DateTime.now(),
      );

  return HomeDummyData.forMode(
    mode: mode,
    now: now,
  );
});