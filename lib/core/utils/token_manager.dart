import 'package:shared_preferences/shared_preferences.dart';

/// Quản lý token cho toàn bộ ứng dụng
class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  static const String _tokenKey = 'auth_token';
  static const String _tokenExpiryKey = 'token_expiry';

  String? _cachedToken;

  /// Lưu token
  Future<void> saveToken(String token, {DateTime? expiryDate}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    _cachedToken = token;

    if (expiryDate != null) {
      await prefs.setString(_tokenExpiryKey, expiryDate.toIso8601String());
    }
  }

  /// Lấy token
  Future<String?> getToken() async {
    // Return cached token if available
    if (_cachedToken != null && _cachedToken!.isNotEmpty) {
      return _cachedToken;
    }

    // Get from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    // Check if token is expired
    if (token != null) {
      final expiryString = prefs.getString(_tokenExpiryKey);
      if (expiryString != null) {
        final expiry = DateTime.parse(expiryString);
        if (DateTime.now().isAfter(expiry)) {
          // Token expired, clear it
          await clearToken();
          return null;
        }
      }
      _cachedToken = token;
    }

    return token;
  }

  /// Kiểm tra có token không
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Xóa token
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_tokenExpiryKey);
    _cachedToken = null;
  }

  /// Clear cache (dùng khi cần force refresh từ SharedPreferences)
  void clearCache() {
    _cachedToken = null;
  }

  /// Lấy token đồng bộ từ cache (nhanh hơn nhưng có thể null nếu chưa load)
  String? getCachedToken() {
    return _cachedToken;
  }
}
