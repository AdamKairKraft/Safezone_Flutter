import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Holds the refresh token (14-day TTL, deliberately long so this app can go offline for
/// days and still resync without forcing a re-login - see FLUTTER_BUILD_PROMPT.md). The
/// access token is short-lived and kept in memory only (AuthController), not persisted.
class SecureStorage {
  SecureStorage._(this._storage);

  static final SecureStorage instance = SecureStorage._(const FlutterSecureStorage());

  final FlutterSecureStorage _storage;

  static const _refreshTokenKey = 'safezone.refreshToken';

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> writeRefreshToken(String token) => _storage.write(key: _refreshTokenKey, value: token);

  Future<void> clear() => _storage.delete(key: _refreshTokenKey);
}
