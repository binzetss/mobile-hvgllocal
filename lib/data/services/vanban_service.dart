import '../models/vanban_model.dart';
import '../../core/constants/api_endpoints.dart';
import 'api_service.dart';

class VanbanService {
  final ApiService _apiService = ApiService();

  /// Lấy danh sách văn bản
  /// Nếu [fileName] rỗng hoặc null -> lấy tất cả văn bản
  /// Nếu [fileName] có giá trị -> tìm kiếm theo tên file
  /// Tự động gộp các văn bản có cùng fileName thành 1 văn bản với nhiều file
  Future<List<VanbanModel>> getDocuments({String? fileName}) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.vanBanNoiBo,
        {
          'fileName': fileName ?? '',
        },
      );

      final apiResponse = VanbanApiResponse.fromJson(response);

      if (apiResponse.success) {
        // Gộp các văn bản có cùng fileName
        final groupedDocs = _groupDocumentsByFileName(apiResponse.data);

        // Cập nhật danh sách categories từ API
        _updateCategoriesFromDocuments(groupedDocs);
        return groupedDocs;
      } else {
        throw Exception('Không thể tải danh sách văn bản');
      }
    } catch (e) {
      throw Exception('Không thể tải danh sách văn bản: $e');
    }
  }

  /// Lấy chi tiết văn bản theo fileId
  Future<VanbanModel?> getDocumentById(int fileId) async {
    try {
      final documents = await getDocuments();
      return documents.firstWhere(
        (doc) => doc.fileId == fileId,
        orElse: () => throw Exception('Không tìm thấy văn bản'),
      );
    } catch (e) {
      throw Exception('Không thể tải văn bản: $e');
    }
  }

  /// Tìm kiếm văn bản theo tên
  Future<List<VanbanModel>> searchDocuments(String query) async {
    try {
      if (query.isEmpty) {
        return await getDocuments();
      }
      return await getDocuments(fileName: query);
    } catch (e) {
      throw Exception('Không thể tìm kiếm văn bản: $e');
    }
  }

  /// Lấy văn bản theo danh mục
  Future<List<VanbanModel>> getDocumentsByCategory(String category) async {
    try {
      final allDocs = await getDocuments();
      if (category == VanbanCategory.all) {
        return allDocs;
      }
      return allDocs.where((doc) => doc.categoryName == category).toList();
    } catch (e) {
      throw Exception('Không thể lọc văn bản: $e');
    }
  }

  /// Gộp các văn bản có cùng fileName thành 1 văn bản với nhiều file
  List<VanbanModel> _groupDocumentsByFileName(List<VanbanModel> documents) {
    // Nhóm documents theo fileName
    final Map<String, List<VanbanModel>> grouped = {};

    for (var doc in documents) {
      if (!grouped.containsKey(doc.fileName)) {
        grouped[doc.fileName] = [];
      }
      grouped[doc.fileName]!.add(doc);
    }

    // Gộp các documents có cùng fileName
    final List<VanbanModel> result = [];

    for (var entry in grouped.entries) {
      final docs = entry.value;

      if (docs.length == 1) {
        // Chỉ có 1 document, không cần gộp
        result.add(docs.first);
      } else {
        // Nhiều documents có cùng fileName, gộp lại
        final first = docs.first;
        final additionalFiles = docs.skip(1).map((d) => d.filePath).toList();

        result.add(first.copyWith(additionalFiles: additionalFiles));
      }
    }

    return result;
  }

  /// Cập nhật danh sách categories từ documents
  void _updateCategoriesFromDocuments(List<VanbanModel> documents) {
    final categories = documents
        .map((doc) => doc.categoryName)
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();

    categories.sort();
    VanbanCategory.updateCategories(categories);
  }
}
