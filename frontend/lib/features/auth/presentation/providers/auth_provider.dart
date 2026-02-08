import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aurabus/core/network/dio_client.dart';
import 'package:aurabus/core/services/token_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:aurabus/core/config/google_web_client_id.dart';
import '../../data/auth_repository.dart';
import '../../data/models/user_model.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;
  final User? user;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
    User? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  static Future<void>? _googleInitFuture;
  static String? _initializedWebClientId;

  static Future<void> _ensureGoogleInitialized({String? webClientId}) {
    if (!kIsWeb) {
      return _googleInitFuture ??= GoogleSignIn.instance.initialize();
    }

    if (webClientId == null || webClientId.trim().isEmpty) {
      return Future<void>.error(
        ArgumentError('Missing GOOGLE_AUTH_CLIENT_ID for Web'),
      );
    }

    final normalized = webClientId.trim();
    final alreadyInitializedWithSameClientId =
        _googleInitFuture != null && _initializedWebClientId == normalized;
    if (alreadyInitializedWithSameClientId) return _googleInitFuture!;

    _initializedWebClientId = normalized;
    _googleInitFuture = GoogleSignIn.instance.initialize(clientId: normalized);
    return _googleInitFuture!;
  }

  @override
  AuthState build() {
    Future.microtask(() => checkAuthStatus());
    return const AuthState();
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> checkAuthStatus() async {
    try {
      final user = await _repository.getUserProfile();
      if (user != null) {
        state = state.copyWith(isAuthenticated: true, user: user);
      } else {
        state = state.copyWith(isAuthenticated: false, user: null);
      }
    } catch (_) {
      state = state.copyWith(isAuthenticated: false, user: null);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.login(email, password);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> signup(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.signup(
        firstName,
        lastName,
        email,
        password,
      );
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      if (kIsWeb) {
        state = state.copyWith(
          isLoading: false,
        );
        return false;
      }

      await _ensureGoogleInitialized();

      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: const ['email'],
      );

      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'Google sign-in did not return an ID token',
        );
        return false;
      }

      return await loginWithGoogleIdToken(idToken);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        state = state.copyWith(isLoading: false, error: null);
        return false;
      }
      state = state.copyWith(
        isLoading: false,
        error: e.description ?? e.toString(),
      );
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> loginWithGoogleIdToken(String idToken) async {
    if (idToken.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Google sign-in did not return an ID token',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.googleLogin(idToken.trim());
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> ensureGoogleReadyForWeb() async {
    if (!kIsWeb) return;
    final webClientId = getGoogleAuthClientId();
    await _ensureGoogleInitialized(webClientId: webClientId);
  }

  void setAuthError(String? message) {
    state = state.copyWith(isLoading: false, error: message);
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(isAuthenticated: false);
  }
}

final tokenStorageProvider = Provider((ref) => TokenStorageService());

final dioClientProvider = Provider((ref) {
  final storage = ref.watch(tokenStorageProvider);
  return DioClient(storage);
});

final authRepositoryProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final storage = ref.watch(tokenStorageProvider);
  return AuthRepository(dioClient, storage);
});

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new,);
