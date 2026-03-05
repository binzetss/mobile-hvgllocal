import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/facebook_post_model.dart';

class FacebookService {
  // Page Access Token vĩnh viễn - không bao giờ hết hạn
  static const String _pageToken =
      'EAANRy989OMcBQZBcyhSrttZCx6hpJlQVhcs9UHBnqdDUsz0HIp7E4AcnimvX2XGaFjFDGZAmEJvE8KxOnTdXJ8v4pxZBZBUDE1ZAYJ9kBY0VbZBD7OaBkkZALVyzkCTZB64JPNQ709VbkeKv3qB4CqT0ZBsWp8RZCSadlQAnW0YOdRTsvi4XwuB25scp9t7qcSgEu7ZCCDEiZCJMZD';

  static const String _pageId = '157566379728871';
  static const String _graphBase = 'https://graph.facebook.com/v19.0';

  Future<List<FacebookPostModel>> getPosts({int limit = 3}) async {
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
      '$_graphBase/$_pageId/posts'
      '?fields=$fields'
      '&limit=${limit * 2}'
      '&access_token=$_pageToken',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List? ?? [])
          .map((p) => FacebookPostModel.fromFbJson(p as Map<String, dynamic>, pageId: _pageId))
          .where((p) => p.message.trim().isNotEmpty)
          .take(limit)
          .toList();
    } else {
      final body = jsonDecode(response.body);
      final msg = body['error']?['message']?.toString() ?? 'HTTP ${response.statusCode}';
      throw Exception(msg);
    }
  }

  Future<FacebookPostModel?> getLatestPost() async {
    final posts = await getPosts(limit: 1);
    return posts.isNotEmpty ? posts.first : null;
  }
}
