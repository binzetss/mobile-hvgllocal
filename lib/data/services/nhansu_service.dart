import 'package:flutter/foundation.dart';
import '../models/nhansu_model.dart';
import '../../core/constants/api_endpoints.dart';
import 'api_service.dart';

class NhansuService {
  static final NhansuService _instance = NhansuService._internal();
  factory NhansuService() => _instance;
  NhansuService._internal();

  final ApiService _apiService = ApiService();

  Future<List<NhansuModel>> getStaff({String maSo = ''}) async {
    final body = maSo.isNotEmpty ? {'maSo': maSo} : <String, dynamic>{};

    debugPrint('API Request - Nhân viên: ${ApiEndpoints.danhSachNhanVien}');
    debugPrint('Body: $body');

    final response = await _apiService.post(
      ApiEndpoints.danhSachNhanVien,
      body,
      requiresAuth: true,
    );

    final List<dynamic> jsonList = response['data'] as List<dynamic>? ?? [];
    debugPrint('Nhận được ${jsonList.length} nhân viên');

    return jsonList
        .map((item) => NhansuModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<NhansuModel>> getAllStaff() async {
    return await getStaff();
  }

  Future<List<NhansuModel>> getStaffByDepartment(String khoaPhongId) async {
    return await getStaff();
  }

  Future<List<NhansuModel>> searchStaff(String keyword) async {
    return await getStaff(maSo: keyword);
  }
}
