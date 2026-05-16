import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../state/providers/app_mode_provider.dart';

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
  @override
  AuthState build() {
    return const AuthState.unauthenticated();
  }

  Future<bool> login({
    required String identifier,
    required String password,
    required AppUserMode mode,
  }) async {
    final cleanIdentifier = identifier.trim();

    if (cleanIdentifier.isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Email/nomor HP dan password wajib diisi.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    await Future<void>.delayed(const Duration(milliseconds: 250));

    ref.read(appModeControllerProvider.notifier).setMode(mode);

    state = AuthState(
      isAuthenticated: true,
      isLoading: false,
      user: AuthUser(
        name: mode == AppUserMode.elder ? 'Pengguna PeduliDiri' : 'Pengguna PeduliPenuh',
        identifier: cleanIdentifier,
        mode: mode,
      ),
    );

    return true;
  }

  Future<bool> register({
    required String name,
    required String identifier,
    required String password,
    required AppUserMode mode,
  }) async {
    final cleanName = name.trim();
    final cleanIdentifier = identifier.trim();

    if (cleanName.isEmpty || cleanIdentifier.isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Nama, email/nomor HP, dan password wajib diisi.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    await Future<void>.delayed(const Duration(milliseconds: 250));

    ref.read(appModeControllerProvider.notifier).setMode(mode);

    state = AuthState(
      isAuthenticated: true,
      isLoading: false,
      user: AuthUser(
        name: cleanName,
        identifier: cleanIdentifier,
        mode: mode,
      ),
    );

    return true;
  }

  void logout() {
    state = const AuthState.unauthenticated();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
