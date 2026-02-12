import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/luong_model.dart';

class LuongProvider extends ChangeNotifier {
  String _selectedMonth = '';
  List<String> _availableMonths = [];
  LuongInfo? _salaryData;

  final currencyFormat = NumberFormat('#,###');

  String get selectedMonth => _selectedMonth;
  List<String> get availableMonths => _availableMonths;
  LuongInfo? get salaryData => _salaryData;

  LuongProvider() {
    _initMonths();
    _loadSalaryData();
  }

  void _initMonths() {
    final now = DateTime.now();
    _availableMonths = [];
    for (int i = 0; i < 12; i++) {
      final date = DateTime(now.year, now.month - i, 1);
      final monthStr = '${date.month.toString().padLeft(2, '0')}/${date.year}';
      _availableMonths.add(monthStr);
    }
    _selectedMonth = _availableMonths.first;
  }

  void _loadSalaryData() {
    _salaryData = LuongInfo.sampleData(_selectedMonth);
    notifyListeners();
  }

  void onMonthChanged(String month) {
    _selectedMonth = month;
    _loadSalaryData();
  }

  String formatCurrency(double value) {
    return currencyFormat.format(value);
  }

  String formatValue({
    required double value,
    bool isWorkday = false,
    bool isPercent = false,
  }) {
    if (isWorkday) {
      return value.toStringAsFixed(1);
    } else if (isPercent) {
      return '${value.toStringAsFixed(1)}%';
    } else {
      return formatCurrency(value);
    }
  }
}
