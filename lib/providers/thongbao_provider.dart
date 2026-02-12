import 'package:flutter/material.dart';
import '../data/models/thongbao_model.dart';
import '../data/services/thongbao_service.dart';
import '../data/models/vanban_model.dart';
import './vanban_provider.dart';

class ThongBaoProvider extends ChangeNotifier {
  final ThongBaoService _service = ThongBaoService();

  List<ThongBao> _notifications = [];
  bool _isLoading = false;
  String? _error;
  String _currentFilter = 'all';
  bool _isInitialized = false;
  bool _isDisposed = false;

  List<ThongBao> get notifications => _getFilteredList();
  List<ThongBao> get allNotifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentFilter => _currentFilter;
  bool get isInitialized => _isInitialized;

  int get unreadCount => _notifications.where((tb) => !tb.isRead && tb.isNew).length;

  /// Helper để gọi notifyListeners an toàn
  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  /// Khởi tạo - chỉ load nếu chưa có data
  Future<void> init() async {
    if (_isInitialized && _notifications.isNotEmpty) {
      return;
    }

    await loadNotifications();
  }

  List<ThongBao> _getFilteredList() {
    switch (_currentFilter) {
      case 'unread':
        return _notifications.where((tb) => !tb.isRead).toList();
      case 'chamcong':
      case 'luong':
      case 'vanban':
      case 'hethong':
      case 'sukien':
        return _notifications.where((tb) => tb.type == _currentFilter).toList();
      default:
        return _notifications;
    }
  }

  Future<void> loadNotifications() async {
    try {
      _isLoading = true;
      _error = null;
      _safeNotifyListeners();

      final list = await _service.getAll();
      _notifications = list;
      _isInitialized = true;
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    _safeNotifyListeners();
  }

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((tb) => tb.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _safeNotifyListeners();
      await _service.markAsRead(id);
    }
  }

  Future<void> markAllAsRead() async {
    _notifications = _notifications.map((tb) => tb.copyWith(isRead: true)).toList();
    _safeNotifyListeners();
    await _service.markAllAsRead();
  }

  Future<void> deleteNotification(String id) async {
    _notifications.removeWhere((tb) => tb.id == id);
    _safeNotifyListeners();
    await _service.delete(id);
  }

  void clearCache() {
    _notifications = [];
    _currentFilter = 'all';
    _isLoading = false;
    _error = null;
    _isInitialized = false;
    _safeNotifyListeners();
    _service.clearAll();
  }

  /// Navigate to document detail from notification
  Future<VanbanModel?> navigateToDocument(
    String notificationId,
    VanbanProvider vanbanProvider,
  ) async {
    // Find notification
    final notification = _notifications.firstWhere(
      (n) => n.id == notificationId,
      orElse: () => throw Exception('Notification not found'),
    );

    // Get documentId from extraData
    final documentId = notification.extraData?['documentId'] as String?;
    if (documentId == null) {
      throw Exception('Document ID not found in notification');
    }

    // Mark as read
    if (!notification.isRead) {
      await markAsRead(notificationId);
    }

    // Fetch document
    final document = await vanbanProvider.getDocumentById(int.parse(documentId));

    if (document == null) {
      throw Exception('Document not found');
    }

    return document;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
