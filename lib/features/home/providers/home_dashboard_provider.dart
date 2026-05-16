import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../state/providers/app_mode_provider.dart';
import '../../caregiver_profile/providers/caregiver_profile_provider.dart';
import '../../elder_profile/providers/elder_profile_provider.dart';
import '../data/home_dummy_data.dart';

final homeRealtimeClockProvider = StreamProvider.autoDispose<DateTime>((ref) {
  return Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
});

final homeDashboardProvider = Provider<HomeDashboardData>((ref) {
  final mode = ref.watch(appModeControllerProvider);
  final elderProfile = ref.watch(elderProfileProvider);
  final caregiverProfile = ref.watch(caregiverProfileProvider);

  final now = ref.watch(homeRealtimeClockProvider).maybeWhen(
        data: (value) => value,
        orElse: DateTime.now,
      );

  return HomeDummyData.byMode(
    mode: mode,
    now: now,
    elderProfile: elderProfile,
    caregiverProfile: caregiverProfile,
  );
});
