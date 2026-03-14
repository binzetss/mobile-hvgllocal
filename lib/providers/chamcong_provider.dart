import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../core/services/firebase_notification_service.dart';
import '../core/services/home_widget_service.dart';
import '../data/models/chamcong_model.dart';
import '../data/services/chamcong_service.dart';
import './dangky_com_provider.dart';
import './thongbao_provider.dart';

class ChamcongProvider extends ChangeNotifier with WidgetsBindingObserver {
  final ChamcongService _service = ChamcongService();

  static ChamcongProvider? _globalInstance;

  List<ChamcongModel> _monthlyAttendances = [];
  ChamcongModel? _todayAttendance;
  Map<String, dynamic>? _monthlyStats;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _error;
  int _knownTodayPunchCount = 0;
  bool _initialLoadDone = false;
  bool _isFetching = false;
  Timer? _webRefreshTimer;
  Timer? _mobileRefreshTimer;

  ChamcongProvider() {
    _globalInstance = this;
    WidgetsBinding.instance.addObserver(this);
    if (kIsWeb) {
      _webRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        if (_initialLoadDone) refresh();
      });
    } else {
      _mobileRefreshTimer = Timer.periodic(const Duration(minutes: 2), (_) {
        if (_initialLoadDone) refresh();
      });
    }
  }


  static void initAfterLoginStatic() {
    _globalInstance?.init();
  }


  static void resetOnLogoutStatic() {
    _globalInstance?._resetState();
  }

  void _resetState() {
    _monthlyAttendances = [];
    _todayAttendance = null;
    _monthlyStats = null;
    _knownTodayPunchCount = 0;
    _initialLoadDone = false;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  List<ChamcongModel> get monthlyAttendances => _monthlyAttendances;
  ChamcongModel? get todayAttendance => _todayAttendance;
  Map<String, dynamic>? get monthlyStats => _monthlyStats;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _initialLoadDone) {
      debugPrint('ChamCong: app resumed, refreshing...');
      refresh();
    }
  }

  static Map<String, dynamic> _computeStats(List<ChamcongModel> list) {
    int presentDays = 0;
    int absentDays = 0;
    for (final a in list) {
      if (a.status == ChamcongStatus.weekend ||
          a.status == ChamcongStatus.holiday) {
        continue;
      }
      if (a.status == ChamcongStatus.present ||
          a.status == ChamcongStatus.late) {
        presentDays++;
      } else if (a.status == ChamcongStatus.absent) {
        absentDays++;
      }
    }
    return {
      'presentDays': presentDays,
      'lateDays': 0,
      'absentDays': absentDays,
      'earlyLeaveDays': 0,
      'totalWorkingHours': 0.0,
      'totalWorkingDays': presentDays + absentDays,
    };
  }

  void _updateTodayFromList(List<ChamcongModel> list) {
    final now = DateTime.now();
    try {
      _todayAttendance = list.firstWhere(
        (a) =>
            a.date.year == now.year &&
            a.date.month == now.month &&
            a.date.day == now.day,
      );
    } catch (_) {
      _todayAttendance = null;
    }
  }

  void _checkAndNotifyNewPunches() {
    final newCount = _todayAttendance?.punches.length ?? 0;
    if (!_initialLoadDone) {
      _knownTodayPunchCount = newCount;
      _initialLoadDone = true;
      debugPrint('ChamCong: initial load done, knownPunchCount=$newCount');
      return;
    }
    if (newCount > _knownTodayPunchCount) {
      final newPunches =
          _todayAttendance!.punches.skip(_knownTodayPunchCount).toList();
      debugPrint(
          'ChamCong: ${newPunches.length} new punch(es) detected, firing notifications');
      for (final punch in newPunches) {
        FirebaseNotificationService().showChamcongNotification(
          time: punch.time,
          loai: punch.loaiChamCong,
        );
        ThongBaoProvider.addChamcongStatic(
          time: punch.time,
          loai: punch.loaiChamCong,
        );

        if (punch.loaiChamCong == 'Chấm cơm' ||
            punch.loaiChamCong == 'Chấm thư viện') {
          DangkyComProvider.reloadStatic();
        }
      }
    }
    _knownTodayPunchCount = newCount;
  }

  Future<void> init() async {
    if (_monthlyAttendances.isNotEmpty && _error == null) {

      refresh();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();
    await _fetchAndUpdate(_selectedDate.year, _selectedDate.month);
  }

  Future<void> _fetchAndUpdate(int year, int month) async {
    if (_isFetching) return;
    _isFetching = true;
    try {
      final attendances = await _service.getAttendanceByMonth(year, month);
      _monthlyAttendances = attendances;
      _monthlyStats = _computeStats(attendances);
      final now = DateTime.now();
      if (year == now.year && month == now.month) {
        _updateTodayFromList(attendances);
        _checkAndNotifyNewPunches();
        _updateHomeWidget();
      }
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      debugPrint('ChamCong fetch error: $e');
      notifyListeners();
    } finally {
      _isFetching = false;
    }
  }

  Future<void> changeMonth(int year, int month) async {
    _selectedDate = DateTime(year, month, 1);
    _isLoading = true;
    _error = null;
    notifyListeners();
    await _fetchAndUpdate(year, month);
  }

  Future<void> refresh() async {
    debugPrint('ChamCong: silent refresh...');
    await _fetchAndUpdate(_selectedDate.year, _selectedDate.month);
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  ChamcongModel? getAttendanceByDate(DateTime date) {
    try {
      return _monthlyAttendances.firstWhere(
        (a) =>
            a.date.year == date.year &&
            a.date.month == date.month &&
            a.date.day == date.day,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> loadMonthData(int year, int month) => changeMonth(year, month);

  void _updateHomeWidget() {
    final att = _todayAttendance;
    final punches = att?.punches ?? [];
    HomeWidgetService.updateAttendance(
      checkin: punches.isNotEmpty ? _fmt(punches.first.time) : null,
      checkout: punches.length > 1 ? _fmt(punches.last.time) : null,
      punches: punches
          .map((p) => {'time': _fmt(p.time), 'type': p.loaiChamCong})
          .toList(),
    );
  }

  static String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Future<void> loadTodayAttendance() async {
    final now = DateTime.now();
    if (_selectedDate.year == now.year && _selectedDate.month == now.month) {
      _updateTodayFromList(_monthlyAttendances);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _webRefreshTimer?.cancel();
    _mobileRefreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
