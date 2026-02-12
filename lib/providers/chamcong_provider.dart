import 'package:flutter/material.dart';
import '../data/models/chamcong_model.dart';
import '../data/services/chamcong_service.dart';

class ChamcongProvider extends ChangeNotifier {
  final ChamcongService _attendanceService = ChamcongService();

  List<ChamcongModel> _monthlyAttendances = [];
  ChamcongModel? _todayAttendance;
  Map<String, dynamic>? _monthlyStats;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _error;

  List<ChamcongModel> get monthlyAttendances => _monthlyAttendances;
  ChamcongModel? get todayAttendance => _todayAttendance;
  Map<String, dynamic>? get monthlyStats => _monthlyStats;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init() async {
    await loadMonthData(_selectedDate.year, _selectedDate.month);
    await loadTodayAttendance();
  }

  Future<void> loadMonthData(int year, int month) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final attendances = await _attendanceService.getAttendanceByMonth(year, month);
      final stats = await _attendanceService.getMonthlyStats(year, month);

      _monthlyAttendances = attendances;
      _monthlyStats = stats;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTodayAttendance() async {
    try {
      final attendance = await _attendanceService.getTodayAttendance();
      _todayAttendance = attendance;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> changeMonth(int year, int month) async {
    _selectedDate = DateTime(year, month, 1);
    await loadMonthData(year, month);
  }

  ChamcongModel? getAttendanceByDate(DateTime date) {
    try {
      return _monthlyAttendances.firstWhere(
        (a) =>
            a.date.year == date.year &&
            a.date.month == date.month &&
            a.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> refresh() async {
    await loadMonthData(_selectedDate.year, _selectedDate.month);
    await loadTodayAttendance();
  }
}
