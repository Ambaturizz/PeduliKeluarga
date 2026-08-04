import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/caregiver_profile.dart';

class CaregiverProfileRepository {
  static const _profileKey = 'caregiver_profile_v1';
  static CaregiverProfile? _cachedProfile;

  CaregiverProfileRepository();

  CaregiverProfile loadProfile() {
    if (_cachedProfile != null) return _cachedProfile!;

    _cachedProfile = CaregiverProfile.empty();
    return _cachedProfile!;
  }

  Future<CaregiverProfile> loadProfileAsync() async {
    if (_cachedProfile != null && _cachedProfile!.name.isNotEmpty) {
      return _cachedProfile!;
    }

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_profileKey);

    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final map = jsonDecode(jsonString) as Map<String, Object?>;
        _cachedProfile = CaregiverProfile.fromJson(map);
        return _cachedProfile!;
      } catch (_) {
        // Fallback if JSON is corrupted
      }
    }

    _cachedProfile = CaregiverProfile.empty();
    return _cachedProfile!;
  }

  Future<void> saveProfileAsync(CaregiverProfile profile) async {
    _cachedProfile = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  void saveProfile(CaregiverProfile profile) {
    _cachedProfile = profile;
    saveProfileAsync(profile);
  }

  Future<void> clearProfile() async {
    _cachedProfile = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }
}
