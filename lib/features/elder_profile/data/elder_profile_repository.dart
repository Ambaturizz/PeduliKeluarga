import 'dart:math';

import '../domain/elder_profile.dart';

class ElderProfileRepository {
  ElderProfileRepository() {
    _cachedProfile ??= ElderProfile.empty(
      id: 'elder-${DateTime.now().millisecondsSinceEpoch}',
      connectionCode: generateConnectionCode(),
    );
  }

  static ElderProfile? _cachedProfile;

  ElderProfile loadProfile() => _cachedProfile!;

  void saveProfile(ElderProfile profile) {
    _cachedProfile = profile;
  }

  String generateConnectionCode() {
    final random = Random.secure();
    final number = List.generate(6, (_) => random.nextInt(10)).join();
    return 'PK-$number';
  }
}
