import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/facebook_post_model.dart';

class FacebookService {
  // Page Access Token - dùng trực tiếp, không cần cache
  static const String _pageToken =
      'EAANRy989OMcBQ4X2VITZAfZCPZB0neKnVZBGtQvQlyCFZB0owAeT1fdCm5qbrx9kS2L7UZAz4Y07TFkXZCq566HNH9cutNZA8ASZBy6TIKZB3fZAM7h6bne1wZBl7eGRlVE2NyJZBa5HxCSWS2sQfe8aKdLKZC2P7cfUk1bdNqKRtpuVd53FzviYXUJNAFxFhg4ics87TQm4b1VnDJTXTEyRFlsTUlZClFoE3rnRJL8r7ZBTLZBfXTsuDFZCEAP3xalQ5SHZAJnSb1cUYHZCgD6ODHIO1d1GNvkXEgZDZD';

  static const String _pageId = 'bvhvgl';
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
