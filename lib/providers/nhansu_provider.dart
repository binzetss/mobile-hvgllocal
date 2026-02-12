import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hvgl/data/models/phongban_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/nhansu_model.dart';
import '../data/services/phongban_service.dart';
import '../data/services/nhansu_service.dart';
import '../data/services/cache_service.dart';
import '../utils/vietnamese_utils.dart';

class NhansuProvider extends ChangeNotifier {
  final PhongbanService _departmentService = PhongbanService();
  final NhansuService _staffService = NhansuService();
  final CacheService _cacheService = CacheService();

  List<PhongbanModel> _departments = [];
  List<NhansuModel> _allStaff = [];
  Map<String, List<NhansuModel>> _staffByDepartment = {};
  Map<String, bool> _loadingDepartments = {};
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
    loadInitStaff();
   _loadDepartmentsFromAPI();
  }

  // load all category

  Future<void> loadStaffByIdDept(String departmentId) async {
    print('Loading staff for department ID: $departmentId');
    try {
      if (_staffByDepartment.containsKey(departmentId)) {
        print(' Staff for department ID $departmentId is already loaded.');
        return;
      }

      _loadingDepartments[departmentId] = true;
      notifyListeners();

      final staffList = await _staffService.getStaffByDepartment(departmentId);
      _staffByDepartment[departmentId] = staffList;

      _loadingDepartments[departmentId] = false;
      notifyListeners();
    } catch (e) {
      debugPrint(' Lỗi khi load nhân sự cho khoa ID $departmentId: $e');
      _loadingDepartments[departmentId] = false;
      notifyListeners();
    }
  }

  Future<void> loadInitStaff() async {
    //  final prefs = await SharedPreferences.getInstance();
    // if (prefs.containsKey('listStaff')) {
    //   final String cachedStaffString = prefs.getString('listStaff') ?? "[]";
    //   final data = jsonDecode(cachedStaffString);
    //   _staffByDepartment = data.map((json) => NhansuModel.fromJson(json)).toList();
    //   return;
    // }
    //   List<Map<String, dynamic>> dataPre = [];
    //  try {
    //     _departments = await _departmentService.getDepartments();
    //    for (var dept in _departments) {
    //       final staffList = await _staffService.getStaffByDepartment(dept.tenKhoa);
    //       _staffByDepartment[dept.tenKhoa] = staffList;
    //    }

    //   //  {"khoa 1" : [model]} => {"khoa 1" : [map]}
    //     dataPre = _allStaff.map((s) => s.toJson(excludeImage: true)).toList();
       

      
    // } catch (e) {
    //   debugPrint(' Lỗi khi load nhân sự cho khoa I');
    // }
    //    await prefs.setString('listStaff', jsonEncode(dataPre));

  }
  


  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final hasCache = await _loadFromCache();

      if (hasCache) {
        _isLoading = false;
        notifyListeners();
        debugPrint(' Đã load từ cache, đang refresh từ API...');
      }

      await _loadDepartmentsFromAPI();

      _isLoading = false;
      notifyListeners();

      debugPrint(' Bắt đầu load staff từ API...');
      _loadAllStaffInBackground();
    } catch (e) {
      debugPrint(' Lỗi khi load dữ liệu: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _loadFromCache() async {
    try {
      final cachedDepts = await _cacheService.getCachedDepartments();
      final cachedStaff = await _cacheService.getCachedStaff();

      if (cachedDepts != null && cachedStaff != null) {
        _departments = cachedDepts.map((json) {
          return PhongbanModel(
            idKhoa: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
            tenKhoa: json['tenKhoa']?.toString() ?? '',
          );
        }).toList();

        _allStaff = cachedStaff.map((json) {
          return NhansuModel.fromJson(json);
        }).toList();

        _groupStaffByDepartmentFromCache();

        debugPrint(
          ' Cache: ${_departments.length} khoa, ${_allStaff.length} nhân viên',
        );
        return true;
      }
    } catch (e) {
      debugPrint(' Lỗi khi load cache: $e');
    }
    return false;
  }

  void _groupStaffByDepartmentFromCache() {
    final Map<String, String> tenKhoaToId = {};
    for (var dept in _departments) {
      tenKhoaToId[dept.tenKhoa] = dept.idKhoa.toString();
    }

    _staffByDepartment = {};
    int matchedCount = 0;
    int unmatchedCount = 0;

    for (var staff in _allStaff) {
      final khoaId = tenKhoaToId[staff.khoaPhongTen];

      if (khoaId != null) {
        matchedCount++;
      } else {
        unmatchedCount++;
        if (unmatchedCount <= 3) {
          debugPrint(' Không tìm thấy ID cho khoa: "${staff.khoaPhongTen}"');
        }
      }

      final finalKhoaId = khoaId ?? staff.khoaPhongTen;

      if (!_staffByDepartment.containsKey(finalKhoaId)) {
        _staffByDepartment[finalKhoaId] = [];
      }
      _staffByDepartment[finalKhoaId]!.add(staff);
    }

    debugPrint(
      ' Mapping cache: $matchedCount matched, $unmatchedCount unmatched',
    );
    debugPrint(' Tạo được ${_staffByDepartment.length} nhóm khoa');
    for (var entry in _staffByDepartment.entries.take(3)) {
      debugPrint(
        '   - Khoa ID "${entry.key}": ${entry.value.length} nhân viên',
      );
    }

    for (var key in _staffByDepartment.keys) {
      _staffByDepartment[key]!.sort((a, b) {
        if (a.isHead && !b.isHead) return -1;
        if (!a.isHead && b.isHead) return 1;
        return a.hoVaTen.compareTo(b.hoVaTen);
      });
    }
  }

  Future<void> _loadDepartmentsFromAPI() async {
    try {
      _departments = await _departmentService.getDepartments();
      notifyListeners();

    } catch (e) {
      rethrow;
    }
  }

  Future<void> _loadAllStaffInBackground() async {
    final oldStaffCount = _allStaff.length;
    final newStaffByDept = <String, List<NhansuModel>>{};
    final newAllStaff = <NhansuModel>[];

    for (var dept in _departments) {
      try {
        debugPrint(' Background load: "${dept.tenKhoa}"');

        final staffList = await _staffService.getStaffByDepartment(
          dept.tenKhoa,
        );

        if (staffList.isNotEmpty) {
          staffList.sort((a, b) {
            if (a.isHead && !b.isHead) return -1;
            if (!a.isHead && b.isHead) return 1;
            return a.hoVaTen.compareTo(b.hoVaTen);
          });

          newStaffByDept[dept.idKhoa.toString()] = staffList;
          newAllStaff.addAll(staffList);

          debugPrint('    ${staffList.length} nhân viên');
        } else {
          newStaffByDept[dept.idKhoa.toString()] = [];
        }
      } catch (e) {
        debugPrint('    Lỗi: $e');
        newStaffByDept[dept.idKhoa.toString()] = [];
      }
    }

    _staffByDepartment = newStaffByDept;
    _allStaff = newAllStaff;

    debugPrint(
      '✅ Hoàn thành load: ${_allStaff.length} nhân viên (cũ: $oldStaffCount)',
    );

    await _saveToCache();

    notifyListeners();
  }

  Future<void> _saveToCache() async {
    try {
      debugPrint(' Đang lưu cache...');

      final deptsJson = _departments
          .map((d) => {'id': d.idKhoa.toString(), 'tenKhoa': d.tenKhoa})
          .toList();
      await _cacheService.cacheDepartments(deptsJson);

      final staffJson = _allStaff
          .map((s) => s.toJson(excludeImage: true))
          .toList();
      await _cacheService.cacheStaff(staffJson);

      debugPrint(
        ' Đã lưu cache: ${deptsJson.length} khoa, ${staffJson.length} nhân viên (không bao gồm hình ảnh)',
      );
    } catch (e) {
      debugPrint(' Lỗi khi lưu cache: $e');
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
    if (name.contains('hoi dong thanh vien') || name.contains('hội đồng thành viên')) {
      return 1;
    }
    if (name.contains('ban giam doc') || name.contains('ban giám đốc')) {
      return 2;
    }
    if (name.contains('cong nghe thong tin') || name.contains('công nghệ thông tin')) {
      return 3;
    }
    return 4;
  }

  List<PhongbanModel> get filteredDepartments {
    List<PhongbanModel> depts;

    if (_searchQuery.isEmpty) {
      depts = List.from(_departments);
    } else {
      depts = _departments.where((dept) {
        final staffInDept = _staffByDepartment[dept.tenKhoa] ?? [];
        final hasMatchingStaff = staffInDept.any(
          (staff) =>
              VietnameseUtils.containsIgnoreDiacritics(
                staff.hoVaTen,
                _searchQuery,
              ) ||
              VietnameseUtils.containsIgnoreDiacritics(
                staff.chucVu,
                _searchQuery,
              ) ||
              VietnameseUtils.containsIgnoreDiacritics(staff.maSo, _searchQuery),
        );
        return VietnameseUtils.containsIgnoreDiacritics(
              dept.tenKhoa,
              _searchQuery,
            ) ||
            hasMatchingStaff;
      }).toList();
    }

    depts.sort((a, b) {
      final priorityA = _getDepartmentPriority(a);
      final priorityB = _getDepartmentPriority(b);

      if (priorityA != priorityB) {
        return priorityA.compareTo(priorityB);
      }

      // Không sort theo số lượng nhân viên để tránh khoa nhảy vị trí khi expand
      return 0;
    });

    return depts;
  }

  List<NhansuModel> getFilteredStaffByDepartment(String departmentId) {
    final staffList = _staffByDepartment[departmentId] ?? [];
    if (_searchQuery.isEmpty) {
      return staffList;
    }

    final department = _departments.firstWhere(
      (dept) => dept.idKhoa.toString() == departmentId,
      orElse: () => PhongbanModel(idKhoa: 0, tenKhoa: ''),
    );

    if (VietnameseUtils.containsIgnoreDiacritics(department.tenKhoa, _searchQuery)) {
      return staffList;
    }

    return staffList
        .where(
          (staff) =>
              VietnameseUtils.containsIgnoreDiacritics(
                staff.hoVaTen,
                _searchQuery,
              ) ||
              VietnameseUtils.containsIgnoreDiacritics(
                staff.chucVu,
                _searchQuery,
              ) ||
              VietnameseUtils.containsIgnoreDiacritics(
                staff.maSo,
                _searchQuery,
              ),
        )
        .toList();
  }

  int get totalStaff => _allStaff.length;
}
