import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../state/providers/app_mode_provider.dart';
import '../../caregiver_profile/providers/caregiver_profile_provider.dart';
import '../../elder_profile/providers/elder_profile_provider.dart';

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthUser {
  const AuthUser({
    required this.name,
    required this.identifier,
    required this.mode,
  });

  final String name;
  final String identifier;
  final AppUserMode mode;

  String get email => identifier;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'identifier': identifier,
      'mode': mode.name,
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      name: json['name'] as String? ?? '',
      identifier: json['identifier'] as String? ?? '',
      mode: AppUserMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => AppUserMode.caregiver,
      ),
    );
  }
}

class AuthState {
  const AuthState({
    required this.isAuthenticated,
    required this.isLoading,
    this.user,
    this.errorMessage,
  });

  const AuthState.unauthenticated()
      : isAuthenticated = false,
        isLoading = false,
        user = null,
        errorMessage = null;

  final bool isAuthenticated;
  final bool isLoading;
  final AuthUser? user;
  final String? errorMessage;

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    AuthUser? user,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : user ?? this.user,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  static const _authKey = 'pedulikeluarga_auth_user';

  @override
  AuthState build() {
    _loadAuth();
    // Return loading state initially while checking storage
    return const AuthState(isAuthenticated: false, isLoading: true);
  }

  Future<void> _loadAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Remove any previously saved auth to ensure the app always starts at login for the demo
      await prefs.remove(_authKey);
    } catch (_) {
      // Ignore errors
    }
    state = const AuthState.unauthenticated();
  }

  Future<void> _saveAuth(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authKey, jsonEncode(user.toJson()));
  }

  Future<void> _clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authKey);
  }

  /// Login masih mockup: form dapat dicoba, tetapi belum mengubah status auth.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();

    if (cleanEmail.isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Email dan password wajib diisi.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (cleanEmail == 'otw@puncak.com' && password == '12345678') {
      const mode = AppUserMode.caregiver;
      
      // Populate dummy data for Lansia and Anak
      final elder = ref.read(elderProfileProvider);
      if (elder.name.isEmpty) {
        ref.read(elderProfileProvider.notifier).saveProfile(
          elder.copyWith(name: 'Adyra', gender: 'Perempuan', age: '68 Tahun'),
        );
      }
      
      final caregiver = ref.read(caregiverProfileProvider);
      if (caregiver.name.isEmpty) {
        ref.read(caregiverProfileProvider.notifier).updateIdentity(
          name: 'Rachel',
          phoneNumber: '081234567890',
          relationship: 'Anak',
          address: 'Jakarta',
        );
      }

      final authUser = AuthUser(
        name: 'Rachel',
        identifier: cleanEmail,
        mode: mode,
      );

      await _saveAuth(authUser);

      ref.read(appModeControllerProvider.notifier).setMode(mode);
      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        user: authUser,
      );
      return true;
    }

    state = state.copyWith(
      isAuthenticated: false,
      isLoading: false,
      errorMessage: 'Kredensial salah atau belum terdaftar. Gunakan akun dummy atau daftar baru.',
      clearUser: true,
    );

    return false;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required AppUserMode mode,
  }) async {
    final cleanName = name.trim();
    final cleanEmail = email.trim();

    if (cleanName.isEmpty || cleanEmail.isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Nama, email, dan password wajib diisi.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final authUser = AuthUser(
      name: cleanName,
      identifier: cleanEmail,
      mode: mode,
    );

    await _saveAuth(authUser);

    ref.read(appModeControllerProvider.notifier).setMode(mode);

    state = AuthState(
      isAuthenticated: true,
      isLoading: false,
      user: authUser,
    );

    return true;
  }

  void logout() {
    _clearAuth();
    state = const AuthState.unauthenticated();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
