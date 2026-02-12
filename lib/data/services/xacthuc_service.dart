import 'dart:convert';
import 'package:hvgl/core/utils/local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/utils/token_manager.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class XacthucService {
  static final XacthucService _instance = XacthucService._internal();
  factory XacthucService() => _instance;
  XacthucService._internal();

  final ApiService _apiService = ApiService();
  final TokenManager _tokenManager = TokenManager();

  static const String _userKey = 'user_data';
  static const String _credentialsKey = 'saved_credentials';
  static const String _rememberMeKey = 'remember_me';

  /// Lưu credentials (mã số và mật khẩu)
  Future<void> saveCredentials(String maSo, String matKhau) async {
    final prefs = await SharedPreferences.getInstance();
    final credentials = jsonEncode({
      'maSo': maSo,
      'matKhau': matKhau,
    });
    await prefs.setString(_credentialsKey, credentials);
  }

  /// Lấy credentials đã lưu
  Future<Map<String, String>?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final credentialsJson = prefs.getString(_credentialsKey);

    if (credentialsJson != null) {
      final decoded = jsonDecode(credentialsJson) as Map<String, dynamic>;
      return {
        'maSo': decoded['maSo']?.toString() ?? '',
        'matKhau': decoded['matKhau']?.toString() ?? '',
      };
    }
    return null;
  }

  /// Xóa credentials đã lưu
  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_credentialsKey);
  }

  /// Lưu trạng thái remember me
  Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
  }

  /// Kiểm tra trạng thái remember me
  Future<bool> isRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  /// Lưu thông tin user
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  /// Lấy thông tin user đã lưu
  Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<Map> login(String maSo, String matKhau) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.login,
        {
          'maSo': maSo,
          'matKhau': matKhau,
        },
        requiresAuth: false,
      );

      final Map<String, dynamic> userInfo = response["userInfo"];
      final user = UserModel.fromJson(userInfo);
      final token = response["token"];

      
      if (token != null && token.isNotEmpty) {
        await _tokenManager.saveToken(token);
      }

      return {
        "token": token,
        "user": user,
      };
    } catch (e) {
      rethrow;
    }
  }

 
  Future<void> logout() async {
    await _tokenManager.clearToken();
    await Local.cleanLocalAll();
  }


  Future<bool> isLoggedIn() async {
    return await _tokenManager.hasToken();
  }
}
