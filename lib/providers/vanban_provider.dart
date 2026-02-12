import 'package:flutter/foundation.dart';
import '../data/models/vanban_model.dart';
import '../data/services/vanban_service.dart';
import '../data/services/thongbao_service.dart';

class VanbanProvider extends ChangeNotifier {
  final VanbanService _documentService = VanbanService();
  final ThongBaoService _thongBaoService = ThongBaoService();

  List<VanbanModel> _documents = [];
  List<VanbanModel> _filteredDocuments = [];
  String _selectedCategory = VanbanCategory.all;
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;
  bool _isDisposed = false;

  List<VanbanModel> get documents => _filteredDocuments;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isInitialized => _isInitialized;

  int get newDocumentsCount {
    return _documents.where((doc) => doc.isNew).length;
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  /// Kiểm tra văn bản có phải của hôm nay không
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);
    return today == compareDate;
  }

  /// TEMP: Kiểm tra văn bản trong vòng 10 ngày gần nhất (để test)
  bool _isRecent(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    return difference.inDays <= 10;
  }

  Future<void> init() async {
    if (_isInitialized && _documents.isNotEmpty) {
      return;
    }
    await fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      final newDocuments = await _documentService.getDocuments();

      // TEMP: Tạo thông báo cho văn bản trong 3 ngày gần nhất (để test)
      // TODO: Đổi lại thành _isToday(doc.publishedDate) sau khi test xong
      if (newDocuments.isNotEmpty) {
        // Lọc văn bản 3 ngày gần nhất
        final todayDocs = newDocuments.where((doc) => _isRecent(doc.publishedDate)).toList();

        // Sắp xếp từ CŨ đến MỚI trước khi tạo thông báo
        // Vì insert(0) sẽ đảo ngược thứ tự
        todayDocs.sort((a, b) => a.publishedDate.compareTo(b.publishedDate));

        // Tạo thông báo theo thứ tự
        for (final doc in todayDocs) {
          await _thongBaoService.createVanbanNotification(
            documentId: doc.fileId.toString(),
            documentName: doc.fileName,
            category: doc.categoryName,
            publishedDate: doc.publishedDate,
          );
        }
      }

      _documents = newDocuments;
      _applyFilters();
      _isInitialized = true;
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  void searchDocuments(String query) {
    _searchQuery = query;
    _applyFilters();
    _safeNotifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    _safeNotifyListeners();
  }

  void _applyFilters() {
    _filteredDocuments = _documents;

    if (_selectedCategory != VanbanCategory.all) {
      _filteredDocuments = _filteredDocuments
          .where((doc) => doc.category == _selectedCategory)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      _filteredDocuments = _filteredDocuments.where((doc) {
        return doc.fileName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            doc.categoryName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            doc.soKiHieu.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    _filteredDocuments.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
    _safeNotifyListeners();
  }

  void resetFilters() {
    _selectedCategory = VanbanCategory.all;
    _searchQuery = '';
    _applyFilters();
    _safeNotifyListeners();
  }

  Future<VanbanModel?> getDocumentById(int fileId) async {
    try {
      return await _documentService.getDocumentById(fileId);
    } catch (e) {
      _errorMessage = e.toString();
      _safeNotifyListeners();
      return null;
    }
  }

  Future<void> refresh() async {
    await fetchDocuments();
  }

  void clearCache() {
    _documents = [];
    _filteredDocuments = [];
    _selectedCategory = VanbanCategory.all;
    _searchQuery = '';
    _isLoading = false;
    _errorMessage = null;
    _isInitialized = false;
    _safeNotifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
