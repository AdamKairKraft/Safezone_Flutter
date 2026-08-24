import 'package:flutter/foundation.dart';

import '../models/user.dart';

/// In-memory holder for the current access token + user. Deliberately not persisted:
/// only the refresh token survives an app restart (SecureStorage) - on cold start the
/// app silently exchanges it for a fresh access token (see AuthRepository.tryResume).
class AuthSession extends ChangeNotifier {
  String? _accessToken;
  AppUser? _user;

  String? get accessToken => _accessToken;
  AppUser? get user => _user;
  bool get isAuthenticated => _accessToken != null && _user != null;

  void update({required String accessToken, required AppUser user}) {
    _accessToken = accessToken;
    _user = user;
    notifyListeners();
  }

  void clear() {
    _accessToken = null;
    _user = null;
    notifyListeners();
  }
}
