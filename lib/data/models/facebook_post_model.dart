class FacebookPostModel {
  final String id;
  final String message;
  final String? fullPicture;
  final List<String> images; // Multiple images for slider
  final String? pageAvatar; // Avatar of the Facebook page
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
