import 'package:flutter/foundation.dart';
import '../data/services/dangky_com_service.dart';

class DangkyComProvider extends ChangeNotifier {
  static DangkyComProvider? _globalInstance;

  static void reloadStatic() {
    _globalInstance?.loadTodayRegistrations();
  }

  DangkyComProvider() {
    _globalInstance = this;
  }

  final DangkyComService _service = DangkyComService();

  bool _isLunchRegistered = false;
  bool _isDinnerRegistered = false;
  bool _isLoadingLunch = false;
  bool _isLoadingDinner = false;
  bool _isInitialLoading = false;

  bool get isLunchRegistered => _isLunchRegistered;
  bool get isDinnerRegistered => _isDinnerRegistered;
  bool get isLoadingLunch => _isLoadingLunch;
  bool get isLoadingDinner => _isLoadingDinner;
  bool get isInitialLoading => _isInitialLoading;

  /// Tải trạng thái đăng ký cơm hôm nay từ server
  Future<void> loadTodayRegistrations() async {
    _isInitialLoading = true;
    notifyListeners();

    final list = await _service.getDangKyTheoNgay(DateTime.now());
    _isLunchRegistered = list.contains(1);
    _isDinnerRegistered = list.contains(2);
    _isInitialLoading = false;
    notifyListeners();
  }

  /// Toggle đăng ký/hủy bữa Trưa — trả về null nếu OK, error message nếu lỗi
  Future<String?> toggleLunch() async {
    _isLoadingLunch = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      if (_isLunchRegistered) {
        await _service.huyDangKy(now, 1);
        _isLunchRegistered = false;
      } else {
        await _service.dangKy(now, 1);
        _isLunchRegistered = true;
      }
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingLunch = false;
      notifyListeners();
    }
  }

  /// Toggle đăng ký/hủy bữa Tối — trả về null nếu OK, error message nếu lỗi
  Future<String?> toggleDinner() async {
    _isLoadingDinner = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      if (_isDinnerRegistered) {
        await _service.huyDangKy(now, 2);
        _isDinnerRegistered = false;
      } else {
        await _service.dangKy(now, 2);
        _isDinnerRegistered = true;
      }
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingDinner = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (_globalInstance == this) _globalInstance = null;
    super.dispose();
  }
}
