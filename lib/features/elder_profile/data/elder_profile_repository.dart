import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/elder_profile.dart';

/// Repository untuk menyimpan dan memuat profil lansia ke/dari local storage.
/// Menggunakan SharedPreferences agar data tetap ada setelah app ditutup.
class ElderProfileRepository {
  static const _profileKey = 'elder_profile_v1';
  static const _idKey = 'elder_profile_id';
  static const _codeKey = 'elder_profile_code';

  // In-memory cache agar tidak perlu baca disk setiap build
  static ElderProfile? _cachedProfile;

  ElderProfileRepository();

  /// Muat profil dari SharedPreferences.
  /// Jika belum ada, buat profil kosong baru dengan ID unik.
  ElderProfile loadProfile() {
    if (_cachedProfile != null) return _cachedProfile!;

    // Sinkron: kembalikan cache kosong, async load akan update via provider
    _cachedProfile = ElderProfile.empty(
      id: 'elder-${DateTime.now().millisecondsSinceEpoch}',
      connectionCode: generateConnectionCode(),
    );
    return _cachedProfile!;
  }

  /// Muat profil secara async dari SharedPreferences.
  Future<ElderProfile> loadProfileAsync() async {
    if (_cachedProfile != null && _cachedProfile!.name.isNotEmpty) {
      return _cachedProfile!;
    }

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_profileKey);

    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final map = jsonDecode(jsonString) as Map<String, Object?>;
        _cachedProfile = ElderProfile.fromJson(map);
        return _cachedProfile!;
      } catch (_) {
        // JSON rusak — buat baru
      }
    }

    // Tidak ada data tersimpan: buat profil baru dengan ID persisten
    final existingId = prefs.getString(_idKey);
    final existingCode = prefs.getString(_codeKey);

    final id = existingId ?? 'elder-${DateTime.now().millisecondsSinceEpoch}';
    final code = existingCode ?? generateConnectionCode();

    await prefs.setString(_idKey, id);
    await prefs.setString(_codeKey, code);

    _cachedProfile = ElderProfile.empty(id: id, connectionCode: code);
    return _cachedProfile!;
  }

  /// Simpan profil ke memory cache dan SharedPreferences.
  Future<void> saveProfileAsync(ElderProfile profile) async {
    _cachedProfile = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  /// Simpan sinkron ke cache (tetap perlu saveProfileAsync untuk persist).
  void saveProfile(ElderProfile profile) {
    _cachedProfile = profile;
    // Fire-and-forget ke disk
    saveProfileAsync(profile);
  }

  String generateConnectionCode() {
    final random = Random.secure();
    final number = List.generate(6, (_) => random.nextInt(10)).join();
    return 'PK-$number';
  }

  /// Hapus semua data profil lansia (saat logout).
  Future<void> clearProfile() async {
    _cachedProfile = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }
}
