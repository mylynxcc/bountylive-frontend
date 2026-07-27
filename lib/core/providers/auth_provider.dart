import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';
import '../network/api_client.dart';

class AuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final String? token;
  final Map<String, dynamic>? user;
  final String? error;

  const AuthState({
    this.isLoggedIn = false,
    this.isLoading = false,
    this.token,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    String? token,
    Map<String, dynamic>? user,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      user: user ?? this.user,
      error: error,
    );
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    // Auto-restore session on startup
    final apiClient = ref.read(apiClientProvider);
    final token = await apiClient.getToken();

    if (token == null) {
      return const AuthState();
    }

    try {
      final response = await apiClient.get('/auth/me');
      final data = response.data as Map<String, dynamic>;
      final user = data['user'] as Map<String, dynamic>;

      return AuthState(isLoggedIn: true, token: token, user: user);
    } catch (_) {
      await apiClient.clearToken();
      return const AuthState();
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      final user = data['user'] as Map<String, dynamic>;

      await apiClient.setToken(token);

      state = AsyncData(AuthState(
        isLoggedIn: true,
        token: token,
        user: user,
      ));
    } on DioException catch (e) {
      final message = e.response?.data?['message'] as String? ?? 'Login failed';
      state = AsyncData(const AuthState().copyWith(error: message));
    } catch (e) {
      state = AsyncData(const AuthState().copyWith(error: 'An unexpected error occurred'));
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    String? userType,
  }) async {
    state = const AsyncLoading();
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.post('/auth/register', data: {
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'user_type': userType ?? 'viewer',
      });

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      final user = data['user'] as Map<String, dynamic>;

      await apiClient.setToken(token);

      state = AsyncData(AuthState(
        isLoggedIn: true,
        token: token,
        user: user,
      ));
    } on DioException catch (e) {
      final message = e.response?.data?['message'] as String? ?? 'Registration failed';
      state = AsyncData(const AuthState().copyWith(error: message));
    }
  }

  Future<void> socialLogin(String provider, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.post('/auth/social/$provider', data: data);

      final result = response.data as Map<String, dynamic>;
      final token = result['token'] as String;
      final user = result['user'] as Map<String, dynamic>;

      await apiClient.setToken(token);

      state = AsyncData(AuthState(
        isLoggedIn: true,
        token: token,
        user: user,
      ));
    } on DioException catch (e) {
      final message = e.response?.data?['message'] as String? ?? 'Social login failed';
      state = AsyncData(const AuthState().copyWith(error: message));
    }
  }

  Future<void> logout() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.post('/auth/logout');
    } catch (_) {}
    await ref.read(apiClientProvider).clearToken();
    state = const AsyncData(AuthState());
  }

  void clearError() {
    final current = state.asData?.value;
    if (current != null && current.error != null) {
      state = AsyncData(current.copyWith(error: null));
    }
  }
}
