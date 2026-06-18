import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? error;
  const AuthState({required this.status, this.error});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _api;

  AuthNotifier(this._api)
      : super(const AuthState(status: AuthStatus.unknown)) {
    _checkSession();
  }

  Future<void> _checkSession() async {
    final has = await _api.hasToken();
    state = AuthState(
        status: has ? AuthStatus.authenticated : AuthStatus.unauthenticated);
  }

  Future<void> login(String email, String password) async {
    try {
      final resp = await _api.post('/auth/login',
          data: {'email': email, 'password': password});
      await _api.saveToken(resp.data['token'] as String);
      state = const AuthState(status: AuthStatus.authenticated);
    } catch (_) {
      state = const AuthState(
          status: AuthStatus.unauthenticated, error: 'Invalid credentials');
    }
  }

  Future<void> logout() async {
    await _api.clearToken();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:8080/api/v1',
      ),
    ));

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) =>
        AuthNotifier(ref.read(apiClientProvider)));
