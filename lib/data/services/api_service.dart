import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../core/utils/token_manager.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final TokenManager _tokenManager = TokenManager();

  Map<String, dynamic> _decode(String body) {
    if (body.trim().isEmpty) return {'success': true};
    return jsonDecode(body) as Map<String, dynamic>;
  }

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
        return _decode(response.body);
      } else if (response.statusCode == 401) {
        await _tokenManager.clearToken();
        throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
      } else {

        try {
          final body = jsonDecode(response.body);
          final msg = body['message']?.toString();
          if (msg != null && msg.isNotEmpty) throw Exception(msg);
        } catch (jsonErr) {
          if (jsonErr is Exception) rethrow;
        }
        throw Exception('Lỗi máy chủ (${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi kết nối: $e');
    }
  }

  Future<Map<String, dynamic>> fetchData(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    if (kIsWeb) {
      return post(url, body, requiresAuth: requiresAuth);
    }
    return getWithBody(url, body, requiresAuth: requiresAuth);
  }

  Future<Map<String, dynamic>> getWithBody(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(includeToken: requiresAuth);

      final request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      request.body = jsonEncode(body);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return _decode(response.body);
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
        return _decode(response.body);
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
        await _tokenManager.clearToken();
        throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
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
        return _decode(response.body);
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
        return _decode(response.body);
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
  Future<Map<String, dynamic>> deleteWithBody(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(includeToken: requiresAuth);

      final request = http.Request('DELETE', Uri.parse(url));
      request.headers.addAll(headers);
      request.body = jsonEncode(body);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return _decode(response.body);
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
  Future<Map<String, dynamic>> postMultipart(
    String url,
    Map<String, String> fields,
    File file,
    String fileFieldName, {
    String? filename,
    String? mimeType,
  }) async {
    try {
      final token = await _tokenManager.getToken();
      final request = http.MultipartRequest('POST', Uri.parse(url));

      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields.addAll(fields);
      request.files.add(
        await http.MultipartFile.fromPath(
          fileFieldName,
          file.path,
          filename: filename,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // ignore: avoid_print
      print('[UPLOAD] status=${response.statusCode} body=${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return {'success': true};
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        await _tokenManager.clearToken();
        throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
      } else {
        try {
          final body = jsonDecode(response.body);
          final msg = body['message']?.toString();
          if (msg != null && msg.isNotEmpty) throw Exception(msg);
        } catch (jsonErr) {
          if (jsonErr is Exception) rethrow;
        }
        throw Exception('Lỗi máy chủ (${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
