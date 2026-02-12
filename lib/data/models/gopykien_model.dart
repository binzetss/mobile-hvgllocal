class GopyKienModel {
  final String name;
  final String category;
  final String content;
  final DateTime createdAt;

  GopyKienModel({
    required this.name,
    required this.category,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory GopyKienModel.fromJson(Map<String, dynamic> json) {
    return GopyKienModel(
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  GopyKienModel copyWith({
    String? name,
    String? email,
    String? category,
    String? content,
    DateTime? createdAt,
  }) {
    return GopyKienModel(
      name: name ?? this.name,
      category: category ?? this.category,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
