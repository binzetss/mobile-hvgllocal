import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  static const String _tokenKey = 'auth_token';
  static const String _tokenExpiryKey = 'token_expiry';

  String? _cachedToken;

  Future<void> saveToken(String token, {DateTime? expiryDate}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    _cachedToken = token;

    if (expiryDate != null) {
      await prefs.setString(_tokenExpiryKey, expiryDate.toIso8601String());
    }
  }

  Future<String?> getToken() async {

    if (_cachedToken != null && _cachedToken!.isNotEmpty) {
      return _cachedToken;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token != null) {
      final expiryString = prefs.getString(_tokenExpiryKey);
      if (expiryString != null) {
        final expiry = DateTime.parse(expiryString);
        if (DateTime.now().isAfter(expiry)) {

          await clearToken();
          return null;
        }
      }
      _cachedToken = token;
    }

    return token;
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_tokenExpiryKey);
    _cachedToken = null;
  }

  void clearCache() {
    _cachedToken = null;
  }

  String? getCachedToken() {
    return _cachedToken;
  }
}
