class ThongBao {
  final String id;
  final String title;
  final String content;
  final String type; // 'chamcong', 'luong', 'vanban', 'hethong', 'sukien'
  final DateTime time;
  final bool isRead;
  final String? avatar;
  final String? route;
  final Map<String, dynamic>? extraData;

  ThongBao({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.time,
    this.isRead = false,
    this.avatar,
    this.route,
    this.extraData,
  });

  ThongBao copyWith({
    String? id,
    String? title,
    String? content,
    String? type,
    DateTime? time,
    bool? isRead,
    String? avatar,
    String? route,
    Map<String, dynamic>? extraData,
  }) {
    return ThongBao(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      avatar: avatar ?? this.avatar,
      route: route ?? this.route,
      extraData: extraData ?? this.extraData,
    );
  }

  factory ThongBao.fromJson(Map<String, dynamic> json) {
    return ThongBao(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      time: DateTime.parse(json['time'] as String),
      isRead: json['isRead'] as bool? ?? false,
      avatar: json['avatar'] as String?,
      route: json['route'] as String?,
      extraData: json['extraData'] as Map<String, dynamic>?,
    );
  }

  bool get isNew {
    final now = DateTime.now();
    return time.year == now.year &&
        time.month == now.month &&
        time.day == now.day;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type,
      'time': time.toIso8601String(),
      'isRead': isRead,
      'avatar': avatar,
      'route': route,
      'extraData': extraData,
    };
  }
}
