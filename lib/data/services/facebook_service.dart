import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/facebook_post_model.dart';

class FacebookService {
  // User Access Token (dùng lần đầu để lấy Page Access Token)
  static const String _userToken =
      'EAAMJDCWLkaQBQ8d6BV69y0c051hb57fdZCyEFnxYCBBV54hxWDfZBAZA2pfHSQjKfEElcAXexZC7ZBWrgZA0EvltvO6a7esrmOBa1b3BDUK8ZAGpZCcisQnGQOJ7ZBus4vZCDmxucBIkdycNrI2RS7AgYwpwADXwVmNJTvPKISD8ZBXILqtkMXrzZADvfZCZCDoHxXetclT8kc29eNZAHotYF4stSHyHO6FsnVN7OIfB0eXVBn38ErtdEmVWmeFZC1v5VdbRy5oUG1dcSZBovlXGZCZB64ZA5IgDFZBVEFwZDZD';

  static const String _pageUsername = 'bvhvgl';
  static const String _graphBase = 'https://graph.facebook.com/v19.0';
  static const String _pageTokenKey = 'fb_page_token';
  static const String _pageIdKey = 'fb_page_id';

  // Lấy Page Access Token đã lưu
  Future<Map<String, String>?> _getCachedPageInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_pageTokenKey);
    final id = prefs.getString(_pageIdKey);
    if (token != null && id != null) return {'token': token, 'id': id};
    return null;
  }

  // Gọi /me/accounts để lấy Page Access Token từ User Token
  Future<Map<String, String>?> _fetchPageTokenFromApi() async {
    try {
      final response = await http.get(
        Uri.parse('$_graphBase/me/accounts?access_token=$_userToken'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accounts = data['data'] as List?;
        if (accounts != null && accounts.isNotEmpty) {
          // Tìm page bvhvgl hoặc lấy page đầu tiên
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

  Future<List<FacebookPostModel>> getPosts({int limit = 3}) async {
    try {
      // Lấy page token (cached hoặc fetch mới)
      var pageInfo = await _getCachedPageInfo();
      pageInfo ??= await _fetchPageTokenFromApi();

      final token = pageInfo?['token'] ?? _userToken;
      final pageId = pageInfo?['id'] ?? _pageUsername;

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
        '&limit=${limit * 2}' // lấy nhiều hơn để lọc bài không có message
        '&access_token=$token',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final posts = (data['data'] as List? ?? [])
            .map((p) => FacebookPostModel.fromFbJson(
                  p as Map<String, dynamic>,
                  pageId: pageId,
                ))
            .where((p) => p.message.trim().isNotEmpty)
            .take(limit)
            .toList();
        return posts;
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        // Token hết hạn → xóa cache, thử lại với user token
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_pageTokenKey);
        await prefs.remove(_pageIdKey);
        throw Exception('Token hết hạn. Vui lòng liên hệ admin cập nhật token.');
      } else {
        throw Exception('Facebook API lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không thể tải bài viết Facebook: $e');
    }
  }

  Future<FacebookPostModel?> getLatestPost() async {
    final posts = await getPosts(limit: 1);
    return posts.isNotEmpty ? posts.first : null;
  }
}
