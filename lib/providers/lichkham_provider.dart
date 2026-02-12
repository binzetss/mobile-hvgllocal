import 'package:flutter/material.dart';
import '../data/models/lichkham_model.dart';
import '../data/services/lichkham_service.dart';

class LichkhamProvider extends ChangeNotifier {
  final LichkhamService _lichkhamService = LichkhamService();

  List<LichkhamModel> _allSchedules = [];
  List<LichkhamModel> _filteredSchedules = [];
  List<String> _rooms = [];
  String _selectedRoom = 'all';
  int _selectedDateRange = 1;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false; // Đánh dấu đã load data chưa
  bool _isDisposed = false;

  LichkhamProvider() {
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = DateTime(now.year, now.month, now.day);
  }

  List<LichkhamModel> get allSchedules => _allSchedules;
  List<LichkhamModel> get filteredSchedules => _filteredSchedules;
  List<String> get rooms => _rooms;
  String get selectedRoom => _selectedRoom;
  int get selectedDateRange => _selectedDateRange;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  /// Helper để gọi notifyListeners an toàn
  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  /// Khởi tạo - chỉ load nếu chưa có data
  Future<void> init() async {
    if (_isInitialized && _allSchedules.isNotEmpty) {
      // Đã có data rồi, không cần load lại
      return;
    }
    await loadSchedules();
  }

  Future<void> loadSchedules() async {
    try {
      _isLoading = true;
      _error = null;
      _safeNotifyListeners();

      final schedules = await _lichkhamService.fetchSchedules();
      final roomNames = await _lichkhamService.getRoomNames();

      _allSchedules = schedules;
      _rooms = roomNames;
      _applyFilters();

      _isInitialized = true; // Đánh dấu đã load thành công
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  void _applyFilters() {
    var filtered = _allSchedules;

    if (_selectedRoom != 'all') {
      filtered = filtered
          .where((s) => s.tenPhongKham == _selectedRoom)
          .toList();
    }

    filtered = filtered
        .where((s) => s.isBetweenDates(_startDate, _endDate))
        .toList();

    _filteredSchedules = filtered;
  }

  void selectRoom(String room) {
    _selectedRoom = room;
    _applyFilters();
    _safeNotifyListeners();
  }

  void updateDateRange(int days) {
    _selectedDateRange = days;

    if (days == 1) {
      final now = DateTime.now();
      _startDate = DateTime(now.year, now.month, now.day);
      _endDate = DateTime(now.year, now.month, now.day);
    } else if (days == 7) {
      final now = DateTime.now();
      _startDate = DateTime(now.year, now.month, now.day);
      _endDate = _startDate.add(const Duration(days: 6));
    }

    _applyFilters();
    _safeNotifyListeners();
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    _selectedDateRange = 0;
    _startDate = start;
    _endDate = end;
    _applyFilters();
    _safeNotifyListeners();
  }

  void setStartDate(DateTime date) {
    _startDate = date;
    if (_endDate.isBefore(_startDate)) {
      _endDate = _startDate;
    }
    _applyFilters();
    _safeNotifyListeners();
  }

  void setEndDate(DateTime date) {
    _endDate = date;
    _applyFilters();
    _safeNotifyListeners();
  }

  Map<String, List<LichkhamModel>> getGroupedSchedules() {
    return _lichkhamService.groupSchedulesByRoom(_filteredSchedules);
  }

  Future<void> refresh() async {
    await loadSchedules();
  }

  void clearFilters() {
    _selectedRoom = 'all';
    _selectedDateRange = 7;
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = _startDate.add(const Duration(days: 6));
    _applyFilters();
    _safeNotifyListeners();
  }

  Map<String, int> getScheduleCountByRoom() {
    final Map<String, int> counts = {};
    for (var schedule in _filteredSchedules) {
      counts[schedule.tenPhongKham] = (counts[schedule.tenPhongKham] ?? 0) + 1;
    }
    return counts;
  }

  /// Xóa cache (dùng khi logout)
  void clearCache() {
    _allSchedules = [];
    _filteredSchedules = [];
    _rooms = [];
    _selectedRoom = 'all';
    _selectedDateRange = 1;
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = DateTime(now.year, now.month, now.day);
    _isLoading = false;
    _error = null;
    _isInitialized = false;
    _safeNotifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
