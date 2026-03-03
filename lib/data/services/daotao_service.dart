import 'package:flutter/foundation.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/daotao_model.dart';
import '../services/xacthuc_service.dart';
import 'api_service.dart';

class DaotaoService {
  final ApiService _apiService = ApiService();
  final XacthucService _xacthucService = XacthucService();

  Future<String> _getMaSo() async {
    final user = await _xacthucService.getSavedUser();
    return user?.maSo ?? '';
  }

  Future<List<DaotaoModel>> getDanhSach() async {
    try {
      final maSo = await _getMaSo();
      debugPrint('Lấy danh sách đào tạo: maSo=$maSo');

      final response = await _apiService.fetchData(
        ApiEndpoints.lopDaoTao,
        {'maSo': maSo},
        requiresAuth: true,
      );

      debugPrint('Response danh sách đào tạo: $response');

      if (response['data'] != null) {
        final List<dynamic> dataList = response['data'];
        return dataList.map((json) => DaotaoModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Lỗi khi tải danh sách đào tạo: $e');
    }
  }

  Future<DaotaoModel?> getChiTiet(int id) async {
    final danhSach = await getDanhSach();
    try {
      return danhSach.firstWhere((item) => item.idLopDaoTao == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> dangKy(int idLopDaoTao) async {
    try {
      final maSo = await _getMaSo();
      debugPrint('Đăng ký: idLopDaoTao=$idLopDaoTao, maSo=$maSo');

      final response = await _apiService.fetchData(
        ApiEndpoints.dangKyDaoTao,
        {'idLopDaoTao': idLopDaoTao, 'maSo': maSo},
        requiresAuth: true,
      );

      debugPrint('Response đăng ký: $response');

      if (response['success'] != true) {
        final message = response['message']?.toString() ?? 'Đăng ký thất bại';
        throw Exception(message);
      }

      return true;
    } catch (e) {
      debugPrint('Lỗi dangKy: $e');
      rethrow;
    }
  }

  Future<bool> huyDangKy(int idLopDaoTao) async {
    try {
      final maSo = await _getMaSo();
      debugPrint('Hủy đăng ký: idLopDaoTao=$idLopDaoTao, maSo=$maSo');

      final response = await _apiService.deleteWithBody(
        ApiEndpoints.huyDangKyDaoTao,
        {
          'idLopDaoTao': idLopDaoTao,
          'maSo': maSo,
        },
        requiresAuth: true,
      );

      debugPrint('Response hủy đăng ký: $response');

      if (response['success'] != true) {
        final message = response['message']?.toString() ?? 'Hủy đăng ký thất bại';
        throw Exception(message);
      }

      return true;
    } catch (e) {
      debugPrint('Lỗi huyDangKy: $e');
      rethrow;
    }
  }
}
