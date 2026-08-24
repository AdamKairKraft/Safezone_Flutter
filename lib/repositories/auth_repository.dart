import 'package:dio/dio.dart';

import '../models/user.dart';
import '../network/auth_session.dart';
import '../storage/secure_storage.dart';

/// Owns login/refresh/logout. Uses its own plain (non-interceptor) Dio instance for these
/// calls - mirroring safezone-web's client.ts, which calls the raw `axios` for
/// `/api/auth/refresh` specifically so the refresh call itself never gets caught by the
/// same 401-triggers-refresh interceptor that depends on it.
class AuthRepository {
  AuthRepository({required this.baseUrl, required this.session, required this.secureStorage})
      : _rawDio = Dio(BaseOptions(baseUrl: baseUrl));

  final String baseUrl;
  final AuthSession session;
  final SecureStorage secureStorage;
  final Dio _rawDio;

  // Concurrent 401s should share one in-flight refresh rather than each independently
  // spending (and rotating) a refresh token - same reasoning as safezone-web's client.ts.
  Future<String?>? _inFlightRefresh;

  Future<AppUser> login(String email, String password) async {
    final response = await _rawDio.post('/api/auth/login', data: {'email': email, 'password': password});
    final auth = AuthResponse.fromJson(response.data as Map<String, dynamic>);
    await _applySession(auth);
    return auth.user;
  }

  /// Called once on cold start: if a refresh token survived from a previous session,
  /// silently exchange it for a fresh access token so the user doesn't have to log in
  /// again after being offline for days. Returns false (and clears any stale token) if
  /// that fails - both when genuinely offline (caller should still let the user in with
  /// cached data) and when the refresh token was rejected outright.
  Future<bool> tryResume() async {
    final refreshToken = await secureStorage.readRefreshToken();
    if (refreshToken == null) return false;
    final newAccessToken = await refreshAccessToken(refreshToken: refreshToken);
    return newAccessToken != null;
  }

  /// Exchanges the current refresh token for a new access token, deduplicating
  /// concurrent callers. Pass [refreshToken] explicitly only for the cold-start resume
  /// path (before anything is in secure storage's read cache); everyone else should omit
  /// it and let this read the current one itself.
  Future<String?> refreshAccessToken({String? refreshToken}) {
    return _inFlightRefresh ??= _doRefresh(refreshToken).whenComplete(() => _inFlightRefresh = null);
  }

  Future<String?> _doRefresh(String? refreshTokenOverride) async {
    final refreshToken = refreshTokenOverride ?? await secureStorage.readRefreshToken();
    if (refreshToken == null) return null;
    try {
      final response = await _rawDio.post('/api/auth/refresh', data: {'refreshToken': refreshToken});
      final auth = AuthResponse.fromJson(response.data as Map<String, dynamic>);
      await _applySession(auth);
      return auth.accessToken;
    } on DioException catch (e) {
      // Only clear the stored refresh token on an explicit rejection (401/403) - a
      // network failure while genuinely offline shouldn't log the user out, since the
      // token itself may still be perfectly valid once connectivity returns.
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        await secureStorage.clear();
        session.clear();
      }
      return null;
    }
  }

  Future<void> logout() async {
    final refreshToken = await secureStorage.readRefreshToken();
    if (refreshToken != null) {
      try {
        await _rawDio.post('/api/auth/logout', data: {'refreshToken': refreshToken});
      } catch (_) {
        // Best-effort: clear local session regardless of whether the server call succeeds.
      }
    }
    await secureStorage.clear();
    session.clear();
  }

  Future<void> _applySession(AuthResponse auth) async {
    await secureStorage.writeRefreshToken(auth.refreshToken);
    session.update(accessToken: auth.accessToken, user: auth.user);
  }
}
