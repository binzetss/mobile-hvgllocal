import 'package:flutter/foundation.dart';
import '../data/models/daotao_model.dart';
import '../data/services/daotao_service.dart';

class DaotaoProvider extends ChangeNotifier {
  final DaotaoService _service = DaotaoService();

  List<DaotaoModel> _danhSach = [];
  List<DaotaoModel> _danhSachLoc = [];
  String _tuKhoa = '';
  String _locTrangThai = 'all';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;
  bool _isDisposed = false;

  List<DaotaoModel> get danhSach => _danhSachLoc;
  String get tuKhoa => _tuKhoa;
  String get locTrangThai => _locTrangThai;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isInitialized => _isInitialized;

  int get soLopMoi => _danhSach.where((lop) => lop.isNew).length;
  int get soLopDangMo => _danhSach.where((lop) => lop.dangMoDangKy).length;

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> init() async {
    if (_isInitialized && _danhSach.isNotEmpty) {
      return;
    }
    await fetchDanhSach();
  }

  Future<void> fetchDanhSach() async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      _danhSach = await _service.getDanhSach();
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

  void timKiem(String query) {
    _tuKhoa = query;
    _applyFilters();
    _safeNotifyListeners();
  }

  void locTheoTrangThai(String trangThai) {
    _locTrangThai = trangThai;
    _applyFilters();
    _safeNotifyListeners();
  }

  void _applyFilters() {
    _danhSachLoc = _danhSach;

   
    switch (_locTrangThai) {
      case 'dangMo':
        _danhSachLoc = _danhSachLoc
            .where((lop) => lop.dangMoDangKy)
            .toList();
        break;
      case 'chuaMo':
        _danhSachLoc = _danhSachLoc
            .where((lop) => lop.chuaMoDangKy)
            .toList();
        break;
      case 'hetHan':
        _danhSachLoc = _danhSachLoc
            .where((lop) => lop.hetHanDangKy)
            .toList();
        break;
    }

  
    if (_tuKhoa.isNotEmpty) {
      _danhSachLoc = _danhSachLoc.where((lop) {
        return lop.tenLopDaoTao
            .toLowerCase()
            .contains(_tuKhoa.toLowerCase());
      }).toList();
    }

  
    _danhSachLoc.sort((a, b) => b.ngayBatDau.compareTo(a.ngayBatDau));
  }

  void xoaTimKiem() {
    _tuKhoa = '';
    _applyFilters();
    _safeNotifyListeners();
  }

  void resetFilters() {
    _locTrangThai = 'all';
    _tuKhoa = '';
    _applyFilters();
    _safeNotifyListeners();
  }

  Future<bool> dangKy(int idLopDaoTao) async {
    try {
      final result = await _service.dangKy(idLopDaoTao);
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      _safeNotifyListeners();
      return false;
    }
  }
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);

    if (today == compareDate) {
      return 'Hôm nay';
    }
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  static String formatDateTime(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String getTrangThaiKey(DaotaoModel lopDaoTao) {
    if (lopDaoTao.dangMoDangKy) return 'dangMo';
    if (lopDaoTao.chuaMoDangKy) return 'chuaMo';
    return 'hetHan';
  }

  Future<void> refresh() async {
    await fetchDanhSach();
  }

  void clearCache() {
    _danhSach = [];
    _danhSachLoc = [];
    _locTrangThai = 'all';
    _tuKhoa = '';
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
