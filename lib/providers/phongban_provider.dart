import 'package:flutter/material.dart';
import '../data/models/phongban_model.dart';
import '../data/services/phongban_service.dart';


class PhongbanProvider extends ChangeNotifier {
  final PhongbanService _departmentService = PhongbanService();


  List<PhongbanModel> _departments = [];
  List<PhongbanModel> _filteredDepartments = [];
  bool _isLoading = false;
  String? _error;
  String _searchKeyword = '';


  List<PhongbanModel> get departments => _departments;
  List<PhongbanModel> get filteredDepartments => _filteredDepartments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchKeyword => _searchKeyword;
  bool get hasError => _error != null;
  bool get isEmpty => _departments.isEmpty && !_isLoading;


  Future<void> init() async {
    await fetchDepartments();
  }


  Future<void> fetchDepartments() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

  
      final departments = await _departmentService.getDepartments();

      _departments = departments;
      _filteredDepartments = departments;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _departments = [];
      _filteredDepartments = [];
      notifyListeners();
    }
  }

  void searchDepartments(String keyword) {
    _searchKeyword = keyword;

    if (keyword.isEmpty) {
      _filteredDepartments = _departments;
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredDepartments = _departments
          .where((dept) => dept.tenKhoa.toLowerCase().contains(lowerKeyword))
          .toList();
    }

    notifyListeners();
  }

 
  void clearSearch() {
    _searchKeyword = '';
    _filteredDepartments = _departments;
    notifyListeners();
  }


  Future<void> refresh() async {
    await fetchDepartments();
  }

 
  PhongbanModel? getDepartmentById(int idKhoa) {
    try {
      return _departments.firstWhere((dept) => dept.idKhoa == idKhoa);
    } catch (e) {
      return null;
    }
  }
}
