import 'package:flutter/material.dart';
import '../data/models/lichtruc_model.dart';
import '../data/services/lichtruc_service.dart';

class LichtructProvider extends ChangeNotifier {
  final LichtructService _service = LichtructService();

  // ─── My Schedule (month-based) ────────────────────────────────────────────
  DateTime _currentMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  List<ChamTrucModel> _mySchedules = [];
  bool _isLoadingMy = false;
  String? _errorMy;

  // ─── All Schedule (day-based) ─────────────────────────────────────────────
  DateTime _selectedDate = DateTime.now();
  List<ChamTrucModel> _allSchedules = [];
  bool _isLoadingAll = false;
  String? _errorAll;
  String _searchKhoa = '';

  // ─── Getters ──────────────────────────────────────────────────────────────
  DateTime get currentMonth => _currentMonth;
  DateTime get selectedDate => _selectedDate;
  bool get isLoadingMy => _isLoadingMy;
  bool get isLoadingAll => _isLoadingAll;
  String? get errorMy => _errorMy;
  String? get errorAll => _errorAll;
  String get searchKhoa => _searchKhoa;

  bool get isSelectedDateToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  // ─── My Schedule helpers ──────────────────────────────────────────────────
  List<ChamTrucModel> getMyMonthSchedules() {
    return _mySchedules
        .where((s) =>
            s.ngay.year == _currentMonth.year &&
            s.ngay.month == _currentMonth.month)
        .toList()
      ..sort((a, b) => a.ngay.compareTo(b.ngay));
  }

  String getMonthYearText() {
    const months = [
      'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4',
      'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8',
      'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12',
    ];
    return '${months[_currentMonth.month - 1]}, ${_currentMonth.year}';
  }

  // ─── All Schedule helpers ─────────────────────────────────────────────────
  String getSelectedDateText() {
    const weekDays = [
      '', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'
    ];
    final d = _selectedDate;
    return '${weekDays[d.weekday]}, '
        '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  /// Lấy dữ liệu ngày đang chọn, lọc theo khoa, nhóm theo khoa phòng
  Map<String, List<ChamTrucModel>> getGroupedByDeptForDay() {
    final forDay = _allSchedules.where((s) =>
        s.ngay.year == _selectedDate.year &&
        s.ngay.month == _selectedDate.month &&
        s.ngay.day == _selectedDate.day).toList();

    final filtered = _searchKhoa.isEmpty
        ? forDay
        : forDay
            .where((s) =>
                s.tenKhoaPhong.toLowerCase().contains(_searchKhoa.toLowerCase()))
            .toList();

    final map = <String, List<ChamTrucModel>>{};
    for (final s in filtered) {
      final key =
          s.tenKhoaPhong.isNotEmpty ? s.tenKhoaPhong : 'Không xác định';
      map.putIfAbsent(key, () => []).add(s);
    }
    return Map.fromEntries(
        map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }

  // ─── Actions ──────────────────────────────────────────────────────────────
  Future<void> init() async {
    await Future.wait([fetchMySchedule(), fetchAllSchedule()]);
  }

  Future<void> fetchMySchedule() async {
    _isLoadingMy = true;
    _errorMy = null;
    notifyListeners();
    try {
      _mySchedules = await _service.getMySchedule(
          _currentMonth.year, _currentMonth.month);
    } catch (e) {
      _errorMy = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingMy = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllSchedule() async {
    _isLoadingAll = true;
    _errorAll = null;
    notifyListeners();
    try {
      _allSchedules = await _service.getAllSchedule(
          _selectedDate.year, _selectedDate.month);
    } catch (e) {
      _errorAll = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingAll = false;
      notifyListeners();
    }
  }

  // My schedule navigation
  void previousMonth() {
    _currentMonth =
        DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    fetchMySchedule();
  }

  void nextMonth() {
    _currentMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    fetchMySchedule();
  }

  // All schedule navigation (day-based)
  void previousDay() {
    final prev = _selectedDate.subtract(const Duration(days: 1));
    final needsRefetch = prev.year != _selectedDate.year ||
        prev.month != _selectedDate.month;
    _selectedDate = prev;
    if (needsRefetch) {
      fetchAllSchedule();
    } else {
      notifyListeners();
    }
  }

  void nextDay() {
    final next = _selectedDate.add(const Duration(days: 1));
    final needsRefetch = next.year != _selectedDate.year ||
        next.month != _selectedDate.month;
    _selectedDate = next;
    if (needsRefetch) {
      fetchAllSchedule();
    } else {
      notifyListeners();
    }
  }

  void goToToday() {
    final today = DateTime.now();
    final needsRefetch = today.year != _selectedDate.year ||
        today.month != _selectedDate.month;
    _selectedDate = today;
    if (needsRefetch) {
      fetchAllSchedule();
    } else {
      notifyListeners();
    }
  }

  void setSearchKhoa(String q) {
    _searchKhoa = q.trim();
    notifyListeners();
  }
}
