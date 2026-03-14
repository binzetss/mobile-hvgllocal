import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/firebase_notification_service.dart';
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

  static const _seenKey = 'hvgl_seen_vanban_ids';

  Future<Set<String>> _loadSeenIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_seenKey)?.toSet() ?? {};
  }

  Future<void> _saveSeenIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    // Giữ tối đa 500 ID gần nhất để tránh phình bộ nhớ
    final list = ids.toList();
    if (list.length > 500) list.removeRange(0, list.length - 500);
    await prefs.setStringList(_seenKey, list);
  }

  Future<void> fetchDocuments() async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      final newDocuments = await _documentService.getDocuments();

      if (newDocuments.isNotEmpty) {
        final recentDocs = newDocuments.where((doc) => _isRecent(doc.publishedDate)).toList();
        recentDocs.sort((a, b) => a.publishedDate.compareTo(b.publishedDate));

        // Tạo thông báo nội bộ
        for (final doc in recentDocs) {
          await _thongBaoService.createVanbanNotification(
            documentId: doc.fileId.toString(),
            documentName: doc.fileName,
            category: doc.categoryName,
            publishedDate: doc.publishedDate,
          );
        }

        // Gửi push notification cho văn bản chưa từng thông báo
        if (!kIsWeb && _isInitialized) {
          final seenIds = await _loadSeenIds();
          final unnotified = recentDocs
              .where((doc) => !seenIds.contains(doc.fileId.toString()))
              .toList();
          for (final doc in unnotified) {
            await FirebaseNotificationService().showDocumentNotification(
              documentName: doc.fileName,
              category: doc.categoryName,
            );
          }
          if (unnotified.isNotEmpty) {
            seenIds.addAll(unnotified.map((d) => d.fileId.toString()));
            await _saveSeenIds(seenIds);
          }
        } else if (!kIsWeb && !_isInitialized) {
          // Lần đầu load: đánh dấu tất cả là đã thấy, không thông báo
          final seenIds = await _loadSeenIds();
          seenIds.addAll(recentDocs.map((d) => d.fileId.toString()));
          await _saveSeenIds(seenIds);
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
