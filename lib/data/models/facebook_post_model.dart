class FacebookPostModel {
  final String id;
  final String message;
  final String? fullPicture;
  final List<String> images;
  final String? pageAvatar;
  final DateTime createdTime;
  final String? link;
  final int? likesCount;
  final int? commentsCount;
  final int? sharesCount;
  final String? permalink;

  FacebookPostModel({
    required this.id,
    required this.message,
    this.fullPicture,
    this.images = const [],
    this.pageAvatar,
    required this.createdTime,
    this.link,
    this.likesCount,
    this.commentsCount,
    this.sharesCount,
    this.permalink,
  });

  factory FacebookPostModel.fromJson(Map<String, dynamic> json) {
    return FacebookPostModel(
      id: json['id']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      fullPicture: json['full_picture']?.toString(),
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [],
      pageAvatar: json['page_avatar']?.toString(),
      createdTime: json['created_time'] != null
          ? DateTime.parse(json['created_time'])
          : DateTime.now(),
      link: json['link']?.toString(),
      likesCount: json['likes']?['summary']?['total_count'] ??
                  json['likes_count'] ?? 0,
      commentsCount: json['comments']?['summary']?['total_count'] ??
                     json['comments_count'] ?? 0,
      sharesCount: json['shares']?['count'] ?? json['shares_count'] ?? 0,
      permalink: json['permalink_url']?.toString() ?? json['permalink']?.toString(),
    );
  }

  factory FacebookPostModel.fromFbJson(Map<String, dynamic> json, {String? pageId}) {
    // Extract images from attachments
    final List<String> images = [];
    final attachments = json['attachments']?['data'] as List?;
    if (attachments != null && attachments.isNotEmpty) {
      final first = attachments.first as Map<String, dynamic>;
      final subattachments = first['subattachments']?['data'] as List?;
      if (subattachments != null && subattachments.isNotEmpty) {
        // Multiple images
        for (final sub in subattachments) {
          final src = sub['media']?['image']?['src']?.toString();
          if (src != null) images.add(src);
        }
      } else {
        // Single image
        final src = first['media']?['image']?['src']?.toString();
        if (src != null) images.add(src);
      }
    }

    final fullPicture = json['full_picture']?.toString();
    if (images.isEmpty && fullPicture != null) images.add(fullPicture);

    final pid = pageId ?? '';
    final avatarUrl = pid.isNotEmpty
        ? 'https://graph.facebook.com/$pid/picture?type=large'
        : null;

    return FacebookPostModel(
      id: json['id']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      fullPicture: fullPicture,
      images: images,
      pageAvatar: avatarUrl,
      createdTime: json['created_time'] != null
          ? DateTime.parse(json['created_time'].toString())
          : DateTime.now(),
      link: json['permalink_url']?.toString(),
      likesCount: json['likes']?['summary']?['total_count'] ?? 0,
      commentsCount: json['comments']?['summary']?['total_count'] ?? 0,
      sharesCount: json['shares']?['count'] ?? 0,
      permalink: json['permalink_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'full_picture': fullPicture,
      'images': images,
      'page_avatar': pageAvatar,
      'created_time': createdTime.toIso8601String(),
      'link': link,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'permalink': permalink,
    };
  }

  String get shortMessage {
    if (message.length <= 150) return message;
    return '${message.substring(0, 150)}...';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdTime);

    if (difference.inDays > 7) {
      return '${createdTime.day}/${createdTime.month}/${createdTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
