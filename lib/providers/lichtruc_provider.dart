import 'package:flutter/material.dart';
import '../data/models/lichtruc_model.dart';

class LichtructProvider extends ChangeNotifier {
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  List<LichtructModel> _allSchedules = [];

  DateTime get currentMonth => _currentMonth;
  List<LichtructModel> get allSchedules => _allSchedules;

  LichtructProvider() {
    _loadSchedules();
  }

  void _loadSchedules() {
    _allSchedules = LichtructModel.getSampleData();
    notifyListeners();
  }

  List<LichtructModel> getMonthSchedules() {
    return _allSchedules.where((schedule) {
      return schedule.date.year == _currentMonth.year &&
          schedule.date.month == _currentMonth.month;
    }).toList();
  }

  void previousMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    notifyListeners();
  }

  void nextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    notifyListeners();
  }

  String getMonthYearText() {
    const months = [
      'Tháng 1',
      'Tháng 2',
      'Tháng 3',
      'Tháng 4',
      'Tháng 5',
      'Tháng 6',
      'Tháng 7',
      'Tháng 8',
      'Tháng 9',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12',
    ];
    return '${months[_currentMonth.month - 1]}, ${_currentMonth.year}';
  }

  int getCompletedShifts() {
    final monthSchedules = getMonthSchedules();
    final now = DateTime.now();
    return monthSchedules.where((s) => s.date.isBefore(now)).length;
  }

  int getUpcomingShifts() {
    final monthSchedules = getMonthSchedules();
    final now = DateTime.now();
    return monthSchedules.where((s) =>
      s.date.isAfter(now) ||
      (s.date.year == now.year &&
       s.date.month == now.month &&
       s.date.day == now.day)
    ).length;
  }
}
