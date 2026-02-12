class VanbanModel {
  final int fileId;
  final String soKiHieu;
  final String fileName;
  final String filePath;
  final int categoryId;
  final String categoryName;
  final DateTime uploadedAt;
  final List<String>? additionalFiles;

  VanbanModel({
    required this.fileId,
    required this.soKiHieu,
    required this.fileName,
    required this.filePath,
    required this.categoryId,
    required this.categoryName,
    required this.uploadedAt,
    this.additionalFiles,
  });

  String get id => fileId.toString();
  String get title => fileName;
  String get category => categoryName;
  String get fileUrl => filePath;
  DateTime get publishedDate => uploadedAt;

  factory VanbanModel.fromJson(Map<String, dynamic> json) {
    List<String>? additionalFilesList;
    if (json['additionalFiles'] != null) {
      additionalFilesList = (json['additionalFiles'] as List)
          .map((e) => e.toString())
          .toList();
    } else if (json['files'] != null) {
      additionalFilesList = (json['files'] as List)
          .map((e) => e.toString())
          .toList();
    }

    return VanbanModel(
      fileId: json['fileId'] ?? 0,
      soKiHieu: json['soKiHieu']?.toString() ?? '',
      fileName: json['fileName']?.toString() ?? '',
      filePath: json['filePath']?.toString() ?? '',
      categoryId: json['categoryID'] ?? 0,
      categoryName: json['categoryName']?.toString() ?? '',
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.parse(json['uploadedAt'])
          : DateTime.now(),
      additionalFiles: additionalFilesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileId': fileId,
      'soKiHieu': soKiHieu,
      'fileName': fileName,
      'filePath': filePath,
      'categoryID': categoryId,
      'categoryName': categoryName,
      'uploadedAt': uploadedAt.toIso8601String(),
      if (additionalFiles != null) 'additionalFiles': additionalFiles,
    };
  }

  VanbanModel copyWith({
    int? fileId,
    String? soKiHieu,
    String? fileName,
    String? filePath,
    int? categoryId,
    String? categoryName,
    DateTime? uploadedAt,
    List<String>? additionalFiles,
  }) {
    return VanbanModel(
      fileId: fileId ?? this.fileId,
      soKiHieu: soKiHieu ?? this.soKiHieu,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      additionalFiles: additionalFiles ?? this.additionalFiles,
    );
  }

  List<String> get allFiles {
    if (additionalFiles == null || additionalFiles!.isEmpty) {
      return [filePath];
    }
    return [filePath, ...additionalFiles!];
  }

  bool get hasMultipleFiles {
    return additionalFiles != null && additionalFiles!.isNotEmpty;
  }
  bool get isNew {
    final now = DateTime.now();
    return uploadedAt.year == now.year &&
        uploadedAt.month == now.month &&
        uploadedAt.day == now.day;
  }
  String get fileExtension {
    final parts = filePath.split('.');
    return parts.isNotEmpty ? parts.last.toLowerCase() : '';
  }
  bool get isPdfFile {
    return fileExtension == 'pdf';
  }
  String get fullFilePath {
    try {
      if (filePath.contains('.com') || filePath.contains('.vn')) {
        String urlString = filePath;

        if (!filePath.startsWith('http://') && !filePath.startsWith('https://')) {
          urlString = 'https://$filePath';
        }

     
        final uri = Uri.parse(urlString);

  
        final pathSegments = uri.pathSegments;
        final encodedPath = pathSegments.map((s) => Uri.encodeComponent(s)).join('/');

    
        return Uri(
          scheme: uri.scheme,
          host: uri.host,
          path: encodedPath.isEmpty ? '/' : '/$encodedPath',
        ).toString();
      }

 
      final path = filePath.startsWith('/') ? filePath : '/$filePath';


      final pathSegments = path.split('/').where((s) => s.isNotEmpty).toList();
      final encodedPath = pathSegments.map((s) => Uri.encodeComponent(s)).join('/');

      return 'https://docs.bvhvgl.com/$encodedPath';
    } catch (e) {
      if (filePath.startsWith('http://') || filePath.startsWith('https://')) {
        return filePath;
      }
      return 'https://$filePath';
    }
  }
}

class VanbanCategory {
  static const String all = 'Tất cả';

  static List<String> allCategories = [all];
  static void updateCategories(List<String> categories) {
    allCategories = [all, ...categories];
  }
}

class VanbanApiResponse {
  final bool success;
  final List<VanbanModel> data;

  VanbanApiResponse({
    required this.success,
    required this.data,
  });

  factory VanbanApiResponse.fromJson(Map<String, dynamic> json) {
    return VanbanApiResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => VanbanModel.fromJson(item))
              .toList()
          : [],
    );
  }
}
