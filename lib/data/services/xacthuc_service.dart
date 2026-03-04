import 'dart:convert';
import 'dart:io';
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
  static const String _firstLoginPrefix = 'first_login_done_';

  Future<void> saveCredentials(String maSo, String matKhau) async {
    final prefs = await SharedPreferences.getInstance();
    final credentials = jsonEncode({
      'maSo': maSo,
      'matKhau': matKhau,
    });
    await prefs.setString(_credentialsKey, credentials);
  }

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

  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_credentialsKey);
  }

  Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
  }

  Future<bool> isRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

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

  Future<String?> fetchHoVaTen(String maSo) async {
    if (maSo.isEmpty) return null;
    try {
      final response = await _apiService.post(
        ApiEndpoints.danhSachNhanVien,
        {'maSo': maSo},
      );
      final data = response['data'] as List?;
      if (data != null && data.isNotEmpty) {
        return data.first['hoVaTen']?.toString();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> checkDoiMatKhau(String maSo) async {
    if (maSo.isEmpty) return false;
    try {
      final response = await _apiService.post(
        ApiEndpoints.danhSachNhanVien,
        {'maSo': maSo},
      );
      final data = response['data'] as List?;
      if (data != null && data.isNotEmpty) {
        return data.first['doiMatKhau'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isFirstLogin(String maSo) async {
    if (maSo.isEmpty) return false;
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool('$_firstLoginPrefix$maSo') ?? false;
    return !done;
  }

  Future<void> markFirstLoginDone(String maSo) async {
    if (maSo.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_firstLoginPrefix$maSo', true);
  }

  Future<String> doiMatKhau({
    required String maSo,
    required String matKhauCu,
    required String matKhauMoi,
    required String xacNhanMatKhauMoi,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.doiMatKhau,
        {
          'maSo': maSo,
          'matKhauCu': matKhauCu,
          'matKhauMoi': matKhauMoi,
          'xacNhanMatKhauMoi': xacNhanMatKhauMoi,
        },
      );

      if (response['success'] == true) {
        return response['message']?.toString() ?? 'Đổi mật khẩu thành công';
      } else {
        throw Exception(response['message']?.toString() ?? 'Đổi mật khẩu thất bại');
      }
    } catch (e) {
      rethrow;
    }
  }

  String buildAvatarUrl(String maSo) => '${ApiEndpoints.anhDaiDien}/$maSo';

  Future<String> _detectImageExt(File file) async {
    final bytes = await file.openRead(0, 12).fold<List<int>>(
      [],
      (acc, chunk) => acc..addAll(chunk),
    );
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return 'jpg';
    }
    if (bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'png';
    }
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return 'webp';
    }
    return 'jpg';
  }

  Future<String?> uploadAnhDaiDien({
    required String maSo,
    required File file,
  }) async {
    final sizeInBytes = await file.length();
    if (sizeInBytes > 5 * 1024 * 1024) {
      throw Exception('Ảnh vượt quá 5MB. Vui lòng chọn ảnh nhỏ hơn.');
    }

    final ext = await _detectImageExt(file);
    final mimeMap = {'jpg': 'image/jpeg', 'png': 'image/png', 'webp': 'image/webp'};

    final response = await _apiService.postMultipart(
      ApiEndpoints.anhDaiDien,
      {'maSo': maSo},
      file,
      'anhDaiDien',
      filename: 'photo.$ext',
      mimeType: mimeMap[ext] ?? 'image/jpeg',
    );

    if (response['success'] != true) {
      throw Exception(response['message']?.toString() ?? 'Cập nhật ảnh thất bại');
    }

    return response['anhDaiDienUrl']?.toString();
  }
}
