import 'package:flutter/material.dart';
import 'package:hvgl/data/models/phongban_model.dart';
import '../data/models/nhansu_model.dart';
import '../data/services/nhansu_service.dart';
import '../data/services/cache_service.dart';
import '../utils/vietnamese_utils.dart';

class NhansuProvider extends ChangeNotifier {
  final NhansuService _staffService = NhansuService();
  final CacheService _cacheService = CacheService();

  List<PhongbanModel> _departments = [];
  List<NhansuModel> _allStaff = [];
  Map<String, List<NhansuModel>> _staffByDepartment = {};
  final Map<String, bool> _loadingDepartments = {};
  Set<String> _expandedDepartments = {};
  String _searchQuery = '';
  bool _isLoading = false;

  List<PhongbanModel> get departments => _departments;
  List<NhansuModel> get allStaff => _allStaff;
  Map<String, List<NhansuModel>> get staffByDepartment => _staffByDepartment;
  Set<String> get expandedDepartments => _expandedDepartments;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  bool isLoadingDepartment(String departmentId) {
    return _loadingDepartments[departmentId] ?? false;
  }

  NhansuProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    await _loadFromCache();
    if (_allStaff.isNotEmpty) {
      _isLoading = false;
      notifyListeners();
    }

    try {
      final staffList = await _staffService.getAllStaff();
      _buildFromStaffList(staffList);
      await _saveToCache();
    } catch (e) {
      debugPrint('Lỗi khi tải danh sách nhân viên: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void _buildFromStaffList(List<NhansuModel> staffList) {
    _allStaff = staffList;

    final Map<String, List<NhansuModel>> grouped = {};
    for (var staff in staffList) {
      final key = staff.khoaPhongTen.isNotEmpty ? staff.khoaPhongTen : 'Chưa phân loại';
      grouped.putIfAbsent(key, () => []).add(staff);
    }

    for (var list in grouped.values) {
      list.sort((a, b) {
        if (a.isHead && !b.isHead) return -1;
        if (!a.isHead && b.isHead) return 1;
        return a.hoVaTen.compareTo(b.hoVaTen);
      });
    }

    _staffByDepartment = grouped;
    _departments = grouped.keys
        .map((name) => PhongbanModel(idKhoa: 0, tenKhoa: name))
        .toList();
  }

  Future<void> refresh() => _init();

  Future<void> loadStaffByIdDept(String departmentId) async {
    if (_staffByDepartment.containsKey(departmentId)) return;
  }

  Future<void> _loadFromCache() async {
    try {
      final cachedStaff = await _cacheService.getCachedStaff();
      if (cachedStaff != null && cachedStaff.isNotEmpty) {
        final staffList = cachedStaff
            .map((json) => NhansuModel.fromJson(json))
            .toList();
        _buildFromStaffList(staffList);
        debugPrint('Cache: ${staffList.length} nhân viên');
      }
    } catch (e) {
      debugPrint('Lỗi khi load cache: $e');
    }
  }

  Future<void> _saveToCache() async {
    try {
      final staffJson = _allStaff.map((s) => s.toJson()).toList();
      await _cacheService.cacheStaff(staffJson);
      debugPrint('Đã lưu cache: ${staffJson.length} nhân viên');
    } catch (e) {
      debugPrint('Lỗi khi lưu cache: $e');
    }
  }

  void toggleDepartment(String departmentId) {
    if (_expandedDepartments.contains(departmentId)) {
      _expandedDepartments.remove(departmentId);
    } else {
      _expandedDepartments.add(departmentId);
    }
    notifyListeners();
  }

  void expandAll() {
    _expandedDepartments = _departments.map((d) => d.tenKhoa).toSet();
    notifyListeners();
  }

  void collapseAll() {
    _expandedDepartments = {};
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    if (_searchQuery.isNotEmpty) {
      _expandedDepartments = _departments.map((dept) => dept.tenKhoa).toSet();
    } else {
      _expandedDepartments = {};
    }
    notifyListeners();
  }

  int _getDepartmentPriority(PhongbanModel dept) {
    final name = dept.tenKhoa.toLowerCase();
    if (name.contains('hội đồng thành viên')) return 1;
    if (name.contains('ban giám đốc')) return 2;
    if (name.contains('công nghệ thông tin')) return 3;
    if (name == 'chưa phân loại') return 99;
    return 4;
  }

  List<PhongbanModel> get filteredDepartments {
    List<PhongbanModel> depts;

    if (_searchQuery.isEmpty) {
      depts = List.from(_departments);
    } else {
      final filtered = _departments.where((dept) {
        final staffInDept = _staffByDepartment[dept.tenKhoa] ?? [];
        final hasMatchingStaff = staffInDept.any(
          (staff) =>
              VietnameseUtils.containsIgnoreDiacritics(staff.hoVaTen, _searchQuery) ||
              VietnameseUtils.containsIgnoreDiacritics(staff.chucVu, _searchQuery) ||
              VietnameseUtils.containsIgnoreDiacritics(staff.maSo, _searchQuery),
        );
        return VietnameseUtils.containsIgnoreDiacritics(dept.tenKhoa, _searchQuery) || hasMatchingStaff;
      }).toList();
      depts = filtered.isEmpty ? List.from(_departments) : filtered;
    }

    depts.sort((a, b) {
      final priorityA = _getDepartmentPriority(a);
      final priorityB = _getDepartmentPriority(b);
      if (priorityA != priorityB) return priorityA.compareTo(priorityB);
      return 0;
    });

    return depts;
  }

  List<NhansuModel> getFilteredStaffByDepartment(String departmentKey) {
    final staffList = _staffByDepartment[departmentKey] ?? [];
    if (_searchQuery.isEmpty) return staffList;

    final dept = _departments.firstWhere(
      (d) => d.tenKhoa == departmentKey,
      orElse: () => PhongbanModel(idKhoa: 0, tenKhoa: ''),
    );

    if (VietnameseUtils.containsIgnoreDiacritics(dept.tenKhoa, _searchQuery)) {
      return staffList;
    }

    return staffList.where(
      (staff) =>
          VietnameseUtils.containsIgnoreDiacritics(staff.hoVaTen, _searchQuery) ||
          VietnameseUtils.containsIgnoreDiacritics(staff.chucVu, _searchQuery) ||
          VietnameseUtils.containsIgnoreDiacritics(staff.maSo, _searchQuery),
    ).toList();
  }

  List<NhansuModel> get filteredStaff {
    if (_searchQuery.isEmpty) return _allStaff;
    final results = _allStaff.where((staff) =>
      VietnameseUtils.containsIgnoreDiacritics(staff.hoVaTen, _searchQuery) ||
      VietnameseUtils.containsIgnoreDiacritics(staff.chucVu, _searchQuery) ||
      VietnameseUtils.containsIgnoreDiacritics(staff.maSo, _searchQuery),
    ).toList();
    return results.isEmpty ? _allStaff : results;
  }

  bool get isSearchByEmployee {
    if (_searchQuery.isEmpty) return false;
    final matchesDept = _departments.any(
      (dept) => VietnameseUtils.containsIgnoreDiacritics(dept.tenKhoa, _searchQuery),
    );
    return !matchesDept;
  }

  int get totalStaff => _allStaff.length;
}
