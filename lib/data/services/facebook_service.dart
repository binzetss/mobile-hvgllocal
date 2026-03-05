import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/facebook_post_model.dart';

class FacebookService {
  static const String _userToken =
      'EAANRy989OMcBQyETZB9RhZC3wUL0WZBh3T6LkmqZA8yBhOEwkpeIw5iKkZCj760svM5gZCeTqXeUCOU4F2tFpmujnwHu8QQKk6BUMdLDYzVh3F0GrmOqnjcmzcIRHZAtpBAEMcAIVqhOKXXijhpZCSNsf3Uimh5vPvZATZBo5TtvZBNgYFXVQBtFNSQfrRokcUEkUGNm5KIbLLv87BLRlddSM9rZAKSmKqbZB2sw3OIYQuPFT5YtOZAQdHzzQs3fIRfFWSvNW9W9Ye7iTkdtye4NzQHXYZC';

  static const String _pageUsername = 'bvhvgl';
  static const String _graphBase = 'https://graph.facebook.com/v19.0';
  static const String _pageTokenKey = 'fb_page_token';
  static const String _pageIdKey = 'fb_page_id';


  Future<Map<String, String>?> _getCachedPageInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_pageTokenKey);
    final id = prefs.getString(_pageIdKey);
    if (token != null && id != null) return {'token': token, 'id': id};
    return null;
  }


  Future<Map<String, String>?> _fetchPageTokenFromApi() async {
    try {
      final response = await http.get(
        Uri.parse('$_graphBase/me/accounts?access_token=$_userToken'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accounts = data['data'] as List?;
        if (accounts != null && accounts.isNotEmpty) {
          Map<String, dynamic>? found;
          for (final acc in accounts) {
            final name = acc['name']?.toString().toLowerCase() ?? '';
            if (name.contains('hùng vương') || name.contains('hung vuong') ||
                name.contains('hvgl') || name.contains('bvhvgl')) {
              found = acc;
              break;
            }
          }
          found ??= accounts.first as Map<String, dynamic>;
          final token = found['access_token']?.toString() ?? '';
          final id = found['id']?.toString() ?? '';
          if (token.isNotEmpty && id.isNotEmpty) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(_pageTokenKey, token);
            await prefs.setString(_pageIdKey, id);
            return {'token': token, 'id': id};
          }
        }
      }
    } catch (_) {}
    return null;
  }

  Future<List<FacebookPostModel>> _callPostsApi(String pageId, String token, int limit) async {
    final fields = [
      'id',
      'message',
      'full_picture',
      'attachments{media,subattachments{media}}',
      'created_time',
      'permalink_url',
      'likes.summary(true)',
      'comments.summary(true)',
      'shares',
    ].join(',');

    final url = Uri.parse(
      '$_graphBase/$pageId/posts'
      '?fields=$fields'
      '&limit=${limit * 2}'
      '&access_token=$token',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List? ?? [])
          .map((p) => FacebookPostModel.fromFbJson(p as Map<String, dynamic>, pageId: pageId))
          .where((p) => p.message.trim().isNotEmpty)
          .take(limit)
          .toList();
    } else {
      throw Exception('HTTP ${response.statusCode}');
    }
  }

  Future<void> _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pageTokenKey);
    await prefs.remove(_pageIdKey);
  }

  Future<List<FacebookPostModel>> getPosts({int limit = 3}) async {
    // Bước 1: thử với page token đã cache
    final cached = await _getCachedPageInfo();
    if (cached != null) {
      try {
        return await _callPostsApi(cached['id']!, cached['token']!, limit);
      } catch (_) {
        await _clearCache(); // cache hỏng → xóa, tiếp tục
      }
    }

    // Bước 2: lấy page token mới từ user token
    final newPageInfo = await _fetchPageTokenFromApi();
    if (newPageInfo != null) {
      try {
        return await _callPostsApi(newPageInfo['id']!, newPageInfo['token']!, limit);
      } catch (_) {
        await _clearCache();
      }
    }

    // Bước 3: thử trực tiếp với user token + page username
    try {
      return await _callPostsApi(_pageUsername, _userToken, limit);
    } catch (e) {
      throw Exception('Token hết hạn. Vui lòng cấp token mới trong Meta Developer.');
    }
  }

  Future<FacebookPostModel?> getLatestPost() async {
    final posts = await getPosts(limit: 1);
    return posts.isNotEmpty ? posts.first : null;
  }
}
