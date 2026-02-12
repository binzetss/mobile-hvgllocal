import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/token_manager.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final TokenManager _tokenManager = TokenManager();

  /// Lấy headers với token (nếu có)
  Future<Map<String, String>> _getHeaders({bool includeToken = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeToken) {
      final token = await _tokenManager.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// POST request với tự động thêm Bearer token
  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(includeToken: requiresAuth);

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // Token hết hạn hoặc không hợp lệ
        await _tokenManager.clearToken();
        throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// GET request với tự động thêm Bearer token
  Future<Map<String, dynamic>> get(
    String url, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(includeToken: requiresAuth);

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // Token hết hạn hoặc không hợp lệ
        await _tokenManager.clearToken();
        throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// GET request trả về List với tự động thêm Bearer token
  Future<List<dynamic>> getList(
    String url, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(includeToken: requiresAuth);

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded;
        } else {
          throw Exception('Expected List but got ${decoded.runtimeType}');
        }
      } else if (response.statusCode == 401) {
        // Token hết hạn hoặc không hợp lệ
        await _tokenManager.clearToken();
        throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// PUT request với tự động thêm Bearer token
  Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(includeToken: requiresAuth);

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        await _tokenManager.clearToken();
        throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// DELETE request với tự động thêm Bearer token
  Future<Map<String, dynamic>> delete(
    String url, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(includeToken: requiresAuth);

      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        await _tokenManager.clearToken();
        throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
