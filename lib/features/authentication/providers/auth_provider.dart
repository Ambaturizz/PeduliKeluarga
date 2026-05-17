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

  String get email => identifier;
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

    state = state.copyWith(
      isAuthenticated: false,
      isLoading: false,
      errorMessage: 'Login masih mockup dan belum bisa digunakan. Silakan daftar akun baru.',
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

    ref.read(appModeControllerProvider.notifier).setMode(mode);

    state = AuthState(
      isAuthenticated: true,
      isLoading: false,
      user: AuthUser(
        name: cleanName,
        identifier: cleanEmail,
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
